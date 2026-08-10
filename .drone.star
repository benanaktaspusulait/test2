"""

DO NOT EDIT LOCALLY!!!!!!!
WARNING: This file is controlled centrally, any changes made in the command
adaptor repository will be overwritten by the RepoSync process
DO NOT EDIT LOCALLY!!!!!!!

Drone CI (Starlark) Pipelines.

This script is deployed from https://gitlab.digital.homeoffice.gov.uk/dacc-de/dde-adaptor-reposync

This is a Starlark script.  Starlark is a cut down dialect of Python
and is supported by Drone CI.  As this pipeline is going to be more
complex than our other pipelines, it makes sense to be able to add
logic via this script rather than page after page of repetitive
YAML. Fix whitespace issue.

More about Starlark can be found at:

  - https://docs.drone.io/pipeline/scripting/starlark/
  - https://docs.bazel.build/versions/master/skylark/language.html
"""


ADAPTORS_METADATA = {
    'SNS': {
        'cdlz_topic_number': 'ens-hmrc',
        'replicas': 1,
        'feed_name': 'sns'
    }
}
COMMAND_ADAPTOR_NAME = 'sns'
ARTIFACTORY_REPOSITORY = 'dacc-aws/fdp-cmd-adaptor-sns'
KAFKA_TOPIC_SUFFIX = 'sns'
FDP_APP_MATCHING_NAME = 'SNS'
USE_FDP_DEPLOY = 'false'
LOCALSTACK_SERVICES = 'iam'
DEPLOYMENT_MECHANISM = 'KD'
ECR_REGISTRY = '340268328991.dkr.ecr.eu-west-2.amazonaws.com'
ARTIFACTORY_REGISTRY = 'docker.digital.homeoffice.gov.uk'
KD_IMAGE = 'quay.io/ukhomeofficedigital/kd:v1.20.15'
FDP_DEPLOY_IMAGE = 'docker.digital.homeoffice.gov.uk/dacc-aws/fdp-deploy:latest'
MAVEN_JAVA17_IMAGE = 'quay.io/ukhomeofficedigital/ileap-java17-mvn:1.3'
DIND_IMAGE = '340268328991.dkr.ecr.eu-west-2.amazonaws.com/acp/dind'
TRIVY_IMAGE = '340268328991.dkr.ecr.eu-west-2.amazonaws.com/acp/trivy/client:latest'


def add_pipeline_service(pipeline, service):
    """
    Append a step to a pipeline.

    Parameters
    ----------
    pipeline : dict
        The pipeline that the step is to be added to.
    service : dict
        The service to be added.

    Returns
    -------
    dict
        A new instance of the pipeline with the service appended.
    """
    services = pipeline['services']
    services.append(service)
    pipeline['services'] = services
    return pipeline


def add_pipeline_step(pipeline, step, pull='if-not-exists'):
    """
    Append a step to a pipeline.

    Parameters
    ----------
    pipeline : dict
        The pipeline that the step is to be added to.
    step : dict
        The step to be added.
    pull : str, optional
        The pull directive for the step image (default 'if-not-exists').
    Returns
    -------
    dict
        A new instance of the pipeline with the step appended.
    """
    steps = pipeline['steps']
    step['pull'] = pull
    steps.append(step)
    pipeline['steps'] = steps
    return pipeline


def blank_pipeline(name, depends_on=None):
    """
    Create a boilerplate pipeline.

    Parameters
    ----------
    name : str
        The name of the pipeline.
    depends_on: list of str, optional
        The names of a pipeline that must pass for this pipeline to execute.

    Returns
    -------
    dict
        A very basic pipeline.
    """
    response = {
        'kind': 'pipeline',
        'name': name,
        'type': 'kubernetes',
        'platform': {
            'os': 'linux',
            'arch': 'amd64'
        },
        'services': [],
        'steps': []
    }

    response = add_pipeline_step(
        response,
        {
            'name': 'RepoSync Version',
            'image': 'alpine:latest',
            'commands': [
                'echo "RepoSync Version: 7.2.2"'
            ]
        }
    )

    if depends_on:
        response['depends_on'] = depends_on

    return response


def ci_pipeline(ctx):
    """
    Create a Continuous Integration (CI) Pipeline.

    Parameters
    ----------
    ctx : A Drone CI context.
        The context passed by Drone CI.

    Returns
    -------
    dict
        A CI pipeline.
    """
    response = blank_pipeline('CI')
    response = add_pipeline_service(
        response,
        {
            'name': 'docker',
            'image': DIND_IMAGE
        }
    )

    response = add_pipeline_step(
        response,
        retrieve_vault_dev_secrets_step(name='Retrieve Artifactory Secrets', drone_deploy_to=ctx.build.target)
    )

    response = add_pipeline_step(
        response,
        {
            'name': 'Wait for Docker',
            'image': DIND_IMAGE,
            'commands': [
                '/usr/local/bin/wait',
            ],
            'depends_on': [
                'Retrieve Artifactory Secrets'
            ]
        }
    )

    response = add_pipeline_step(
        response,
        {
            'name': 'Extract Adaptor Information',
            'image': MAVEN_JAVA17_IMAGE,
            'commands': [
                '. ./set_drone_secrets.sh',
                './bin/adaptor-info.sh'
            ],
            'depends_on': [
                'Wait for Docker'
            ]
        }
    )

    response = add_pipeline_step(
        response,
        {
            'name': 'Build and Test with Testcontainers',
            'image': MAVEN_JAVA17_IMAGE,
            'commands': [
                '. ./set_drone_secrets.sh',
                'export DOCKER_API_VERSION=1.41',
                'export DOCKER_CONFIG=/tmp/testcontainers-docker-config',
                'mkdir -p "$${DOCKER_CONFIG}"',
                'AUTH_VALUE=$(printf "%s:%s" "$${ARTIFACTORY_USERNAME}" "$${ARTIFACTORY_PASSWORD}" | base64 | tr -d "\\n")',
                "printf '{\"auths\":{\"%s\":{\"auth\":\"%%s\"}}}\\n' \"$${AUTH_VALUE}\" > \"$${DOCKER_CONFIG}/config.json\"" % ARTIFACTORY_REGISTRY,
                'TEST_START=$(date +%s)',
                'mvn clean verify -Pci-testcontainers-snapshot',
                'TEST_DURATION=$(($(date +%s)-TEST_START))',
                'echo "CI_TIMING name=testcontainers_verify duration_seconds=$${TEST_DURATION}"',
                'if [ "$${TEST_DURATION}" -gt "$${TESTCONTAINERS_MAX_SECONDS}" ]; then echo "Testcontainers verify exceeded $${TESTCONTAINERS_MAX_SECONDS}s"; exit 1; fi'
            ],
            'environment': {
                'DOCKER_HOST': 'tcp://docker:2375',
                'DOCKER_API_VERSION': '1.41',
                'TESTCONTAINERS_HOST_OVERRIDE': 'docker',
                'TESTCONTAINERS_HUB_IMAGE_NAME_PREFIX': 'docker.digital.homeoffice.gov.uk/',
                'TESTCONTAINERS_RYUK_DISABLED': 'true',
                'TESTCONTAINERS_MAX_SECONDS': '720'
            },
            'depends_on': [
                'Extract Adaptor Information'
            ]
        }
    )

    response = add_pipeline_step(
        response,
        {
            'name': 'Build Command Adaptor Image',
            'image': DIND_IMAGE,
            'commands': [
                '. ./set_drone_secrets.sh',
                'echo "$${ARTIFACTORY_PASSWORD}" | docker login -u "$${ARTIFACTORY_USERNAME}" --password-stdin %s' % ARTIFACTORY_REGISTRY,
                'COMMAND_ADAPTOR_IMAGE="docker-compose-command-adaptor:latest"',
                'CACHE_IMAGE_REPO="%s/%s"' % (ARTIFACTORY_REGISTRY, ARTIFACTORY_REPOSITORY),
                'CACHE_BRANCH_TAG=$(echo "$${DRONE_BRANCH:-detached}" | tr "/" "-" | tr -cd "[:alnum:]-")',
                'CACHE_REF_DEFAULT="$${CACHE_IMAGE_REPO}:cmd-adaptor-cache-develop"',
                'CACHE_REF_BRANCH="$${CACHE_IMAGE_REPO}:cmd-adaptor-cache-$${CACHE_BRANCH_TAG}"',
                'if docker buildx version >/dev/null 2>&1; then if [ "$${DRONE_BRANCH:-}" = "develop" ]; then docker buildx build --builder default --load --file cmd-adaptor-%s/Dockerfile --tag "$${COMMAND_ADAPTOR_IMAGE}" --cache-from=type=registry,ref="$${CACHE_REF_DEFAULT}" --cache-to=type=registry,ref="$${CACHE_REF_DEFAULT}",mode=max cmd-adaptor-%s; else docker buildx build --builder default --load --file cmd-adaptor-%s/Dockerfile --tag "$${COMMAND_ADAPTOR_IMAGE}" --cache-from=type=registry,ref="$${CACHE_REF_DEFAULT}" --cache-from=type=registry,ref="$${CACHE_REF_BRANCH}" --cache-to=type=registry,ref="$${CACHE_REF_BRANCH}",mode=max cmd-adaptor-%s; fi; else echo "buildx not available - using inline cache fallback"; if [ "$${DRONE_BRANCH:-}" = "develop" ]; then docker pull "$${CACHE_REF_DEFAULT}" || true; DOCKER_BUILDKIT=1 docker build --build-arg BUILDKIT_INLINE_CACHE=1 --cache-from "$${CACHE_REF_DEFAULT}" -t "$${COMMAND_ADAPTOR_IMAGE}" -f cmd-adaptor-%s/Dockerfile cmd-adaptor-%s; docker tag "$${COMMAND_ADAPTOR_IMAGE}" "$${CACHE_REF_DEFAULT}"; docker push "$${CACHE_REF_DEFAULT}"; else docker pull "$${CACHE_REF_BRANCH}" || true; docker pull "$${CACHE_REF_DEFAULT}" || true; DOCKER_BUILDKIT=1 docker build --build-arg BUILDKIT_INLINE_CACHE=1 --cache-from "$${CACHE_REF_BRANCH}" --cache-from "$${CACHE_REF_DEFAULT}" -t "$${COMMAND_ADAPTOR_IMAGE}" -f cmd-adaptor-%s/Dockerfile cmd-adaptor-%s; docker tag "$${COMMAND_ADAPTOR_IMAGE}" "$${CACHE_REF_BRANCH}"; docker push "$${CACHE_REF_BRANCH}"; fi; fi' % (COMMAND_ADAPTOR_NAME, COMMAND_ADAPTOR_NAME, COMMAND_ADAPTOR_NAME, COMMAND_ADAPTOR_NAME, COMMAND_ADAPTOR_NAME, COMMAND_ADAPTOR_NAME, COMMAND_ADAPTOR_NAME, COMMAND_ADAPTOR_NAME),
                'docker image inspect "$${COMMAND_ADAPTOR_IMAGE}" >/dev/null'
            ],
            'environment': {
                'ADAPTOR_NAME': COMMAND_ADAPTOR_NAME,
                'DOCKER_HOST': 'tcp://docker:2375'
            },
            'depends_on': [
                'Build and Test with Testcontainers'
            ]
        }
    )

    response = add_pipeline_step(
        response,
        {
            'name': 'Validate Built Image Runtime',
            'image': MAVEN_JAVA17_IMAGE,
            'commands': [
                '. ./set_drone_secrets.sh',
                'export DOCKER_API_VERSION=1.41',
                'export DOCKER_CONFIG=/tmp/testcontainers-runtime-docker-config',
                'mkdir -p "$${DOCKER_CONFIG}"',
                'AUTH_VALUE=$(printf "%s:%s" "$${ARTIFACTORY_USERNAME}" "$${ARTIFACTORY_PASSWORD}" | base64 | tr -d "\\n")',
                "printf '{\"auths\":{\"%s\":{\"auth\":\"%%s\"}}}\\n' \"$${AUTH_VALUE}\" > \"$${DOCKER_CONFIG}/config.json\"" % ARTIFACTORY_REGISTRY,
                'RUNTIME_SMOKE_START=$(date +%s)',
                'mvn -pl cmd-adaptor-sns-integration-tests -am verify -Pci-built-image-runtime-smoke -Dsns.runtime.image=docker-compose-command-adaptor:latest',
                'RUNTIME_SMOKE_DURATION=$(($(date +%s)-RUNTIME_SMOKE_START))',
                'echo "CI_TIMING name=built_image_runtime_smoke duration_seconds=$${RUNTIME_SMOKE_DURATION}"'
            ],
            'environment': {
                'DOCKER_HOST': 'tcp://docker:2375',
                'DOCKER_API_VERSION': '1.41',
                'TESTCONTAINERS_HOST_OVERRIDE': 'docker',
                'TESTCONTAINERS_HUB_IMAGE_NAME_PREFIX': 'docker.digital.homeoffice.gov.uk/',
                'TESTCONTAINERS_RYUK_DISABLED': 'true'
            },
            'depends_on': [
                'Build Command Adaptor Image'
            ]
        }
    )

    # Sonar: HO setup only allows for a single branch to be ingested
    # as such only target the main developer branch develop (Gitflow) or master/main (Trunk)
    response = add_pipeline_step(
        response,
        {
            'name': 'Sonar Scan',
            'image': 'quay.io/ukhomeofficedigital/sonar-scanner:latest',
            'pull': 'if-not-exists',
            'when': {
                'event': ['push'],
                'branch': ['develop']
            },
            'depends_on': [
                'Build and Test with Testcontainers'
            ]
        }
    )

    response = add_pipeline_step(
        response,
        {
            'name': 'Scan with Trivy',
            'depends_on': [
                'Validate Built Image Runtime'
            ],
            'commands': [
                # PM-75944: updated application to use ecr trivy db
                'trivy image --exit-code 0 --no-progress docker-compose-command-adaptor:latest --severity CRITICAL,HIGH --ignore-unfixed --db-repository  acp-zot-helm.acp-zot.svc.cluster.local/ecr/aquasecurity/trivy-db --java-db-repository acp-zot-helm.acp-zot.svc.cluster.local/ecr/aquasecurity/trivy-java-db',
                'PIPELINE_DURATION=$(($(date +%s)-$${DRONE_BUILD_STARTED}))',
                'echo "CI_TIMING name=branch_pipeline duration_seconds=$${PIPELINE_DURATION}"',
                'if [ "$${PIPELINE_DURATION}" -gt 815 ]; then echo "Branch pipeline exceeded 815s"; exit 1; fi'
            ],
            'image': TRIVY_IMAGE,
            'environment': {
                'DOCKER_HOST': 'tcp://docker:2375'
            }
        }
    )

    response = add_pipeline_step(response, {
        'name': 'Send Slack Success Message (v1.1)',
        'image': 'curlimages/curl:latest',
        'pull': 'if-not-exists',
        'commands': [
            '. ./set_drone_secrets.sh',
            'source .drone/slack-functions.sh',
            'send_slack_success $SLACK_APP_TOKEN'
        ],
        'when': {
            'status': 'success',
            'event': ['push'],
            'branch': ['develop', 'main', 'master']
        },
        'depends_on': [
            'Scan with Trivy'
        ]
    })

    response = add_pipeline_step(response, {
        'name': 'Send Slack Failure Message (v1.1)',
        'image': 'curlimages/curl:latest',
        'pull': 'if-not-exists',
        'commands': [
            '. ./set_drone_secrets.sh',
            'source .drone/slack-functions.sh',
            'send_slack_failure $SLACK_APP_TOKEN'
        ],
        'when': {
            'status': 'failure',
            'event': ['push'],
            'branch': ['develop', 'main', 'master']
        },
        'depends_on': [
            'Scan with Trivy'
        ]
    })

    return response


def retrieve_vault_dev_secrets_step(*, name='Retrieve Artifactory Secrets', drone_deploy_to):
    """
    Create step to retrieve secrets from vault and store in set_drone_secrets.sh

    Parameters
    ----------
    name : step name

    Returns
    -------
    dict
        An ECR pipeline for Drone CI.
    """

    kube_token_name = ''
    if 'dacc-dde-dev' == drone_deploy_to:
        kube_token_name = 'dde-dev-kube-token'
    elif 'dacc-dde-test' == drone_deploy_to:
        kube_token_name = 'dde-test-kube-token'
    elif 'dacc-dde-sit' == drone_deploy_to:
        kube_token_name = 'dde-sit-kube-token'
    elif 'dacc-fdp-dev' == drone_deploy_to:
        kube_token_name = 'dev-kube-token'
    elif 'dacc-fdp-test' == drone_deploy_to:
        kube_token_name = 'test-kube-token'
    elif 'dacc-fdp-sit' == drone_deploy_to:
        kube_token_name = 'sit-kube-token'

    vault_kube_token_cmd = ''
    if kube_token_name:
        vault_kube_token_cmd = 'echo export KUBE_TOKEN=$(vault read -field=kube-token secret/dacc/fdp/admin/kube-tokens/%s) >> set_drone_secrets.sh' % kube_token_name

    return {
        'name': name,
        'image': 'quay.io/ukhomeofficedigital/hashicorp-vault:1.6.0',
        'commands': [
            # Get Artifactory secrets
            "echo export ARTIFACTORY_USERNAME=$(vault read -field=username secret/dacc/fdp/admin/artifactory/username) >> set_drone_secrets.sh",
            "echo export ARTIFACTORY_PASSWORD=$(vault read -field=password secret/dacc/fdp/admin/artifactory/password) >> set_drone_secrets.sh",
            # Get Slack secrets
            "echo export SLACK_APP_TOKEN=$(vault read -field=token secret/dacc/fdp/drone/slack-fdp-alert-token) >> set_drone_secrets.sh",
            # Get Kube token
            vault_kube_token_cmd,
            '. ./set_drone_secrets.sh',
            'if [ -z "$${ARTIFACTORY_USERNAME}" ]; then echo "ERROR - Failed to fetch ARTIFACTORY_USERNAME"; exit 1; fi;',
            'if [ -z "$${ARTIFACTORY_PASSWORD}" ]; then echo "ERROR - Failed to fetch ARTIFACTORY_PASSWORD"; exit 1; fi;'
        ],
        'environment': {
            'VAULT_ADDR': {
                'from_secret': 'VAULT_ADDR_DEV'
            },
            'VAULT_TOKEN': {
                'from_secret': 'VAULT_TOKEN_DEV'
            },
        }
    }


def deploy_pipeline(ctx, name='Deploy', depends_on=None, namespace=None, delete=False):
    """
    Create a Drone CI pipeline to deploy the command adaptor.

    Parameters
    ----------
    ctx : A Drone CI context.
        The context passed by Drone CI.
    name : str, optional
        The name of the Pipleline.
    depends_on : list of str, optional
        Any pipelines that must run beforehand.
    namespace : str, optional
        If not provided, the target will be taken from the ctx.
    delete : bool, optional
        Are the resources to be deleted (default False).
    Returns
    -------
    dict
        The pipeline.
    """
    response = blank_pipeline(name, depends_on)

    if namespace:
        drone_deploy_to = namespace
    else:
        drone_deploy_to = ctx.build.target

    kd_args = '--timeout 15m'

    if delete:
        kd_args += ' --delete'

    image_tag = get_deployment_tag(ctx)

    image_url = '%s/%s:%s' % (
        ARTIFACTORY_REGISTRY,
        ARTIFACTORY_REPOSITORY,
        image_tag
    )

    adaptor_name = COMMAND_ADAPTOR_NAME
    kafka_topic_suffix = KAFKA_TOPIC_SUFFIX
    CORE_TAG = None
    params = getattr(ctx.build, 'params', {})

    if ctx.build.event == 'promote' and ctx.build.commit != '':
        if 'CORE_TAG' in params:
            CORE_TAG = params['CORE_TAG']

        if 'ADAPTOR_NAME' in params:
            adaptor_name = params['ADAPTOR_NAME']

        if 'KAFKA_TOPIC_SUFFIX' in params:
            kafka_topic_suffix = params['KAFKA_TOPIC_SUFFIX']

    response = add_pipeline_step(
        response,
        retrieve_vault_dev_secrets_step(name='Retrieve Artifactory Secrets', drone_deploy_to=drone_deploy_to)
    )

    core_step_depends_on = 'Retrieve Artifactory Secrets'

    if 'true' == USE_FDP_DEPLOY:
        fdp_deploy_mode = 'create-topics'
        if delete:
            fdp_deploy_mode = 'delete-topics'

        fdp_deploy_step_name = 'FDP-Deploy %s' % fdp_deploy_mode
        core_step_depends_on = fdp_deploy_step_name

        response = add_pipeline_step(
            response,
            {
                'name': fdp_deploy_step_name,
                'commands': [
                    'source set_drone_secrets.sh',
                    'export FDP_DEPLOY_KUBE_TOKEN=$${KUBE_TOKEN}',
                    '/app/deploy.py --debug --run-as-job',
                    '/app/tail-job-logs.sh $(cat /tmp/latest_job_name)',
                ],
                'depends_on': [
                    'Retrieve Artifactory Secrets',
                ],
                'environment': {
                    'FDP_DEPLOY_MODE': fdp_deploy_mode,
                    'FDP_DEPLOY_CI': 'true',
                    'FDP_DEPLOY_FEED': COMMAND_ADAPTOR_NAME,
                    'FDP_DEPLOY_ENVIRONMENT': drone_deploy_to,
                    'FDP_DEPLOY_KUBE_CLUSTER_NAME': 'acp-notprod',
                    'FDP_DEPLOY_KUBE_SERVER': 'https://kube-api-notprod.notprod.acp.homeoffice.gov.uk',
                },
                'image': FDP_DEPLOY_IMAGE,
            }
        )

    if CORE_TAG:
        core_step = {
            'name': 'Core Tag %s' % CORE_TAG,
            'image': 'alpine:latest',
            'commands': [
                "echo 'export CORE_TAG=%s' > CORE_TAG.env" % CORE_TAG,
                'cat CORE_TAG.env',
            ],
            'depends_on': [
                core_step_depends_on
            ]
        }
    else:
        core_step = {
            'name': 'Extract Aggregator Core Tag',
            'image': MAVEN_JAVA17_IMAGE,
            'commands': [
                '. ./set_drone_secrets.sh',
                "echo -n 'export CORE_TAG=' > CORE_TAG.env",
                'mvn org.apache.maven.plugins:maven-help-plugin:3.2.0:evaluate -Dexpression=aggregator-core.version -q -DforceStdout >> CORE_TAG.env',
                'cat CORE_TAG.env',
                "[[ $( cat CORE_TAG.env| wc -w | sed 's/[ \t]//g' ) == 2 ]]"
            ],
            'depends_on': [
                core_step_depends_on
            ]
        }

    response = add_pipeline_step(response, core_step)

    if ctx.build.event == 'push' and not delete:
        response = add_pipeline_step(response, {
            'name': 'Slack: Notification Start',
            'image': 'curlimages/curl:latest',
            'pull': 'if-not-exists',
            'commands': [
                '. ./set_drone_secrets.sh',
                'source .drone/slack-functions.sh',
                "send_slack_text dacc-dde-dev 'Build `${DRONE_BUILD_NUMBER}` starting for *${DRONE_REPO_NAME}* to *%s*.' $SLACK_APP_TOKEN" % namespace
            ],
            'depends_on': [
                'clone'
            ]
        })

    aggregate_details = [
        ('Matching Aggregator', 'kube/fdp-aggregate-matching-deployment.yml')
    ]

    depends_on = []

    for aggregate_detail in aggregate_details:
        name, file = aggregate_detail
        depends_on.append(name)
        response = add_pipeline_step(
            response,
            {
                'name': name,
                'commands': [
                    '. ./set_drone_secrets.sh',
                    'apk upgrade --no-cache',
                    'apk add --no-cache ca-certificates curl',
                    'bin/kd-env-wrapper.sh %s --file %s' % (kd_args, file)
                ],
                'depends_on': [
                    core_step['name']
                ],
                'environment': {
                    'ADAPTOR_NAME': adaptor_name,
                    'ADAPTOR_REPLICA_COUNT': 'N/A',
                    'CDLZ_TOPIC_NUMBER': 'N/A',
                    'DRONE_DEPLOY_TO': drone_deploy_to,
                    'FDP_APP_KAFKA_TOPIC_SUFFIX': kafka_topic_suffix,
                    'FDP_APP_MATCHING_NAME': FDP_APP_MATCHING_NAME,
                    'FDP_FEED_NAME': adaptor_name,
                },
                'image': KD_IMAGE,
            }
        )

    aggregate_details = {
        'event': {
            'port': 7104
        },
        'location': {
            'port': 7103
        },
        'object': {
            'port': 7102
        },
        'party': {
            'port': 7101
        },
        'service': {
            'port': 7105
        },
        'v1id-v2id': {
            'port': 7108
        }
    }

    for aggregator_type in aggregate_details.keys():
        name = 'Aggregate %s' % aggregator_type
        port = aggregate_details[aggregator_type]['port']
        depends_on.append(name)
        namespace_type = drone_deploy_to.split('-')[-1]

        if namespace_type in ['dev', 'test']:
            response = add_pipeline_step(
                response,
                {
                    'name': "GRPC %s" % aggregator_type,
                    'commands': [
                        '. ./set_drone_secrets.sh',
                        'apk upgrade --no-cache',
                        'apk add --no-cache ca-certificates curl',
                        'bin/kd-env-wrapper.sh %s --file %s' % (kd_args, 'kube/grpc-service.yml'),
                    ],
                    'depends_on': [
                        core_step['name']
                    ],
                    'environment': {
                        'ADAPTOR_NAME': adaptor_name,
                        'ADAPTOR_REPLICA_COUNT': 'N/A',
                        'CDLZ_TOPIC_NUMBER': 'N/A',
                        'DRONE_DEPLOY_TO': drone_deploy_to,
                        'FDP_AGGREGATOR_PORT': port,
                        'FDP_AGGREGATOR_TYPE': aggregator_type,
                        'FDP_APP_KAFKA_TOPIC_SUFFIX': kafka_topic_suffix,
                        'FDP_APP_MATCHING_NAME': FDP_APP_MATCHING_NAME,
                        'FDP_FEED_NAME': adaptor_name,
                    },
                    'image': KD_IMAGE,
                }
            )

        response = add_pipeline_step(
            response,
            {
                'name': name,
                'commands': [
                    '. ./set_drone_secrets.sh',
                    'apk upgrade --no-cache',
                    'apk add --no-cache ca-certificates curl',
                    'bin/kd-env-wrapper.sh %s --file %s' % (kd_args, 'kube/fdp-aggregate-sts.yml')
                ],
                'depends_on': [
                    core_step['name']
                ],
                'environment': {
                    'ADAPTOR_NAME': adaptor_name,
                    'ADAPTOR_REPLICA_COUNT': 'N/A',
                    'CDLZ_TOPIC_NUMBER': 'N/A',
                    'DRONE_DEPLOY_TO': drone_deploy_to,
                    'FDP_AGGREGATOR_PORT': port,
                    'FDP_AGGREGATOR_TYPE': aggregator_type,
                    'FDP_APP_KAFKA_TOPIC_SUFFIX': kafka_topic_suffix,
                    'FDP_APP_MATCHING_NAME': FDP_APP_MATCHING_NAME,
                    'FDP_FEED_NAME': adaptor_name,
                },
                'image': KD_IMAGE,
            }
        )

    if COMMAND_ADAPTOR_NAME == 'pnr':
        # We don't deploy Kafka Connect with PNR.
        second_wave = [
            ('Matching Delta', 'kube/fdp-cmd-adaptor-matching-delta-deployment.yml'),
            ('Output Adaptor', 'kube/fdp-output-adaptor-polev1-deployment.yml')
        ]
    else:
        second_wave = [
            ('Matching Delta', 'kube/fdp-cmd-adaptor-matching-delta-deployment.yml'),
            ('Kafka Connect Error', 'kube/fdp-kces-error-deployment.yml'),
            ('Kafka Connect ES Event', 'kube/fdp-kces-event-deployment.yml'),
            ('Kafka Connect ES Location', 'kube/fdp-kces-location-deployment.yml'),
            ('Kafka Connect ES From Matching Delta', 'kube/fdp-kces-from-matching-delta-deployment.yml'),
            ('Kafka Connect ES From Matching Wash', 'kube/fdp-kces-from-matching-wash-deployment.yml'),
            ('Kafka Connect ES To Matching Delta', 'kube/fdp-kces-to-matching-delta-deployment.yml'),
            ('Kafka Connect ES To Matching Wash', 'kube/fdp-kces-to-matching-wash-deployment.yml'),
            ('Kafka Connect ES Object', 'kube/fdp-kces-object-deployment.yml'),
            ('Kafka Connect ES Party', 'kube/fdp-kces-party-deployment.yml'),
            ('Kafka Connect ES Service', 'kube/fdp-kces-service-deployment.yml'),
            ('Kafka Connect ES Suspense', 'kube/fdp-kces-suspense-deployment.yml'),
            ('Kafka Connect S3 Output V1', 'kube/fdp-kcs3-output-adaptor-polev1-deployment.yml'),
            ('Kafka Connect S3 Output V2', 'kube/fdp-kcs3-output-adaptor-polev2-deployment.yml'),
            ('Output Adaptor', 'kube/fdp-output-adaptor-polev1-deployment.yml')
        ]

    for pod in second_wave:
        name, file = pod
        response = add_pipeline_step(
            response,
            {
                'name': name,
                'commands': [
                    '. ./set_drone_secrets.sh',
                    'apk upgrade --no-cache',
                    'apk add --no-cache ca-certificates curl',
                    'bin/kd-env-wrapper.sh %s --file %s' % (kd_args, file)
                ],
                'depends_on': [
                    core_step['name']
                ],
                'environment': {
                    'ADAPTOR_NAME': adaptor_name,
                    'ADAPTOR_REPLICA_COUNT': 'N/A',
                    'CDLZ_TOPIC_NUMBER': 'N/A',
                    'DRONE_DEPLOY_TO': drone_deploy_to,
                    'FDP_APP_KAFKA_TOPIC_SUFFIX': kafka_topic_suffix,
                    'FDP_APP_MATCHING_NAME': FDP_APP_MATCHING_NAME,
                    'FDP_FEED_NAME': adaptor_name,
                },
                'image': KD_IMAGE
            }
        )

    e2e_depends_on = depends_on

    for name in ADAPTORS_METADATA.keys():
        replicas = ADAPTORS_METADATA[name]['replicas']
        cdlz_topic_number = ADAPTORS_METADATA[name]['cdlz_topic_number']
        feed_name = ADAPTORS_METADATA[name]['feed_name']
        e2e_depends_on.append(name)
        namespace_type = drone_deploy_to.split('-')[-1]
        adaptor_environment = {
            'ADAPTOR_NAME': adaptor_name,
            'ADAPTOR_REPLICA_COUNT': replicas,
            'CDLZ_TOPIC_NUMBER': cdlz_topic_number,
            'DRONE_DEPLOY_TO': drone_deploy_to,
            'FDP_FEED_NAME': feed_name,
            'IMAGE_URL': image_url,
            'FDP_APP_MATCHING_NAME': FDP_APP_MATCHING_NAME,
            'FDP_APP_KAFKA_TOPIC_SUFFIX': kafka_topic_suffix,
        }

        if 'extra_env_vars' in ADAPTORS_METADATA[name]:
            extra_env_vars = ADAPTORS_METADATA[name]['extra_env_vars']
            extra_env_var_keys = extra_env_vars.keys()

            for extra_env_var in extra_env_var_keys:
                adaptor_environment[extra_env_var] = extra_env_vars[extra_env_var]

            # Convert the key names so they can be displayed in the deploy step.
            extra_env_var_keys = ','.join(extra_env_var_keys)
        else:
            extra_env_var_keys = 'N/A'

        if namespace_type in ['dev', 'test']:
            response = add_pipeline_step(
                response,
                {
                    'name': "GRPC Netpol %s" % name,
                    'commands': [
                        '. ./set_drone_secrets.sh',
                        'apk upgrade --no-cache',
                        'apk add --no-cache ca-certificates curl',
                        'bin/kd-env-wrapper.sh %s --file %s' % (kd_args, 'kube/grpc-netpol.yml'),
                    ],
                    'depends_on': [
                        core_step['name']
                    ],
                    'environment': {
                        'ADAPTOR_NAME': adaptor_name,
                        'ADAPTOR_REPLICA_COUNT': 'N/A',
                        'CDLZ_TOPIC_NUMBER': 'N/A',
                        'DRONE_DEPLOY_TO': drone_deploy_to,
                        'FDP_AGGREGATOR_PORT': port,
                        'FDP_AGGREGATOR_TYPE': aggregator_type,
                        'FDP_APP_KAFKA_TOPIC_SUFFIX': kafka_topic_suffix,
                        'FDP_APP_MATCHING_NAME': FDP_APP_MATCHING_NAME,
                        'FDP_FEED_NAME': adaptor_name,
                    },
                    'image': KD_IMAGE,
                }
            )

        response = add_pipeline_step(
            response,
            {
                'name': name,
                'commands': [
                    '. ./set_drone_secrets.sh',
                    'echo "Adaptor name: %s"' % adaptor_name,
                    'echo "Extra environment variables: %s"' % extra_env_var_keys,
                    'apk upgrade --no-cache',
                    'apk add --no-cache ca-certificates curl',
                    'bin/kd-env-wrapper.sh %s --file kube/adaptor.yml' % kd_args
                ],
                'depends_on': [
                    core_step['name']
                ],
                'environment': adaptor_environment,
                'image': KD_IMAGE
            }
        )

    if delete:
        response = add_pipeline_step(
            response,
            {
                'name': 'Remove PVCs',
                'commands': [
                    '. ./set_drone_secrets.sh',
                    'bin/kd-env-wrapper.sh run delete pvc -l name=fdp-aggregate-event-%s' % adaptor_name,
                    'bin/kd-env-wrapper.sh run delete pvc -l name=fdp-aggregate-location-%s' % adaptor_name,
                    'bin/kd-env-wrapper.sh run delete pvc -l name=fdp-aggregate-matching-%s' % adaptor_name,
                    'bin/kd-env-wrapper.sh run delete pvc -l name=fdp-aggregate-object-%s' % adaptor_name,
                    'bin/kd-env-wrapper.sh run delete pvc -l name=fdp-aggregate-party-%s' % adaptor_name,
                    'bin/kd-env-wrapper.sh run delete pvc -l name=fdp-aggregate-service-%s' % adaptor_name,
                    'bin/kd-env-wrapper.sh run delete pvc -l name=fdp-aggregate-v1id-v2id-%s' % adaptor_name
                ],
                'environment': {
                    'ADAPTOR_NAME': adaptor_name,
                    'ADAPTOR_REPLICA_COUNT': 'N/A',
                    'CDLZ_TOPIC_NUMBER': 'N/A',
                    'DRONE_DEPLOY_TO': drone_deploy_to,
                    'FDP_APP_KAFKA_TOPIC_SUFFIX': adaptor_name,
                    'FDP_APP_MATCHING_NAME': FDP_APP_MATCHING_NAME,
                    'FDP_FEED_NAME': adaptor_name,
                },
                'depends_on': depends_on,
                'image': KD_IMAGE
            }
        )

    # In dev and test environments, we deploy the End-to-End test container.
    namespace_type = drone_deploy_to.split('-')[-1]

    if adaptor_name != COMMAND_ADAPTOR_NAME:
        run_e2e = False
    elif adaptor_name == 'sds':
        run_e2e = False
    elif namespace_type in ['dev', 'test']:
        run_e2e = True
    else:
        run_e2e = False

    if run_e2e:
        commands = [
            '. ./set_drone_secrets.sh',
            'bin/kd-env-wrapper.sh --delete --file kube/e2e-test.yml'
        ]

        if not delete:
            commands.append('bin/kd-env-wrapper.sh --file kube/e2e-test.yml --timeout=35m')
            response = add_pipeline_step(
                response,
                {
                    'name': 'E2E Logs',
                    'depends_on': e2e_depends_on,
                    'commands': [
                        'bin/tail-k8s-e2e-logs.sh'
                    ],
                    'environment': {
                        'ADAPTOR_NAME': COMMAND_ADAPTOR_NAME,
                        'KUBE_NAMESPACE': namespace,
                        'KUBE_SERVER': 'https://kube-api-notprod.notprod.acp.homeoffice.gov.uk',
                        'KUBE_CERTIFICATE_AUTHORITY': 'https://raw.githubusercontent.com/UKHomeOffice/acp-ca/master/acp-notprod.crt'
                    },
                    'image': KD_IMAGE,
                    'detach': True
                }
            )

        response = add_pipeline_step(
            response,
            {
                'name': 'E2E',
                'commands': commands,
                'depends_on': e2e_depends_on,
                'environment': {
                    'ADAPTOR_NAME': COMMAND_ADAPTOR_NAME,
                    'ADAPTOR_REPLICA_COUNT': 'N/A',
                    'CDLZ_TOPIC_NUMBER': 'N/A',
                    'DRONE_DEPLOY_TO': drone_deploy_to,
                    'FDP_APP_MATCHING_NAME': FDP_APP_MATCHING_NAME,
                    'FDP_FEED_NAME': feed_name,
                    'IMAGE_URL': image_url,
                },
                'image': KD_IMAGE
            }
        )

    if ctx.build.event == 'tag' and delete:
        release_name = COMMAND_ADAPTOR_NAME.upper()
        template_lines = [
            'Release Declared: <${DRONE_REPO_LINK}/-/tags|`%s-${DRONE_TAG}`> Build Number: <${DRONE_BUILD_LINK}|`${DRONE_BUILD_NUMBER}`>' % release_name
        ]

        if COMMAND_ADAPTOR_NAME == 'sds':
            depends_on = ['SDS']
        elif COMMAND_ADAPTOR_NAME == 'ctp':
            depends_on = ['CTP']
        else:
            depends_on = ['E2E']

        response = add_pipeline_step(response, {
            'name': 'Slack: Declare Release',
            'image': 'curlimages/curl:latest',
            'pull': 'if-not-exists',
            'commands': [
                '. ./set_drone_secrets.sh',
                'source .drone/slack-functions.sh',
                "send_slack_text fdp-developer-support '%s' $SLACK_APP_TOKEN" % '\n'.join(template_lines)
            ],
            'depends_on': [
                'Retrieve Artifactory Secrets'
            ]
        })

    if ctx.build.event == 'push' and delete:
        if COMMAND_ADAPTOR_NAME == 'sds':
            slack_depends_on = ['SDS']
        elif COMMAND_ADAPTOR_NAME == 'ctp':
            slack_depends_on = ['CTP']
        else:
            slack_depends_on = ['E2E']

        response = add_pipeline_step(response, {
            'name': 'Slack: End Result Success Message (v1.1)',
            'image': 'curlimages/curl:latest',
            'pull': 'if-not-exists',
            'commands': [
                '. ./set_drone_secrets.sh',
                'source .drone/slack-functions.sh',
                "send_slack_text dacc-dde-dev '%s' $SLACK_APP_TOKEN" % '\n'.join(['Build `${DRONE_BUILD_NUMBER}` has deployed successfully for *${DRONE_REPO_NAME}* to *%s*.' % namespace])
            ],
            'when': {
                'status': 'success',
                'event': ['push'],
            },
            'depends_on': slack_depends_on
        })

        response = add_pipeline_step(response, {
            'name': 'Slack: End Result Failed Message (v1.1)',
            'image': 'curlimages/curl:latest',
            'pull': 'if-not-exists',
            'commands': [
                '. ./set_drone_secrets.sh',
                'source .drone/slack-functions.sh',
                "send_slack_text dacc-dde-dev '%s' $SLACK_APP_TOKEN" % '\n'.join(['Build `${DRONE_BUILD_NUMBER}` has failed to deploy for *${DRONE_REPO_NAME}* to *%s*.' % namespace, '<${DRONE_BUILD_LINK}|Link to build page ↗>'])
            ],
            'when': {
                'status': 'failure',
                'event': ['push'],
            },
            'depends_on': slack_depends_on
        })

    return response


def artifactory_pipeline(ctx, title, ecr_step, depends_on=None):
    """
    Create a pipeline to deploy images to ECR.

    Parameters
    ----------
    ctx : A Drone CI context.
        The context passed by Drone CI.
    depends_on : str, optional
        The name of a pipeline that must pass for this pipeline to execute.

    Returns
    -------
    dict
        An ECR pipeline for Drone CI.
    """
    response = blank_pipeline(title, depends_on)

    # Bomb the deployment if the ARTIFACTORY_REPOSITORY is set to ''.
    if not ARTIFACTORY_REPOSITORY:
        response = add_pipeline_step(
            response,
            {
                'name': 'Deployment not implemented for this adaptor',
                'image': 'alpine:latest',
                'commands': [
                    'echo "Build event: "' + ctx.build.event,
                    'false'
                ]
            }
        )

        return response

    response = add_pipeline_step(
        response,
        retrieve_vault_dev_secrets_step(name='Retrieve Artifactory Secrets', drone_deploy_to=ctx.build.target)
    )
    response = add_pipeline_service(
        response,
        {
            'name': 'docker',
            'image': DIND_IMAGE
        }
    )
    response = add_pipeline_step(
        response,
        {
            'name': 'Validate working hours',
            'image': 'python:alpine',
            'commands': [
                'python cmd-adaptor-%s-integration-tests/src/test/resources/CheckWH.py' % COMMAND_ADAPTOR_NAME
            ],
            'environment': {
                'TZ': 'Europe/London'
            }
        }
    )
    response = add_pipeline_step(
        response,
        {
            'name': 'Wait for Docker',
            'environment': {
                'DOCKER_HOST': 'tcp://docker:2375',
            },
            'image': DIND_IMAGE,
            'commands': [
                '/usr/local/bin/wait',
            ]
        }
    )
    response = add_pipeline_step(
        response,
        {
            'name': 'Maven',
            'image': MAVEN_JAVA17_IMAGE,
            'commands': [
                '. ./set_drone_secrets.sh',
                'mvn clean install',
                'mvn -B dependency:go-offline'
            ],
            'depends_on': [
                'Validate working hours'
            ],
            'environment': {
                'DOCKER_HOST': 'tcp://docker:2375',
                'TESTCONTAINERS_RYUK_DISABLED': 'true',
                # WORKAROUND: disabling testcontainers reaper processes not compatible with drone
                # https://java.testcontainers.org/features/configuration/#disabling-ryuk
            }
        }
    )
    response = add_pipeline_step(response, ecr_step)
    return response


def fail_pipeline(ctx, title, depends_on=None):
    """
    Create a pipeline to deliberately fail drone
    """
    response = blank_pipeline(title, depends_on)
    response = add_pipeline_step(
        response,
        {
            'name': 'Failing Build',
            'image': 'alpine:latest',
            'commands': [
                'echo "Build event: "' + ctx.build.event,
                'false'
            ]
        }
    )

    return response


def get_deployment_tag(ctx):
    """
    Figure out if we're using a gitref or a SemVer tag.

    If this is a push to a branch (or a subsequent promote of that build)
    then the context will contain a branch name.  However,  if the event
    was a tag (or a subsequent promotion of that build) then the branch
    name is a blank string but the ref will be set (e.g. "refs/tags/0.1.2").

    Parameters
    ----------
    ctx : A Drone CI context.
        The context passed by Drone CI.
    """
    if ctx.build.event == 'tag':
        tag = ctx.build.ref.split('/')[2]
    elif ctx.build.event == 'promote' and ctx.build.branch == '':
        tag = ctx.build.ref.split('/')[2]
    else:
        tag = ctx.build.commit

    return tag


def renew_vault_token_pipeline():
    """
    Create a pipeline to deploy images to ECR

    Returns
    -------
    dict
        An ECR pipeline for Drone CI.

    see https://confluence.dsa.homeoffice.gov.uk/display/Digital/howto%3A+Drone+set+pipeline+vault+secrets
    """
    pipeline_name = 'Renew Vault Tokens'
    response = blank_pipeline(pipeline_name)
    response = add_pipeline_step(
        response,
        {
            'name': 'Renew Vault Tokens',
            'image': 'quay.io/ukhomeofficedigital/hashicorp-vault:1.6.0',
            'pull': 'if-not-exists',
            'commands': [
                '# Renew Dev Drone Vault Token',
                'export VAULT_TOKEN=$${VAULT_TOKEN_DEV}',
                'export VAULT_ADDR=$${VAULT_ADDR_DEV}',
                'vault token renew > /dev/null'
            ],
            'environment': {
                'VAULT_ADDR_DEV': {
                    'from_secret': 'VAULT_ADDR_DEV'
                },
                'VAULT_TOKEN_DEV': {
                    'from_secret': 'VAULT_TOKEN_DEV'
                }
            }
        }
    )
    return response


def not_implemented_pipeline(ctx, message='Not Implemented'):
    """
    Create a pipeline that indicates the workflow is not implemented.

    Parameters
    ----------
    ctx : A Drone CI context.
        The context passed by Drone CI.

    Returns
    -------
    dict
        A pipeline indicating not implemented work (and the context).
    """
    response = blank_pipeline('Not Implemented')
    response = add_pipeline_step(
        response,
        {
            'name': message,
            'image': 'alpine:latest',
            'commands': [
                'echo "Build event: "' + ctx.build.event,
                'false'
            ]
        }
    )
    return response


def invalid_deployment_mechanism_pipeline(deployment_mechanism):
    """
    Create a pipeline that indicates the KD deployment mechanism is not
    applicable to this adaptor.

    Parameters
    ----------
    deployment_mechanism : The deployment mechanism metadata for the
                         adaptor being deployed.

    Returns
    -------
    dict
        A pipeline indicating an invalid deployment mechanism.
    """
    response = blank_pipeline('Invalid Deployment Mechanism')
    if deployment_mechanism == 'DEHELM':
        response = add_pipeline_step(
            response,
            {
                'name': "Use Data Engineering Helm Chart",
                'image': 'alpine:latest',
                'commands': [
                    'echo "This adaptor uses a Data Engineering Helm Chart to deploy."',
                    'false'
                ]
            }
        )
    else:
        response = add_pipeline_step(
            response,
            {
                'name': "Use FDP Team Helm Chart",
                'image': 'alpine:latest',
                'commands': [
                    'echo "This adaptor uses a FDP Team Helm Chart to deploy."',
                    'false'
                ]
            }
        )
    return response


def promote_event(ctx):
    """
    Handle a promote event.

    Parameters
    ----------
    ctx : A Drone CI context.
        The context passed by Drone CI.

    Returns
    -------
        list of dict
            One or more pipelines to process the promotion.
    """
    environment = getattr(ctx.build, 'environment', '')

    if not environment:
        # An ugly work around as drone CLI doesn't support setting a promote
        # environment.
        promote_target = ctx.build.target.split('-')
    else:
        promote_target = environment.split('-')

    action = promote_target[0]
    namespace_type = promote_target[-1]

    if DEPLOYMENT_MECHANISM != 'KD':
        if namespace_type != 'dev' and namespace_type != 'test':
            pipeline = invalid_deployment_mechanism_pipeline(DEPLOYMENT_MECHANISM)
            return [pipeline]

    if action == 'rm':
        namespace = '-'.join(promote_target[1:])
        title = 'Remove %s' % namespace
        pipeline = deploy_pipeline(ctx, title, namespace=namespace, delete=True)
    else:
        namespace = '-'.join(promote_target)
        title = 'Deploy %s' % namespace
        pipeline = deploy_pipeline(ctx, title, namespace=namespace)

    return [pipeline]


def main(ctx):
    """
    Entry point for PLACI Drone CI Pipeline.

    Parse the context and metadata and create pipelines accordingly.

    Parameters
    ----------
    ctx : A Drone CI context.
        The context passed by Drone CI.
    """
    pipelines = []

    image_tag = get_deployment_tag(ctx)

    adaptor_artifactory_step = {
        'name': 'Publish Command Adaptor to Artifactory',
        'image': DIND_IMAGE,
        'commands': [
            'source ./set_drone_secrets.sh',
            'docker login -u="$${ARTIFACTORY_USERNAME}" -p="$${ARTIFACTORY_PASSWORD}" "$${ARTIFACTORY_REGISTRY}"',
            'docker build -t $${ARTIFACTORY_REGISTRY}/$${ARTIFACTORY_REPOSITORY}:$${IMAGE_TAG} -f cmd-adaptor-$${COMMAND_ADAPTOR_NAME}/Dockerfile cmd-adaptor-$${COMMAND_ADAPTOR_NAME}',
            'docker push $${ARTIFACTORY_REGISTRY}/$${ARTIFACTORY_REPOSITORY}:$${IMAGE_TAG}',
        ],
        'environment': {
            'IMAGE_TAG': image_tag,
            'DOCKER_HOST': 'tcp://docker:2375',
            'COMMAND_ADAPTOR_NAME': COMMAND_ADAPTOR_NAME,
            'ARTIFACTORY_REGISTRY': ARTIFACTORY_REGISTRY,
            'ARTIFACTORY_REPOSITORY': ARTIFACTORY_REPOSITORY,
        },
        'depends_on': [
            'Retrieve Artifactory Secrets',
            'Maven',
            'Wait for Docker'
        ]
    }
    adaptor_artifactory_e2e_step = {
        'name': 'Publish End-to-End Test to Artifactory',
        'image': DIND_IMAGE,
        'commands': [
            'source ./set_drone_secrets.sh',
            'docker login -u="$${ARTIFACTORY_USERNAME}" -p="$${ARTIFACTORY_PASSWORD}" "$${ARTIFACTORY_REGISTRY}"',
            'docker build -t $${ARTIFACTORY_REGISTRY}/$${ARTIFACTORY_REPOSITORY}:$${IMAGE_TAG} -f Dockerfile.smoketest .',
            'docker push $${ARTIFACTORY_REGISTRY}/$${ARTIFACTORY_REPOSITORY}:$${IMAGE_TAG}',
        ],
        'environment': {
            'IMAGE_TAG': '%s-e2e' % image_tag,
            'DOCKER_HOST': 'tcp://docker:2375',
            'COMMAND_ADAPTOR_NAME': COMMAND_ADAPTOR_NAME,
            'ARTIFACTORY_REGISTRY': ARTIFACTORY_REGISTRY,
            'ARTIFACTORY_REPOSITORY': ARTIFACTORY_REPOSITORY,
        },
        'depends_on': [
            'Retrieve Artifactory Secrets',
            'Maven',
            'Wait for Docker'
        ]
    }
    sds_listener_artifactory_step = {
        'name': 'Publish Listener to Artifactory',
        'image': DIND_IMAGE,
        'commands': [
            'source ./set_drone_secrets.sh',
            'docker login -u="$${ARTIFACTORY_USERNAME}" -p="$${ARTIFACTORY_PASSWORD}" "$${ARTIFACTORY_REGISTRY}"',
            'docker build -t $${ARTIFACTORY_REGISTRY}/$${ARTIFACTORY_REPOSITORY}:listener-${DRONE_BUILD_NUMBER} -f $${COMMAND_ADAPTOR_NAME}/Dockerfile $${COMMAND_ADAPTOR_NAME}',
            'docker push $${ARTIFACTORY_REGISTRY}/$${ARTIFACTORY_REPOSITORY}:listener-${DRONE_BUILD_NUMBER}',
        ],
        'environment': {
            'DOCKER_HOST': 'tcp://docker:2375',
            'COMMAND_ADAPTOR_NAME': 'cmd-adaptor-listener-%s' % COMMAND_ADAPTOR_NAME,
            'ARTIFACTORY_REGISTRY': ARTIFACTORY_REGISTRY,
            'ARTIFACTORY_REPOSITORY': ARTIFACTORY_REPOSITORY,
        },
        'depends_on': [
            'Retrieve Artifactory Secrets',
            'Maven',
            'Wait for Docker'
        ]
    }
    ctp_reporting_artifactory_step = {
        'name': 'Publish CTP Reporting to Artifactory',
        'image': DIND_IMAGE,
        'commands': [
            'source ./set_drone_secrets.sh',
            'docker login -u="$${ARTIFACTORY_USERNAME}" -p="$${ARTIFACTORY_PASSWORD}" "$${ARTIFACTORY_REGISTRY}"',
            'docker build -t $${ARTIFACTORY_REGISTRY}/$${ARTIFACTORY_REPOSITORY}:$${IMAGE_TAG} -f cmd-adaptor-$${COMMAND_ADAPTOR_NAME}-reporting/Dockerfile cmd-adaptor-$${COMMAND_ADAPTOR_NAME}-reporting',
            'docker push $${ARTIFACTORY_REGISTRY}/$${ARTIFACTORY_REPOSITORY}:$${IMAGE_TAG}',
        ],
        'environment': {
            'IMAGE_TAG': '%s-reporting' % image_tag,
            'DOCKER_HOST': 'tcp://docker:2375',
            'COMMAND_ADAPTOR_NAME': COMMAND_ADAPTOR_NAME,
            'ARTIFACTORY_REGISTRY': ARTIFACTORY_REGISTRY,
            'ARTIFACTORY_REPOSITORY': ARTIFACTORY_REPOSITORY,
        },
        'depends_on': [
            'Retrieve Artifactory Secrets',
            'Maven',
            'Wait for Docker'
        ]
    }

    if ctx.build.event == 'promote':
        pipelines = promote_event(ctx)
    elif ctx.build.event == 'push':
        if ctx.build.branch == 'master':
            pipelines.append(blank_pipeline('push to master'))
        elif ctx.build.branch == 'develop':
            pipelines.append(ci_pipeline(ctx))

            if ctx.build.message.strip() != 'Update for next development version':

                # Current pipeline setup pushing cmd adapter images to ARTIFACTORY
                adaptor_step_name = 'ARTIFACTORY Adaptor'
                adaptor_pipline = artifactory_pipeline(
                    ctx,
                    adaptor_step_name,
                    adaptor_artifactory_step,
                    depends_on=['CI']
                )

                e2e_step_name = 'ARTIFACTORY E2E'
                e2e_pipline = artifactory_pipeline(
                    ctx,
                    e2e_step_name,
                    adaptor_artifactory_e2e_step,
                    depends_on=['CI']
                )

                pipelines.append(adaptor_pipline)
                pipelines.append(e2e_pipline)

                if COMMAND_ADAPTOR_NAME == 'sds':
                    pipelines.append(artifactory_pipeline(
                        ctx,
                        'ARTIFACTORY Listener',
                        sds_listener_artifactory_step,
                        depends_on=['CI'])
                    )

                if COMMAND_ADAPTOR_NAME == 'ctp':
                    pipelines.append(artifactory_pipeline(
                        ctx,
                        'ECR Reporting',
                        ctp_reporting_artifactory_step,
                        depends_on=['CI'])
                    )

                pipelines.append(
                    deploy_pipeline(
                        ctx,
                        'CD',
                        [adaptor_step_name, e2e_step_name],
                        'dacc-dde-dev'
                    )
                )
                pipelines.append(
                    deploy_pipeline(
                        ctx,
                        'Cleardown',
                        ['CD'],
                        'dacc-dde-dev',
                        True
                    )
                )
        else:
            pipelines.append(ci_pipeline(ctx))

    elif ctx.build.event == 'pull_request':
        pipelines.append(blank_pipeline('GitLab MR'))
    elif ctx.build.event == 'tag':
        # Current pipeline setup pushing cmd adapter images to artifactory
        adaptor_step_name = 'ARTIFACTORY Adaptor'
        adaptor_pipline = artifactory_pipeline(
            ctx,
            adaptor_step_name,
            adaptor_artifactory_step
        )

        e2e_step_name = 'ARTIFACTORY E2E'
        e2e_pipline = artifactory_pipeline(
            ctx,
            e2e_step_name,
            adaptor_artifactory_e2e_step
        )

        pipelines.append(adaptor_pipline)
        pipelines.append(e2e_pipline)

        if COMMAND_ADAPTOR_NAME == 'sds':
            pipelines.append(artifactory_pipeline(
                ctx,
                'SDS Listerner',
                sds_listener_artifactory_step)
            )

        if COMMAND_ADAPTOR_NAME == 'ctp':
            pipelines.append(artifactory_pipeline(
                ctx,
                'CTP Reporting',
                ctp_reporting_artifactory_step)
            )

        pipelines.append(deploy_pipeline(ctx, 'CD', [adaptor_step_name, e2e_step_name], 'dacc-dde-test'))
        pipelines.append(deploy_pipeline(ctx, 'Cleardown', ['CD'], 'dacc-dde-test', True))

    elif ctx.build.event == 'cron' and ctx.build.cron == 'renew-vault-tokens':
        pipelines.append(renew_vault_token_pipeline())

    else:
        pipelines.append(not_implemented_pipeline(ctx))

    return pipelines
