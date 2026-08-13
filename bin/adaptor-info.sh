#!/bin/sh

#############################################################################
# WARNING: This file is controlled via RepoSync, any changes made in the
# command adaptor repository will be overwritten by the RepoSync process.
# See https://gitlab.digital.homeoffice.gov.uk/dacc-de/dde-adaptor-reposync
#############################################################################

MAVEN_REPO_LOCAL="${MAVEN_REPO_LOCAL:-.m2}"

# shellcheck disable=SC2016
POM_PROPERTIES=$(
  echo '${aggregator-core.version}:${fdp-bom.version}:${cdlz-avro-schemas.version}:${fdp-commons.version}' |
	mvn org.apache.maven.plugins:maven-help-plugin:3.2.0:evaluate \
	  -N \
	  -q \
	  -DforceStdout \
	  -Dmaven.repo.local="$MAVEN_REPO_LOCAL"
)

AGGREGATOR_CORE_VERSION=$(echo "$POM_PROPERTIES" | cut -d: -f1)
FDP_BOM_VERSION=$(echo "$POM_PROPERTIES" | cut -d: -f2)
CDLZ_AVRO_SCHEMAS_VERSION=$(echo "$POM_PROPERTIES" | cut -d: -f3)
FDP_COMMONS_VERSION=$(echo "$POM_PROPERTIES" | cut -d: -f4)

[ "$CDLZ_AVRO_SCHEMAS_VERSION" = "null object or invalid expression" ] && CDLZ_AVRO_SCHEMAS_VERSION='N/A'

echo "| Aggregator Core | ${AGGREGATOR_CORE_VERSION} |"
echo "| FDP BOM | ${FDP_BOM_VERSION} |"
echo "| CDLZ Avro Schemas | ${CDLZ_AVRO_SCHEMAS_VERSION} |"
echo "| FDP Commons | ${FDP_COMMONS_VERSION} |"
