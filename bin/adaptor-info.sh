#!/bin/sh

#############################################################################
# WARNING: This file is controlled via RepoSync, any changes made in the
# command adaptor repository will be overwritten by the RepoSync process.
# See https://gitlab.digital.homeoffice.gov.uk/dacc-de/dde-adaptor-reposync
#############################################################################

echo "| Aggregator Core | $(mvn org.apache.maven.plugins:maven-help-plugin:3.2.0:evaluate -Dexpression=aggregator-core.version -q -DforceStdout) |"
echo "| FDP BOM | $(mvn org.apache.maven.plugins:maven-help-plugin:3.2.0:evaluate -Dexpression=fdp-bom.version -q -DforceStdout) |"

CDLZ_AVRO_SCHEMAS_VERSION="$(mvn org.apache.maven.plugins:maven-help-plugin:3.2.0:evaluate -Dexpression=cdlz-avro-schemas.version -q -DforceStdout)"
[[ "$CDLZ_AVRO_SCHEMAS_VERSION" == "null object or invalid expression" ]] && CDLZ_AVRO_SCHEMAS_VERSION='N/A'
echo "| CDLZ Avro Schemas | ${CDLZ_AVRO_SCHEMAS_VERSION} |"

echo "| FDP Commons | $(mvn org.apache.maven.plugins:maven-help-plugin:3.2.0:evaluate -Dexpression=fdp-commons.version -q -DforceStdout) |"
