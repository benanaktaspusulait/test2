#!/bin/sh

#############################################################################
# WARNING: This file is controlled via RepoSync, any changes made in the
# command adaptor repository will be overwritten by the RepoSync process.
# See https://gitlab.digital.homeoffice.gov.uk/dacc-de/dde-adaptor-reposync
#############################################################################

SLEEP_TIME=60
RUNNING_CONTAINER=0

function wait_for_running_container {
  status=1
  pattern="${ADAPTOR_NAME}-e2e-test"

  while (( status == 1 )); do
    echo "INFO: Checking for any running pods associated with ${ADAPTOR_NAME}"
    kd run get pods 2> /dev/null | grep -q "^${ADAPTOR_NAME}-e2e-test" | grep Running
    status=$?
  done
}

while true; do
  wait_for_running_container
  kd run logs -f job/${ADAPTOR_NAME}-e2e-test
done
