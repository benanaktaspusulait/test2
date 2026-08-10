#!/bin/sh

#############################################################################
# WARNING: This file is controlled via RepoSync, any changes made in the
# command adaptor repository will be overwritten by the RepoSync process.
# See https://gitlab.digital.homeoffice.gov.uk/dacc-de/dde-adaptor-reposync
#############################################################################

# The Docker entry point for the system under test (SUT)
# image.
set -e

ISO8601_TIMESTAMP=$( date +'%Y%m%dT%H%M' )
S3_OBJECT_NAME="s3://${S3_BUCKET}/failsafe-reports/${KUBE_NAMESPACE}/${ADAPTOR_NAME}/${ISO8601_TIMESTAMP}.html"
REPORT_FILE_NAME="cmd-adaptor-${ADAPTOR_NAME}-integration-tests/target/site/failsafe-report.html"

echo "INFO: Running E2E Tests in ${KUBE_NAMESPACE} namespace."
mvn install surefire-report:failsafe-report-only \
  -pl "cmd-adaptor-${ADAPTOR_NAME}-integration-tests" \
  "-Pk8s-${KUBE_NAMESPACE}" \
  -s /home/ileap/.m2/settings.xml

if [ -f $REPORT_FILE_NAME ]; then
  aws s3 cp --sse=aws:kms --sse-kms-key-id $KMS_KEY_ID $REPORT_FILE_NAME $S3_OBJECT_NAME
else
  echo "WARN: The file ${REPORT_FILE_NAME} does not exist."
fi
