#!/usr/bin/env python
#############################################################################
# DO NOT EDIT LOCALLY!!!!!!!
#
# WARNING: This file is controlled centrally, any changes made in the command
# adaptor repository will be overwritten by the RepoSync process.  See
# https://gitlab.digital.homeoffice.gov.uk/dacc-de/dde-adaptor-reposync
#############################################################################
import logging
import os
from pathlib import Path
import sys
import time
import urllib.error
import urllib.request

import boto3
import redis
from botocore.client import ClientError
from confluent_kafka.admin import AdminClient, NewTopic

KAFDROP_TEST_URL = "http://kafdrop:9000/actuator/health"
REPLICATION_FACTOR = 1
SCHEMA_REGISTRY_TEST_URL = "http://schema-registry:8081/subjects"

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(sys.argv[0])

if "ADAPTOR_NAME" not in os.environ or len(os.environ["ADAPTOR_NAME"]) == 0:
    logging.error("The ADAPTOR_NAME environment variable is not set.")
    sys.exit(2)

ADAPTOR_NAME = os.environ["ADAPTOR_NAME"]
logger.info(f"FDP Application Name = {ADAPTOR_NAME}")
TOPIC_SUFFIX = os.environ.get("FDP_APP_KAFKA_TOPIC_SUFFIX", "0")
TOPIC_TEMPLATE_PATH = Path("/usr/local/bin/topic-templates.txt")

if ADAPTOR_NAME == "crs":
    PARTITIONS = 3
else:
    PARTITIONS = 1


def create_kafka_topics(bootstrap_servers, topics):
    topic_config = {"compression.type": "snappy", "retention.ms": 94867200000}
    topics_list = []

    connected = False

    while not connected:
        try:
            logger.info(f"Attempting to connect to {bootstrap_servers}")
            admin_client = AdminClient({"bootstrap.servers": bootstrap_servers})
            logger.info(f"Connected successfully to {bootstrap_servers}")
            connected = True
        except Exception as e:
            logger.error(e)
            time.sleep(1)

    for topic_name in topics:
        logger.info(f"Creating Kafka topic {topic_name} with {PARTITIONS} partitions.")
        topics_list.append(
            NewTopic(
                topic_name,
                num_partitions=PARTITIONS,
                replication_factor=REPLICATION_FACTOR,
                config=topic_config,
            )
        )

    fs = admin_client.create_topics(topics_list)

    # Wait for operation to finish.
    # Timeouts are preferably controlled by passing request_timeout=15.0
    # to the create_topics() call.
    # All futures will finish at the same time.
    for topic, f in fs.items():
        try:
            f.result()  # The result itself is None
            logger.info("Kafka Topic {} created".format(topic))
        except Exception as err:
            logger.error("Failed to Kafka create topic {}: {}".format(topic, err))


def get_wait_check():
    """
    Find out what stage of the container startup we're waiting for.

    str:
        The name of the stage.
    """
    if "WAIT_CHECK" in os.environ:
        return os.environ["WAIT_CHECK"]

    logger.warning("WAIT_CHECK not found in os.environ")

    if "STARTUP_STAGE" not in os.environ:
        logging.error("STARTUP_STAGE not found in os.environ")
        sys.exit(2)

    startup_stage = os.environ["STARTUP_STAGE"]

    if startup_stage == "":
        startup_stage = "1"

    wait_check_translation = {
        "1": "redis_kafka",
        "2": "command_adaptor",
        "3": "aggregators",
    }
    return wait_check_translation[startup_stage]


def s3_setup(s3_endpoint_url):
    """
    Setup S3 resources.

    Parameters
    ----------
    s3_endpoint_url : str
        The url to the s3 URL.
    """
    logger.info(f"s3_setup - s3_endpoint_url={s3_endpoint_url}")
    aws_access_key_id = os.environ["AWS_ACCESS_KEY_ID"]
    aws_secret_access_key = os.environ["AWS_SECRET_ACCESS_KEY"]
    aws_region = os.environ["AWS_REGION"]
    logger.info(f"s3_setup - AWS Region = {aws_region}")
    s3_bucket = os.environ["S3_BUCKET"]
    s3 = boto3.resource(
        "s3",
        aws_access_key_id=aws_access_key_id,
        aws_secret_access_key=aws_secret_access_key,
        endpoint_url=s3_endpoint_url,
        region_name=aws_region,
        use_ssl=False,
    )

    try:
        s3.meta.client.head_bucket(Bucket=s3_bucket)
        logger.info(f"s3_setup - bucket {s3_bucket} already exists.")
    except ClientError:
        # The bucket does not exist or you have no access.
        s3.create_bucket(Bucket=s3_bucket)
        logger.info(f"s3_setup = bucket {s3_bucket} created.")


def wait_for_http(url, title, sleep_time=10, attempts=0, expected_response_codes=[200]):
    """
    Wait for an HTTP service to start responding with non-error return status.

    Parameters
    ----------
    url : str
        The URL to be monitored.
    title : str
        The title of the service to be placed into the event log.
    sleep_time : int
        The number of seconds to wait between checks (default 10).
    attempts : int,optional
        The number of attempts to try the connection.  If zero test to infinity.  Default
        is zero.
    expected_response_codes : list of int
        The expected HTTP response code that indicates AOK.

    Returns
    -------

    """
    url_connected = False

    if attempts:
        remaining_attempts = attempts
    else:
        remaining_attempts = sys.maxsize

    not_ready_message = f"{title} is not ready, will check again in "
    not_ready_message += f"{sleep_time} seconds."

    while not url_connected and remaining_attempts > 0:
        try:
            urllib.request.urlopen(url)
            logger.info(f"{title} ({url}) is ready.")
            url_connected = True
        except urllib.error.HTTPError as e:
            if e.code not in expected_response_codes:
                logger.info(not_ready_message)
                time.sleep(sleep_time)
            else:
                url_connected = True
        except urllib.error.URLError:
            logger.info(not_ready_message)
            time.sleep(sleep_time)

        if attempts:
            remaining_attempts -= 1

    assert url_connected, f"Timed out waiting for {url} to be ready."


def load_shared_topic_templates(template_path, topic_suffix):
    topic_names_local = []

    if not template_path.exists():
        raise FileNotFoundError(f"Shared topic template file not found: {template_path}")

    with template_path.open("r", encoding="utf-8") as f:
        for raw_line in f:
            line = raw_line.strip()
            if not line or line.startswith("#"):
                continue
            topic_names_local.append(line.replace("{suffix}", topic_suffix))

    logger.info(
        "Loaded %s shared topic templates from %s with suffix '%s'",
        len(topic_names_local),
        template_path,
        topic_suffix,
    )
    return topic_names_local


topic_names = load_shared_topic_templates(TOPIC_TEMPLATE_PATH, TOPIC_SUFFIX)

# Input topics.
if ADAPTOR_NAME == "brp":
    topic_names.append(f"fdp-{ADAPTOR_NAME}-input-ic_0")
    topic_names.append(f"fdp-{ADAPTOR_NAME}-input-os_0")
elif ADAPTOR_NAME == "centaur":
    topic_names.append("fdp-centaur-input-cerberuseventnominals_0")
    topic_names.append("fdp-centaur-input-cerberusevents_0")
    topic_names.append("fdp-centaur-input-cerberusitems_0")
    topic_names.append("fdp-centaur-input-cerberuslinks_0")
    topic_names.append("fdp-centaur-input-cerberusnominals_0")
elif ADAPTOR_NAME == "cop":
    topic_names.append("fdp-cop-input-casheabsilver_0")
    topic_names.append("fdp-cop-input-cerberusfeedbackgold_0")
    topic_names.append("fdp-cop-input-cerberusoutcomesgold_0")
    topic_names.append("fdp-cop-input-consignmentdetailseabsilver_0")
    topic_names.append("fdp-cop-input-firearmseabsilver_0")
    topic_names.append("fdp-cop-input-itemseabsilver_0")
    topic_names.append("fdp-cop-input-journeyeabsilver_0")
    topic_names.append("fdp-cop-input-negativeeabsilver_0")
    topic_names.append("fdp-cop-input-peopleeabsilver_0")
    topic_names.append("fdp-cop-input-recordbordereventsilver_0")
elif ADAPTOR_NAME == "crs":
    topic_names.append("fdp-crs-input-addressapplication_0")
    topic_names.append("fdp-crs-input-addresssponsor_0")
    topic_names.append("fdp-crs-input-application_0")
    topic_names.append("fdp-crs-input-applicationdependant_0")
    topic_names.append("fdp-crs-input-applicationeventnotes_0")
    topic_names.append("fdp-crs-input-applicationminor_0")
    topic_names.append("fdp-crs-input-applicationsponsor_0")
    topic_names.append("fdp-crs-input-biodetails_0")
    topic_names.append("fdp-crs-input-groupapplicationapplicationnamedperson_0")
    topic_names.append("fdp-crs-input-groupapplication_0")
    topic_names.append("fdp-crs-input-linkedapplication_0")
    topic_names.append("fdp-crs-input-namedperson_0")
    topic_names.append("fdp-crs-input-passport_0")
    topic_names.append("fdp-crs-input-relatedperson_0")
    topic_names.append("fdp-crs-input-sponsor_0")
    topic_names.append("input-crsv2.crs_v2.groupapplication")
elif ADAPTOR_NAME == "crsa":
    topic_names.append("fdp-crsa-input-applicationlogged_0")
    topic_names.append("fdp-crsa-input-searchevent_0")
    topic_names.append("input-crsauditv1.crs_audit_v1.ac_auditlog")
    topic_names.append("input-crsauditv1.crs_audit_v1.auditlog")
elif ADAPTOR_NAME == "ctp":
    topic_names.append("fdp-ctp-lookup-product-desc")
    topic_names.append("fdp-ctp-invalid-lookup")
    topic_names.append("fdp-ctp-suspense-lookup")
    topic_names.append("fdp-ctp-suspense-garbage")
    topic_names.append("fdp-ctp-input_0")
    # this 2 topics we will be only used for dev integration testing of ctp-reporting
    topic_names.append("runlog-ctp-bulk-processing")
    topic_names.append("fdp-ctp-reporting-output")
elif ADAPTOR_NAME == "dvla":
    topic_names.append("fdp-dvla-input_0")
    topic_names.append("landing-dvla-trailer-registration_0")
    topic_names.append("landing-dvla-trailer-disposal_0")
elif ADAPTOR_NAME == "iabs":
    topic_names.append(f"fdp-{ADAPTOR_NAME}-input-biog_0")
    topic_names.append(f"fdp-{ADAPTOR_NAME}-input-docs_0")
    topic_names.append(f"fdp-{ADAPTOR_NAME}-input-applic_0")
elif ADAPTOR_NAME == "pcdp":
    # PCDP r36 input topics
    topic_names.append("fdp-pcdp-input-address_0")
    topic_names.append("fdp-pcdp-input-address-join_0")
    topic_names.append("fdp-pcdp-input-all-event-attribute_0")
    topic_names.append("fdp-pcdp-input-artefact_0")
    topic_names.append("fdp-pcdp-input-artefact-join_0")
    topic_names.append("fdp-pcdp-input-association_0")
    topic_names.append("fdp-pcdp-input-atlas-artefact-identity_0")
    topic_names.append("fdp-pcdp-input-biographic-set_0")
    topic_names.append("fdp-pcdp-input-biometric_0")
    topic_names.append("fdp-pcdp-input-cid-artefact-identity_0")
    topic_names.append("fdp-pcdp-input-cid-crs-all-event-attribute_0")
    topic_names.append("fdp-pcdp-input-condition_0")
    topic_names.append("fdp-pcdp-input-crs-ingest-join-address_0")
    topic_names.append("fdp-pcdp-input-electronic-address_0")
    topic_names.append("fdp-pcdp-input-identity_0")
    topic_names.append("fdp-pcdp-input-identity-consolidated-person_0")
    topic_names.append("fdp-pcdp-input-ie-bail_0")
    topic_names.append("fdp-pcdp-input-ie-barrier-action_0")
    topic_names.append("fdp-pcdp-input-ie-border-casework_0")
    topic_names.append("fdp-pcdp-input-ie-charter-flights_0")
    topic_names.append("fdp-pcdp-input-ie-chief-caseworking-unit_0")
    topic_names.append("fdp-pcdp-input-ie-close_0")
    topic_names.append("fdp-pcdp-input-ie-core_0")
    topic_names.append("fdp-pcdp-input-ie-decision_0")
    topic_names.append("fdp-pcdp-input-ie-detention_0")
    topic_names.append("fdp-pcdp-input-ie-electronic-monitoring_0")
    topic_names.append("fdp-pcdp-input-ie-enforce-activity_0")
    topic_names.append("fdp-pcdp-input-ie-marriage-referral_0")
    topic_names.append("fdp-pcdp-input-ie-movement_0")
    topic_names.append("fdp-pcdp-input-ie-offence_0")
    topic_names.append("fdp-pcdp-input-ie-reporting_0")
    topic_names.append("fdp-pcdp-input-ie-returns-removal-notices_0")
    topic_names.append("fdp-pcdp-input-ie-travel-document_0")
    topic_names.append("fdp-pcdp-input-ie-travel_0")
    topic_names.append("fdp-pcdp-input-ie-voluntary-return-expense_0")
    topic_names.append("fdp-pcdp-input-ie-voluntary-return_0")
    topic_names.append("fdp-pcdp-input-individual_0")
    topic_names.append("fdp-pcdp-input-involvement_0")
    topic_names.append("fdp-pcdp-input-involvement-address_0")
    topic_names.append("fdp-pcdp-input-organisation_0")
    topic_names.append("fdp-pcdp-input-person_0")
    topic_names.append("fdp-pcdp-input-reference_0")
    topic_names.append("fdp-pcdp-input-service-delivery_0")
    topic_names.append("fdp-pcdp-input-ukvi-age-assessment_0")
    topic_names.append("fdp-pcdp-input-ukvi-asylum-claim_0")
    topic_names.append("fdp-pcdp-input-ukvi-asylum-support_0")
    topic_names.append("fdp-pcdp-input-ukvi-british-national-overseas_0")
    topic_names.append("fdp-pcdp-input-ukvi-card_0")
    topic_names.append("fdp-pcdp-input-ukvi-core_0")
    topic_names.append("fdp-pcdp-input-ukvi-destitute-domestic-violence_0")
    topic_names.append("fdp-pcdp-input-ukvi-electronic-travel-authorisation_0")
    topic_names.append("fdp-pcdp-input-ukvi-endorsement_0")
    topic_names.append("fdp-pcdp-input-ukvi-eus_0")
    topic_names.append("fdp-pcdp-input-ukvi-exclusion-order_0")
    topic_names.append("fdp-pcdp-input-ukvi-exempt-diplomat_0")
    topic_names.append("fdp-pcdp-input-ukvi-family-human-rights_0")
    topic_names.append("fdp-pcdp-input-ukvi-family-reunion_0")
    topic_names.append("fdp-pcdp-input-ukvi-fee-waiver_0")
    topic_names.append("fdp-pcdp-input-ukvi-frontier-worker_0")
    topic_names.append("fdp-pcdp-input-ukvi-further-leave-to-remain_0")
    topic_names.append("fdp-pcdp-input-ukvi-further-submissions_0")
    topic_names.append("fdp-pcdp-input-ukvi-graduate_0")
    topic_names.append("fdp-pcdp-input-ukvi-high-potential-individual_0")
    topic_names.append("fdp-pcdp-input-ukvi-home-office-travel-document_0")
    topic_names.append("fdp-pcdp-input-ukvi-ie-challenge_0")
    topic_names.append("fdp-pcdp-input-ukvi-ie-cid-ingest-address-event_0")
    topic_names.append("fdp-pcdp-input-ukvi-ie-cid-ingest-appeals-event_0")
    topic_names.append("fdp-pcdp-input-ukvi-ie-cid-ingest-arrivals-event_0")
    topic_names.append("fdp-pcdp-input-ukvi-ie-cid-ingest-barriers-event_0")
    topic_names.append("fdp-pcdp-input-ukvi-ie-cid-ingest-cases-event_0")
    topic_names.append("fdp-pcdp-input-ukvi-ie-cid-ingest-documents-event_0")
    topic_names.append("fdp-pcdp-input-ukvi-ie-cid-ingest-event_0")
    topic_names.append("fdp-pcdp-input-ukvi-ie-cid-ingest-person-event_0")
    topic_names.append("fdp-pcdp-input-ukvi-ie-cid-ingest-notes-event_0")
    topic_names.append("fdp-pcdp-input-ukvi-ie-cid-ingest-removal-event_0")
    topic_names.append("fdp-pcdp-input-ukvi-ie-cid-ingest-restriction-event_0")
    topic_names.append("fdp-pcdp-input-ukvi-ie-cid-ingest-special-conditions-event_0")
    topic_names.append("fdp-pcdp-input-ukvi-ie-cross-domain_0")
    topic_names.append("fdp-pcdp-input-ukvi-ie-crs-ingest-event_0")
    topic_names.append("fdp-pcdp-input-ukvi-ie-denormalised-event_0")
    topic_names.append("fdp-pcdp-input-ukvi-ie-document_0")
    topic_names.append("fdp-pcdp-input-ukvi-ie-manage_0")
    topic_names.append("fdp-pcdp-input-ukvi-ie-ris_0")
    topic_names.append("fdp-pcdp-input-ukvi-ie-repeated-attribute-event_0")
    topic_names.append("fdp-pcdp-input-ukvi-ie-v4_0")
    topic_names.append("fdp-pcdp-input-ukvi-ie-v5_0")
    topic_names.append("fdp-pcdp-input-ukvi-ima-leave_0")
    topic_names.append("fdp-pcdp-input-ukvi-international-sportsperson_0")
    topic_names.append("fdp-pcdp-input-ukvi-loss-of-status_0")
    topic_names.append("fdp-pcdp-input-ukvi-nationality_0")
    topic_names.append("fdp-pcdp-input-ukvi-no-time-limit_0")
    topic_names.append("fdp-pcdp-input-ukvi-payment_0")
    topic_names.append("fdp-pcdp-input-ukvi-resettlement_0")
    topic_names.append("fdp-pcdp-input-ukvi-restricted-leave_0")
    topic_names.append("fdp-pcdp-input-ukvi-scale-up_0")
    topic_names.append("fdp-pcdp-input-ukvi-settlement_0")
    topic_names.append("fdp-pcdp-input-ukvi-stateless-leave_0")
    topic_names.append("fdp-pcdp-input-ukvi-study_0")
    topic_names.append("fdp-pcdp-input-ukvi-temporary-worker_0")
    topic_names.append("fdp-pcdp-input-ukvi-third-country-unit-in_0")
    topic_names.append("fdp-pcdp-input-ukvi-third-country-unit-out_0")
    topic_names.append("fdp-pcdp-input-ukvi-transfer-of-refugee-status_0")
    topic_names.append("fdp-pcdp-input-ukvi-ukraine-scheme_0")
    topic_names.append("fdp-pcdp-input-ukvi-windrush_0")
    topic_names.append("fdp-pcdp-input-ukvi-work-non-sponsored_0")
    topic_names.append("fdp-pcdp-input-ukvi-work_0")
    topic_names.append("input-pcdpr36.pmi_r36.address")
    topic_names.append("input-pcdpr36.pmi_r36.all_event_attribute")
    topic_names.append("input-pcdpr36.pmi_r36.all_event_metadata")
    topic_names.append("input-pcdpr36.pmi_r36.artefact")
    topic_names.append("input-pcdpr36.pmi_r36.association")
    topic_names.append("input-pcdpr36.pmi_r36.biographic_set")
    topic_names.append("input-pcdpr36.pmi_r36.biometric")
    topic_names.append("input-pcdpr36.pmi_r36.cid_crs_all_event_metadata")
    topic_names.append("input-pcdpr36.pmi_r36.cid_crs_all_event_attribute")
    topic_names.append("input-pcdpr36.pmi_r36.condition")
    topic_names.append("input-pcdpr36.pmi_r36.error")
    topic_names.append("input-pcdpr36.pmi_r36.identity")
    topic_names.append("input-pcdpr36.pmi_r36.identity_consolidated_person")
    topic_names.append("input-pcdpr36.pmi_r36.ie_bail_event")
    topic_names.append("input-pcdpr36.pmi_r36.ie_barrier_action_event")
    topic_names.append("input-pcdpr36.pmi_r36.ie_border_casework_event")
    topic_names.append("input-pcdpr36.pmi_r36.ie_charter_flights_event")
    topic_names.append("input-pcdpr36.pmi_r36.ie_chief_caseworking_unit_event")
    topic_names.append("input-pcdpr36.pmi_r36.ie_close_event")
    topic_names.append("input-pcdpr36.pmi_r36.ie_core_event")
    topic_names.append("input-pcdpr36.pmi_r36.ie_decision_event")
    topic_names.append("input-pcdpr36.pmi_r36.ie_detention_event")
    topic_names.append("input-pcdpr36.pmi_r36.ie_electronic_monitoring_event")
    topic_names.append("input-pcdpr36.pmi_r36.ie_enforce_activity_event")
    topic_names.append("input-pcdpr36.pmi_r36.ie_marriage_referral_event")
    topic_names.append("input-pcdpr36.pmi_r36.ie_movement_event")
    topic_names.append("input-pcdpr36.pmi_r36.ie_offence_event")
    topic_names.append("input-pcdpr36.pmi_r36.ie_reporting_event")
    topic_names.append("input-pcdpr36.pmi_r36.ie_returns_removal_notices_event")
    topic_names.append("input-pcdpr36.pmi_r36.ie_travel_document_event")
    topic_names.append("input-pcdpr36.pmi_r36.ie_travel_event")
    topic_names.append("input-pcdpr36.pmi_r36.ie_voluntary_return_event")
    topic_names.append("input-pcdpr36.pmi_r36.ie_voluntary_return_expense_event")
    topic_names.append("input-pcdpr36.pmi_r36.individual")
    topic_names.append("input-pcdpr36.pmi_r36.involvement")
    topic_names.append("input-pcdpr36.pmi_r36.involvement_address")
    topic_names.append("input-pcdpr36.pmi_r36.involvement_electronic_address")
    topic_names.append("input-pcdpr36.pmi_r36.monitor")
    topic_names.append("input-pcdpr36.pmi_r36.organisation")
    topic_names.append("input-pcdpr36.pmi_r36.person")
    topic_names.append("input-pcdpr36.pmi_r36.reference")
    topic_names.append("input-pcdpr36.pmi_r36.service_delivery")
    topic_names.append("input-pcdpr36.pmi_r36.ukvi_age_assessment_event")
    topic_names.append("input-pcdpr36.pmi_r36.ukvi_asylum_claim_event")
    topic_names.append("input-pcdpr36.pmi_r36.ukvi_asylum_support_event")
    topic_names.append("input-pcdpr36.pmi_r36.ukvi_british_national_overseas_event")
    topic_names.append("input-pcdpr36.pmi_r36.ukvi_card_event")
    topic_names.append("input-pcdpr36.pmi_r36.ukvi_core_event")
    topic_names.append("input-pcdpr36.pmi_r36.ukvi_destitute_domestic_violence_event")
    topic_names.append(
        "input-pcdpr36.pmi_r36.ukvi_electronic_travel_authorisation_event"
    )
    topic_names.append("input-pcdpr36.pmi_r36.ukvi_endorsement_event")
    topic_names.append("input-pcdpr36.pmi_r36.ukvi_eus_event")
    topic_names.append("input-pcdpr36.pmi_r36.ukvi_exclusion_order_event")
    topic_names.append("input-pcdpr36.pmi_r36.ukvi_exempt_diplomat_event")
    topic_names.append("input-pcdpr36.pmi_r36.ukvi_family_human_rights_event")
    topic_names.append("input-pcdpr36.pmi_r36.ukvi_family_reunion_event")
    topic_names.append("input-pcdpr36.pmi_r36.ukvi_fee_waiver_event")
    topic_names.append("input-pcdpr36.pmi_r36.ukvi_frontier_worker_event")
    topic_names.append("input-pcdpr36.pmi_r36.ukvi_further_leave_to_remain_event")
    topic_names.append("input-pcdpr36.pmi_r36.ukvi_further_submissions_event")
    topic_names.append("input-pcdpr36.pmi_r36.ukvi_graduate_event")
    topic_names.append("input-pcdpr36.pmi_r36.ukvi_high_potential_individual_event")
    topic_names.append("input-pcdpr36.pmi_r36.ukvi_home_office_travel_document_event")
    topic_names.append("input-pcdpr36.pmi_r36.ukvi_ie_challenge_event")
    topic_names.append("input-pcdpr36.pmi_r36.ukvi_ie_cid_ingest_address_event")
    topic_names.append(
        "input-pcdpr36.pmi_r36.ukvi_ie_cid_ingest_appeals_judicial_review_event"
    )
    topic_names.append("input-pcdpr36.pmi_r36.ukvi_ie_cid_ingest_arrivals_event")
    topic_names.append("input-pcdpr36.pmi_r36.ukvi_ie_cid_ingest_barriers_event")
    topic_names.append("input-pcdpr36.pmi_r36.ukvi_ie_cid_ingest_cases_event")
    topic_names.append("input-pcdpr36.pmi_r36.ukvi_ie_cid_ingest_documents_event")
    topic_names.append("input-pcdpr36.pmi_r36.ukvi_ie_cid_ingest_event")
    topic_names.append("input-pcdpr36.pmi_r36.ukvi_ie_cid_ingest_notes_event")
    topic_names.append("input-pcdpr36.pmi_r36.ukvi_ie_cid_ingest_person_event")
    topic_names.append("input-pcdpr36.pmi_r36.ukvi_ie_cid_ingest_removal_event")
    topic_names.append("input-pcdpr36.pmi_r36.ukvi_ie_cid_ingest_restriction_event")
    topic_names.append(
        "input-pcdpr36.pmi_r36.ukvi_ie_cid_ingest_special_conditions_event"
    )
    topic_names.append("input-pcdpr36.pmi_r36.ukvi_ie_cross_domain_event")
    topic_names.append("input-pcdpr36.pmi_r36.ukvi_ie_crs_ingest_event")
    topic_names.append("input-pcdpr36.pmi_r36.ukvi_ie_denormalised_event")
    topic_names.append("input-pcdpr36.pmi_r36.ukvi_ie_document_event")
    topic_names.append("input-pcdpr36.pmi_r36.ukvi_ie_manage_event")
    topic_names.append("input-pcdpr36.pmi_r36.ukvi_ie_repeated_event_attribute")
    topic_names.append("input-pcdpr36.pmi_r36.ukvi_ie_repeated_attribute_event")
    topic_names.append("input-pcdpr36.pmi_r36.ukvi_ie_ris_event")
    topic_names.append("input-pcdpr36.pmi_r36.ukvi_ie_v4_event")
    topic_names.append("input-pcdpr36.pmi_r36.ukvi_ie_v5_event")
    topic_names.append("input-pcdpr36.pmi_r36.ukvi_ima_leave_event")
    topic_names.append("input-pcdpr36.pmi_r36.ukvi_international_sportsperson_event")
    topic_names.append("input-pcdpr36.pmi_r36.ukvi_loss_of_status_event")
    topic_names.append("input-pcdpr36.pmi_r36.ukvi_nationality_event")
    topic_names.append("input-pcdpr36.pmi_r36.ukvi_no_time_limit_event")
    topic_names.append("input-pcdpr36.pmi_r36.ukvi_payment_event")
    topic_names.append("input-pcdpr36.pmi_r36.ukvi_resettlement_event")
    topic_names.append("input-pcdpr36.pmi_r36.ukvi_restricted_leave_event")
    topic_names.append("input-pcdpr36.pmi_r36.ukvi_scale_up_event")
    topic_names.append("input-pcdpr36.pmi_r36.ukvi_settlement_event")
    topic_names.append("input-pcdpr36.pmi_r36.ukvi_stateless_leave_event")
    topic_names.append("input-pcdpr36.pmi_r36.ukvi_study_event")
    topic_names.append("input-pcdpr36.pmi_r36.ukvi_temporary_worker_event")
    topic_names.append("input-pcdpr36.pmi_r36.ukvi_third_country_unit_in_event")
    topic_names.append("input-pcdpr36.pmi_r36.ukvi_third_country_unit_out_event")
    topic_names.append("input-pcdpr36.pmi_r36.ukvi_transfer_of_refugee_status_event")
    topic_names.append("input-pcdpr36.pmi_r36.ukvi_ukraine_scheme_event")
    topic_names.append("input-pcdpr36.pmi_r36.ukvi_windrush_event")
    topic_names.append("input-pcdpr36.pmi_r36.ukvi_work_event")
    topic_names.append("input-pcdpr36.pmi_r36.ukvi_work_non_sponsored_event")
elif ADAPTOR_NAME == "placi":
    topic_names.append("fdp-plci-input-rwandair_0")
    topic_names.append("fdp-plci-input-saudia_0")
elif ADAPTOR_NAME == "pnr":
    topic_names.append("fdp-pnr-input_0")
    topic_names.append("landing-221-pnr")
elif ADAPTOR_NAME == "pronto":
    topic_names.append(f"fdp-{ADAPTOR_NAME}-input-ddform_entry_0")
    topic_names.append(f"fdp-{ADAPTOR_NAME}-input-ddform_form_basevisit_0")
    topic_names.append(f"fdp-{ADAPTOR_NAME}-input-ddform_form_encounter_0")
    topic_names.append(f"fdp-{ADAPTOR_NAME}-input-ddform_form_fingerprint_0")
    topic_names.append(f"fdp-{ADAPTOR_NAME}-input-ddform_searchstamp_personcheck_0")
    topic_names.append(f"fdp-{ADAPTOR_NAME}-input-ddform_sr_additionaladdress_0")
    topic_names.append(f"fdp-{ADAPTOR_NAME}-input-ddform_sr_arrest_0")
    topic_names.append(f"fdp-{ADAPTOR_NAME}-input-ddform_sr_cashseizure_0")
    topic_names.append(f"fdp-{ADAPTOR_NAME}-input-ddform_sr_compliant_0")
    topic_names.append(f"fdp-{ADAPTOR_NAME}-input-ddform_sr_contactdetails_0")
    topic_names.append(f"fdp-{ADAPTOR_NAME}-input-ddform_sr_entrypremises_0")
    topic_names.append(f"fdp-{ADAPTOR_NAME}-input-ddform_sr_extendedperson_0")
    topic_names.append(f"fdp-{ADAPTOR_NAME}-input-ddform_sr_illegalworkemployee_0")
    topic_names.append(f"fdp-{ADAPTOR_NAME}-input-ddform_sr_illegalworkemployer_0")
    topic_names.append(f"fdp-{ADAPTOR_NAME}-input-ddform_sr_interview_0")
    topic_names.append(f"fdp-{ADAPTOR_NAME}-input-ddform_sr_methodentry_0")
    topic_names.append(f"fdp-{ADAPTOR_NAME}-input-ddform_sr_mitigatingcircumstanc_0")
    topic_names.append(f"fdp-{ADAPTOR_NAME}-input-ddform_sr_operation_0")
    topic_names.append(f"fdp-{ADAPTOR_NAME}-input-ddform_sr_propertysearch_0")
    topic_names.append(f"fdp-{ADAPTOR_NAME}-input-ddform_sr_rentlandlord_0")
    topic_names.append(f"fdp-{ADAPTOR_NAME}-input-ddform_sr_renttenant_0")
    topic_names.append(f"fdp-{ADAPTOR_NAME}-input-ddform_sr_searchsubject_0")
    topic_names.append(f"fdp-{ADAPTOR_NAME}-input-ddform_sr_served_0")
    topic_names.append(f"fdp-{ADAPTOR_NAME}-input-ddform_sr_useofforce_0")
    topic_names.append(f"fdp-{ADAPTOR_NAME}-input-ddform_sr_voldep_0")
    topic_names.append(f"fdp-{ADAPTOR_NAME}-input-ddform_form_ukvibf_0")
elif ADAPTOR_NAME == "iptfees":
    topic_names.append(f"fdp-{ADAPTOR_NAME}-input_0")
elif ADAPTOR_NAME == "sds":
    topic_names.append("fdp_listener_suspense_0")
    topic_names.append("fdp-sds-input-address_0")
    topic_names.append("fdp-sds-input-contact_0")
    topic_names.append("fdp-sds-input-detail_0")
    topic_names.append("fdp-sds-input-notes_0")
    topic_names.append("fdp-sds-input-event_0")
    topic_names.append("fdp-sds-input-org_0")
    topic_names.append("fdp-sds-input-person_0")
    topic_names.append("fdp-sds-input-relation_0")
    topic_names.append("fdp-sds-input-virtual_0")
elif ADAPTOR_NAME == "sns":
    # SNS-specific topics are loaded from the shared topic template.
    pass
else:
    topic_names.append(f"fdp-{ADAPTOR_NAME}-input_0")


for i in range(1, 1100):
    topic_names.append(f"landing-{i}")

WAIT_CHECK = get_wait_check()
logger.info(f"Startup stage: {WAIT_CHECK}")

if WAIT_CHECK == "redis_kafka":
    rs = redis.Redis("redis")
    redis_connected = False

    while not redis_connected:
        try:
            rs.ping()
            logger.info("Successfully connected to Redis.")
            redis_connected = True
        except ConnectionError:
            logger.error("Unable to connect to redis.")
            time.sleep(1)

    wait_for_http(SCHEMA_REGISTRY_TEST_URL, "Schema Registry")
    wait_for_http(KAFDROP_TEST_URL, "Kafdrop")
    topic_names.sort()
    create_kafka_topics("kafka:29092", topic_names)
elif WAIT_CHECK == "command_adaptor":
    wait_for_http("http://command-adaptor:7112/actuator/health", "Command Adaptor")
elif WAIT_CHECK == "aggregators":
    FDP_APP_KAFKA_TOPIC_SUFFIX = ""
    if "FDP_APP_KAFKA_TOPIC_SUFFIX" in os.environ:
        FDP_APP_KAFKA_TOPIC_SUFFIX = os.environ["FDP_APP_KAFKA_TOPIC_SUFFIX"]
    wait_for_http(
        f"http://aggregate-event:7104/aggregate-event-{FDP_APP_KAFKA_TOPIC_SUFFIX}/health/readiness",
        "Event Aggregate",
    )
    wait_for_http(
        f"http://aggregate-location:7103/aggregate-location-{FDP_APP_KAFKA_TOPIC_SUFFIX}/health/readiness",
        "Location Aggregate",
    )
    wait_for_http(
        f"http://aggregate-object:7102/aggregate-object-{FDP_APP_KAFKA_TOPIC_SUFFIX}/health/readiness",
        "Object Aggregate",
    )
    wait_for_http(
        f"http://aggregate-party:7101/aggregate-party-{FDP_APP_KAFKA_TOPIC_SUFFIX}/health/readiness",
        "Party Aggregate",
    )
    wait_for_http(
        f"http://aggregate-service:7105/aggregate-service-{FDP_APP_KAFKA_TOPIC_SUFFIX}/health/readiness",
        "Service Aggregate",
    )
else:
    logger.error(f"Unknown WAIT_CHECK {WAIT_CHECK}")
    sys.exit(1)

if "S3_ENDPOINT_URL" in os.environ:
    s3_setup(os.environ["S3_ENDPOINT_URL"])
else:
    logger.info("Skipping S3 setup.")

sys.exit(0)
