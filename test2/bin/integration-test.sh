#!/bin/sh

#############################################################################
# WARNING: This file is controlled via RepoSync, any changes made in the
# command adaptor repository will be overwritten by the RepoSync process.
# See https://gitlab.digital.homeoffice.gov.uk/dacc-de/dde-adaptor-reposync
#############################################################################

if [ -f bin/integration-test-local.sh ]; then
  bin/integration-test-local.sh
else
  echo 'INFO: No local integration tests configured.'
fi
