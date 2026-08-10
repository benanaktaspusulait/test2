#!/usr/bin/env bash

#############################################################################
# WARNING: This file is controlled via RepoSync, any changes made in the
# command adaptor repository will be overwritten by the RepoSync process.
# See https://gitlab.digital.homeoffice.gov.uk/dacc-de/dde-adaptor-reposync
#############################################################################

# Mandatory values to be set by caller.
export ADAPTOR_NAME=${ADAPTOR_NAME:?'[error] Please specify which cluster to deploy to.'}
export ADAPTOR_REPLICA_COUNT=${ADAPTOR_REPLICA_COUNT:?'[error] Please specify the number of adaptor replicas.'}
export CDLZ_TOPIC_NUMBER=${CDLZ_TOPIC_NUMBER:?'[error] Please specify the CDLZ Topic Number.'}
export DRONE_DEPLOY_TO=${DRONE_DEPLOY_TO:?'[error] Please specify which cluster to deploy to.'}
export FDP_APP_MATCHING_NAME=${FDP_APP_MATCHING_NAME:?'[error] Please specify matching topic.'}
export FDP_FEED_NAME=${FDP_FEED_NAME:?'[error] Please specify the feed name.'}

# default values
export ARTIFACTORY_SECRET_NAME='artifactory-credentials'
export AUTO_REMOVE_DEPLOYMENT=0
export E2E_TEST_IMAGE_URL="${IMAGE_URL}-e2e"
export FAILSAFE_REPORT_S3_BUCKET=dacc-dde-dev-avro-inference-output
export FDP_AGGREGATE_CPU_MAX=1
export FDP_AGGREGATE_CPU_MIN=500m
export FDP_AGGREGATE_JAVA_MEMORY_MAX=2G
export FDP_AGGREGATE_JAVA_MEMORY_MIN=2G
export FDP_AGGREGATE_MEMORY_MAX=2560Mi
export FDP_AGGREGATE_MEMORY_MIN=2560Mi
export FDP_AGGREGATE_REPLICAS=1

# defaults for Kafka Client configuration
export FDP_KAFKA_SESSION_TIMEOUT_MS=''
export FDP_KAFKA_POLL_INTERVAL_MS=''
export FDP_KAFKA_MAX_POLL_RECORDS=''
export FDP_KAFKA_REBALANCE_TIMEOUT_MS=''
export FDP_KAFKA_MAX_REQUEST_SIZE=''
export FDP_KAFKA_TASK_TIMEOUT_MS=''

export FDP_APP_CDL_KAFKA_BROKER_KEY_NAME='FDP_APP_CDL_KAFKA_BROKER'
export FDP_APP_CDL_KAFKA_SCHEMA_REGISTRY_URL_KEY_NAME='FDP_APP_CDL_KAFKA_SCHEMA_REGISTRY_URL'
export FDP_APP_CDL_MSK_KEYSTORE_PASS_KEY_NAME='FDP_APP_CDL_MSK_KEYSTORE_PASS'
export FDP_APP_CDL_MSK_KEYSTORE_PATH='/home/fdpuser/fdp-app-cdl-msk/fdp-app-cdl-msk.jks'
export FDP_APP_CDL_MSK_SECRET_NAME='fdp-app-cdl-msk-keystore'
export FDP_APP_CDL_MSK_SECRET_MOUNT_PATH='/home/fdpuser/fdp-app-cdl-msk/'

export FDP_APP_KAFKA_SESSION_TIMEOUT_MS=2073600000
export FDP_APP_REDIS_AUTH_TOKEN_KEY_NAME='FDP_APP_REDIS_AUTH_TOKEN'
export FDP_APP_REDIS_END_POINT_KEY_NAME='FDP_APP_REDIS_END_POINT'
export FDP_APP_REDIS_NODES_KEY_NAME='FDP_APP_REDIS_NODES'
export FDP_APP_REDIS_PORT_KEY_NAME='FDP_APP_REDIS_PORT'

# Default to blank so that all types are processed.
export FDP_APP_MATCHING_TYPES_TO_FILTER=''

export FDP_APP_WASH_ADDRESS_ENABLE_COMPARISON_DETAIL='false'
export FDP_APP_WASH_ADDRESS_ENTITY_TYPE='SVL_ADD'
export FDP_APP_WASH_ADDRESS_MAX_RESULTS=20
export FDP_APP_WASH_ADDRESS_OUTPUT_WITH_MATCHED_DATA='false'
export FDP_APP_WASH_ADDRESS_POLE_SOURCES=""
export FDP_APP_WASH_ADDRESS_SEARCH_TYPE='ASMEMBER'
export FDP_APP_WASH_ADDRESS_SOURCE_THRESHOLD=35
export FDP_APP_WASH_ADDRESS_WASH_CONFIG_ID=103

export FDP_APP_WASH_CONTACT_ENABLE_COMPARISON_DETAIL='false'
export FDP_APP_WASH_CONTACT_ENTITY_TYPE='SVL_CONT'
export FDP_APP_WASH_CONTACT_MAX_RESULTS=20
export FDP_APP_WASH_CONTACT_OUTPUT_WITH_MATCHED_DATA='false'
export FDP_APP_WASH_CONTACT_POLE_SOURCES=''
export FDP_APP_WASH_CONTACT_SEARCH_TYPE='ASMEMBER'
export FDP_APP_WASH_CONTACT_SOURCE_THRESHOLD=30
export FDP_APP_WASH_CONTACT_WASH_CONFIG_ID=104

export FDP_APP_WASH_OBJECT_ENABLE_COMPARISON_DETAIL='false'
export FDP_APP_WASH_OBJECT_ENTITY_TYPE='SVO_OBJ'
export FDP_APP_WASH_OBJECT_MAX_RESULTS=20
export FDP_APP_WASH_OBJECT_OUTPUT_WITH_MATCHED_DATA='false'
export FDP_APP_WASH_OBJECT_POLE_SOURCES=''
export FDP_APP_WASH_OBJECT_SEARCH_TYPE='ASMEMBER'
export FDP_APP_WASH_OBJECT_SOURCE_THRESHOLD=30
export FDP_APP_WASH_OBJECT_WASH_CONFIG_ID=106

export FDP_APP_WASH_ORGANISATION_ENABLE_COMPARISON_DETAIL='false'
export FDP_APP_WASH_ORGANISATION_ENTITY_TYPE='SVP_ORG'
export FDP_APP_WASH_ORGANISATION_MAX_RESULTS=20
export FDP_APP_WASH_ORGANISATION_OUTPUT_WITH_MATCHED_DATA='false'
export FDP_APP_WASH_ORGANISATION_POLE_SOURCES=''
export FDP_APP_WASH_ORGANISATION_SEARCH_TYPE='ASMEMBER'
export FDP_APP_WASH_ORGANISATION_SOURCE_THRESHOLD=50
export FDP_APP_WASH_ORGANISATION_WASH_CONFIG_ID=102

export FDP_APP_WASH_PERSON_ENABLE_COMPARISON_DETAIL='false'
export FDP_APP_WASH_PERSON_ENTITY_TYPE='SVP_PER'
export FDP_APP_WASH_PERSON_MAX_RESULTS=20
export FDP_APP_WASH_PERSON_OUTPUT_WITH_MATCHED_DATA='false'
export FDP_APP_WASH_PERSON_POLE_SOURCES=''
export FDP_APP_WASH_PERSON_SEARCH_TYPE='ASMEMBER'
export FDP_APP_WASH_PERSON_SOURCE_THRESHOLD=110
export FDP_APP_WASH_PERSON_WASH_CONFIG_ID=101

export FDP_APP_WASH_TRANSPORT_ENABLE_COMPARISON_DETAIL='false'
export FDP_APP_WASH_TRANSPORT_ENTITY_TYPE='SVO_OBJ'
export FDP_APP_WASH_TRANSPORT_MAX_RESULTS=20
export FDP_APP_WASH_TRANSPORT_OUTPUT_WITH_MATCHED_DATA='false'
export FDP_APP_WASH_TRANSPORT_POLE_SOURCES=''
export FDP_APP_WASH_TRANSPORT_SEARCH_TYPE='ASMEMBER'
export FDP_APP_WASH_TRANSPORT_SOURCE_THRESHOLD=35
export FDP_APP_WASH_TRANSPORT_WASH_CONFIG_ID=106

export FDP_APP_WASH_VIRTUAL_ENABLE_COMPARISON_DETAIL='false'
export FDP_APP_WASH_VIRTUAL_ENTITY_TYPE='SVL_VIRT'
export FDP_APP_WASH_VIRTUAL_MAX_RESULTS=20
export FDP_APP_WASH_VIRTUAL_OUTPUT_WITH_MATCHED_DATA='false'
export FDP_APP_WASH_VIRTUAL_POLE_SOURCES=''
export FDP_APP_WASH_VIRTUAL_SEARCH_TYPE='ASMEMBER'
export FDP_APP_WASH_VIRTUAL_SOURCE_THRESHOLD=30
export FDP_APP_WASH_VIRTUAL_WASH_CONFIG_ID=105

export FDP_CMD_ADAPTOR_REPLICAS=1
export FDP_CMD_ADAPTOR_CPU_MAX=1
export FDP_CMD_ADAPTOR_CPU_MIN=0.5
export FDP_CMD_ADAPTOR_MEMORY_MAX=2048Mi
export FDP_CMD_ADAPTOR_MEMORY_MIN=1024Mi
export FDP_CMD_ADAPTOR_INCOMING_TOPIC="landing-${CDLZ_TOPIC_NUMBER}"
export FDP_CMD_ADAPTOR_JAVA_MEMORY_MAX=2G
export FDP_CMD_ADAPTOR_JAVA_MEMORY_MIN=2G
export FDP_CMD_ADAPTOR_MATCHING_DELTA_REPLICAS=1
export FDP_APP_MATCHING_AGGREGATE_TARGET=BOTH
export FDP_PIPELINE_NAME=$( echo $FDP_FEED_NAME | tr 'a-z' 'A-Z' )
export FDP_JAEGER_MEMORY_MAX=128Mi
export FDP_JAEGER_MEMORY_MIN=32Mi
export FDP_JAEGER_CPU_MAX=100m
export FDP_JAEGER_CPU_MIN=50m
export FDP_KAFKA_BROKER_KEY_NAME='FDP_KAFKA_BROKER'
export FDP_KAFKA_CONNECT_CPU=1
export FDP_KAFKA_CONNECT_MEMORY="4G"
export FDP_KAFKA_STREAM_THREADS=2
export FDP_KC_ES_COUNT=0
export FDP_KC_S3_V1_COUNT=0
export FDP_KC_S3_V2_COUNT=0
export FDP_AGGREGATE_MATCHING_CPU_MAX=1
export FDP_AGGREGATE_MATCHING_CPU_MIN=500m
export FDP_AGGREGATE_MATCHING_JAVA_MEMORY_MAX=2G
export FDP_AGGREGATE_MATCHING_JAVA_MEMORY_MIN=2G
export FDP_AGGREGATE_MATCHING_MEMORY_MAX=2560Mi
export FDP_AGGREGATE_MATCHING_MEMORY_MIN=2560Mi
export FDP_AGGREGATE_MATCHING_REPLICAS=1
export FDP_SPANS_QUEUE_SIZE=10000
export FDP_STATE_VOLUME_SIZE=50Gi
export FDP_STATE_VOLUME_TYPE='gp2-encrypted'
export FDP_OUTPUT_ADAPTOR_REPLICAS=0
export FDP_OUTPUT_ADAPTOR_MEMORY_MAX=2560Mi
export FDP_OUTPUT_ADAPTOR_MEMORY_MIN=2560Mi
export FDP_OUTPUT_ADAPTOR_JAVA_MEMORY_MAX=2G
export FDP_OUTPUT_ADAPTOR_JAVA_MEMORY_MIN=2G
export FDP_OUTPUT_ADAPTOR_CPU_MAX=1
export FDP_OUTPUT_ADAPTOR_CPU_MIN=0.5
export FDP_POLEV1_CONNECT_TASKS=1
export FDP_POLEV2_CONNECT_TASKS=1
export RUN_E2E_TEST=0
export SPRING_PROFILES_ACTIVE='int'

export KUBE_NAMESPACE=$DRONE_DEPLOY_TO
export JAEGER_NAMESPACE=$KUBE_NAMESPACE

# Namespace specific settings.
case "${KUBE_NAMESPACE}" in
  dacc-dde-*)
    export AUTO_REMOVE_DEPLOYMENT=1
    export KUBE_CLUSTER='acp-notprod'
    export RUN_E2E_TEST=1
    ;;
  'dacc-fdp-dev')
    export AUTO_REMOVE_DEPLOYMENT=1
    export ARTIFACTORY_SECRET_NAME='artifactory-secret'
    export KUBE_CLUSTER='acp-notprod'
    export RUN_E2E_TEST=1
    ;;
  'dacc-fdp-sit')
    export KUBE_CLUSTER='acp-notprod'
    export ARTIFACTORY_SECRET_NAME='artifactory-secret'
    # As part of the SIT testing, the Matching adator and aggregate
    # are deployed with zero replicas for the initial testing.
    # Then the Aker testers scale them up for subsequent tests
    # manually.
    export FDP_AGGREGATE_MATCHING_REPLICAS=0
    export FDP_CMD_ADAPTOR_MATCHING_DELTA_REPLICAS=0
    export FDP_KC_ES_COUNT=1
    export FDP_KC_S3_V1_COUNT=0
    export FDP_KC_S3_V2_COUNT=1
    export SPRING_PROFILES_ACTIVE='ext'
    export FDP_AGGREGATE_MEMORY_MAX=3072Mi
    export FDP_AGGREGATE_MEMORY_MIN=3072Mi
    export FDP_CMD_ADAPTOR_MEMORY_MAX=3072Mi
    export FDP_CMD_ADAPTOR_MEMORY_MIN=3072Mi
    # Ensure that the timeout on FDP SIT MSK is set to 2m.
    export FDP_APP_KAFKA_SESSION_TIMEOUT_MS=120000
    export NAMESPACE_TYPE='sit'
    ;;
  dacc-fdp-mode*)
    export JAEGER_NAMESPACE='dacc-fdp-mode'
    export KUBE_CLUSTER='acp-prod'
    export NAMESPACE_TYPE='mode'
    ;;
  dacc-fdp-prod*)
    export JAEGER_NAMESPACE='dacc-fdp-prod'
    export KUBE_CLUSTER='acp-prod'
    export NAMESPACE_TYPE='prod'
    ;;
  *)
    echo "ERROR: Unknown namespace ${KUBE_NAMESPACE}"
    exit 2
    ;;
esac

if [ -z "$NAMESPACE_TYPE" ]; then
  case "${KUBE_NAMESPACE}" in
    *-dev) export NAMESPACE_TYPE='dev' ;;
    *-test) export NAMESPACE_TYPE='test' ;;
    *-mode) export NAMESPACE_TYPE='mode' ;;
    *-prod) export NAMESPACE_TYPE='prod' ;;
    *) export NAMESPACE_TYPE='N/A' ;;
  esac
fi

# K8s cluster specific settings.
case "${KUBE_CLUSTER}" in
  'acp-notprod')
    export FDP_APP_CDL_KAFKA_GROUP_ID="fdp-${NAMESPACE_TYPE}-cdlz-${FDP_FEED_NAME}"
    export KUBE_SERVER="https://kube-api-notprod.notprod.acp.homeoffice.gov.uk"
    export WORKING_HOURS='Mon-Fri 08:20-18:00 Europe/London'
    ;;
  'acp-prod')
    echo $KUBE_NAMESPACE | grep -q mode

    # This suffix was requested by the FDP Team, specifically for PLACI it was to
    # be fdp-prod-cdlz-placi, although on may have thought it more logical to
    # be fdp-prod-cdlz-plci (to be more in line with the topic suffix of plci).
    if [ $? -eq 0 ]; then
      case "${FDP_FEED_NAME}" in
        'roro-tsv')
          export FDP_APP_CDL_KAFKA_GROUP_ID="fdp-mode-cdlz-roro-tsv-rorotsvtest"
          ;;
        'roro-xml')
          export FDP_APP_CDL_KAFKA_GROUP_ID="fdp-mode-cdlz-roro-xml-roroxmltest"
          ;;
        *)
          export FDP_APP_CDL_KAFKA_GROUP_ID="fdp-mode-cdlz-${FDP_FEED_NAME}"
          ;;
      esac
    else
      export FDP_APP_CDL_KAFKA_GROUP_ID="fdp-prod-cdlz-${FDP_FEED_NAME}"
    fi

    export ARTIFACTORY_SECRET_NAME='artifactory-secret'
    export FDP_AGGREGATE_MEMORY_MAX=3072Mi
    export FDP_AGGREGATE_MEMORY_MIN=3072Mi
    export FDP_AGGREGATE_MATCHING_REPLICAS=0
    export FDP_AGGREGATE_REPLICAS=2
    export FDP_CMD_ADAPTOR_REPLICAS=0
    export FDP_CMD_ADAPTOR_MATCHING_DELTA_REPLICAS=0
    export FDP_CMD_ADAPTOR_MEMORY_MAX=3072Mi
    export FDP_CMD_ADAPTOR_MEMORY_MIN=3072Mi
    export FDP_KC_ES_COUNT=1
    export FDP_KC_S3_V1_COUNT=0
    export FDP_KC_S3_V2_COUNT=1
    export KUBE_SERVER="https://kube-api-prod.prod.acp.homeoffice.gov.uk"
    export SPRING_PROFILES_ACTIVE='ext'
    export WORKING_HOURS=''
    ;;
  *)
    echo "ERROR: Unknown K8s cluster ${KUBE_CLUSTER}"
    exit 2
    ;;
esac

export KUBE_CERTIFICATE_AUTHORITY=https://raw.githubusercontent.com/UKHomeOffice/acp-ca/master/${KUBE_CLUSTER}.crt

# We have experienced race conditions of the CORE_TAG.env file being extracted correctly
# but one of the deployment steps for the aggregator fails because the file isn't present.
# This logic waits for a period of time for it to become available.
wait_time=1

while [ ! -f CORE_TAG.env ]; do
  echo "Waiting ${wait_time} seconds for CORE_TAG.env."
  sleep $wait_time
  (( wait_time = wait_time * 2 ))

  if [ $wait_time -gt 16 ]; then
    exit 1
  fi
done

source CORE_TAG.env
export KC_ES_TAG=609
export KC_S3_TAG=414

# Allow the overriding locally for each command adaptor.  No setting of any
# environment variables should take place in this script after these
# environment files have been sourced.
K8S_FEED_ENV_FILE="kube/env/feed/${FDP_FEED_NAME}.sh"
K8S_CLUSTER_ENV_FILE="kube/env/cluster/${KUBE_CLUSTER}.sh"
K8S_NAMESPACE_ENV_FILE="kube/env/cluster/${KUBE_CLUSTER}/namespace/${KUBE_NAMESPACE}.sh"
K8S_NAMESPACE_TYPE_ENV_FILE="kube/env/namespace_type/${NAMESPACE_TYPE}.sh"

if [ -f $K8S_FEED_ENV_FILE ]; then
  echo "INFO: Sourcing ${K8S_FEED_ENV_FILE}."
  source $K8S_FEED_ENV_FILE
else
  echo "INFO: ${K8S_FEED_ENV_FILE} not found."
fi

if [ -f $K8S_CLUSTER_ENV_FILE ]; then
  echo "INFO: Sourcing ${K8S_CLUSTER_ENV_FILE}."
  source $K8S_CLUSTER_ENV_FILE
else
  echo "INFO: ${K8S_CLUSTER_ENV_FILE} not found."
fi

if [ -f $K8S_NAMESPACE_TYPE_ENV_FILE ]; then
  echo "INFO: Sourcing ${K8S_NAMESPACE_TYPE_ENV_FILE}"
  source $K8S_NAMESPACE_TYPE_ENV_FILE
else
  echo "INFO: ${K8S_NAMESPACE_TYPE_ENV_FILE} no found."
fi

if [ -f $K8S_NAMESPACE_ENV_FILE ]; then
  echo "INFO: Sourcing ${K8S_NAMESPACE_ENV_FILE}."
  source $K8S_NAMESPACE_ENV_FILE
else
  echo "INFO: ${K8S_NAMESPACE_ENV_FILE} not found."
fi

echo "--- ADAPTOR_NAME: ${ADAPTOR_NAME}"
echo "--- FDP_FEED_NAME: ${FDP_FEED_NAME}"
echo "--- FDP_APP_KAFKA_TOPIC_SUFFIX: ${FDP_APP_KAFKA_TOPIC_SUFFIX}"
echo "--- kube api url: ${KUBE_SERVER}"
echo "--- namespace: ${KUBE_NAMESPACE}"
echo "--- namespace type: ${NAMESPACE_TYPE}"
echo "--- adaptor image name: ${IMAGE_URL}"
echo "--- Aggregator Core tag: ${CORE_TAG}"
echo "--- Kafka Connect (S3) Tag: ${KC_S3_TAG}"
echo "--- FDP App Matching Name: ${FDP_APP_MATCHING_NAME}"
echo "--- Kakfa matching group: ${FDP_APP_CDL_KAFKA_GROUP_ID}"

bash -c "kd $*"
