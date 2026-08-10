#!/bin/sh

#############################################################################
# WARNING: This file is controlled via RepoSync, any changes made in the
# command adaptor repository will be overwritten by the RepoSync process.
# See https://gitlab.digital.homeoffice.gov.uk/dacc-de/dde-adaptor-reposync
#############################################################################

echo "Working directory: $( pwd )"
echo "Directory listing:"
ls -l

if [ -f bin/pre-integration-test-local.sh ]; then
  bin/pre-integration-test-local.sh
else
  echo 'INFO: No local pre-integration tests configured.'
fi
