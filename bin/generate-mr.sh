#!/bin/sh

#############################################################################
# WARNING: This file is controlled via RepoSync, any changes made in the
# command adaptor repository will be overwritten by the RepoSync process.
# See https://gitlab.digital.homeoffice.gov.uk/dacc-de/dde-adaptor-reposync
#############################################################################

#############################################################################
# Generate the description for a Release MR.
#
# Synopsis
# ========
#   generate-mr.sh -f url -r url
#
#     Where:
#       -f provides the URL to the filesafe report (required).
#       -r provides the URL to the Jira release (required).
#
# Pre-Requirements
# ================
#
# 1. You will need to have created the release branch and be on it in your
#    cloned directory.
# 2. You will need to know the URL of the Failsafe report and provide it
#    with the "-f" flag.
# 3. You will need to know the URL to the Jira release and provide it with
#    the "-r" flag.
#############################################################################

PROG=$( basename "$0" )
TMP_GIT_CLONE_DIR="/tmp/${PROG}.$$.tmp"

# Check to see if a file exists.  If it doesn't, give a critical error and
# exit.
check_for_mandatory_file() {
  filename="$1"

  if [ ! -f "$filename" ]; then
    echo "CRITICAL: Unable to find file ${filename}."
    exit 1
  fi
}

# Identify if the main branch is called "main" or the deprecated name of
# "master".
get_main_branch() {
  if grep -q productionBranch pom.xml ; then
    grep productionBranch pom.xml | cut -d\> -f2 | cut -d\< -f1
  else
    echo 'master'
  fi
}

# Extract the version of RepoSync from a provided Dronestar file.
get_reposync_version() {
  dronestar_file="$1"
  grep 'RepoSync Version:' "$dronestar_file" | cut -d: -f2 | sed 's/[ "]//g' | tr -d "'"
}

# Check that we're on a release branch (e.g. release/1.2.3).  if we're not
# give an error message and exit.
is_on_release_branch() {
  if ! git status -bs | cut -d\# -f3 | cut -d. -f1 | tr -d ' ' | grep -q '^release/'; then
    echo "ERROR: You don't appear to be on a release branch!!!"
    exit 2
  fi
}

# Display a usage message.
usage() {
  echo "usage: ${PROG} -r url"
  echo ""
  echo "  Where:"
  echo "    -r provides the URL to the Jira release (required)."
}

check_for_mandatory_file .drone.star
check_for_mandatory_file .git/config
check_for_mandatory_file pom.xml
check_for_mandatory_file sonar-project.properties
is_on_release_branch

RELEASE_URL=''

while getopts "hr:" OPTION; do
  case "${OPTION}" in
    h) usage && exit 0 ;;
    r) RELEASE_URL="${OPTARG}" ;;
    *) echo "Unknown option ${OPTION}" && usage && exit 2 ;;
  esac
done

if [ -z "${RELEASE_URL}" ]; then
  usage
  exit 2
fi

INTEGRATION_TESTS_DIR=$( grep '^cmd-adaptor-.*-integration-tests.sonar.projectName[= ]' sonar-project.properties )
GIT_REMOTE_ORIGIN_URL="$( git config --get remote.origin.url )"

# shellcheck disable=SC2016
POM_PROPERTIES=$( echo '${project.version}:${aggregator-core.version}:${fdp-bom.version}:${cdlz-avro-schemas.version}:${fdp-commons.version}' | mvn org.apache.maven.plugins:maven-help-plugin:3.2.0:evaluate -N -q -DforceStdout )

PROJECT_VERSION=$( echo "$POM_PROPERTIES" | cut -d: -f1 )
FDP_CORE_VERSION=$( echo "$POM_PROPERTIES" | cut -d: -f2 )
FDP_BOM_VERSION=$( echo "$POM_PROPERTIES" | cut -d: -f3 )
CDLZ_AVRO_SCHEMAS_VERSION=$( echo "$POM_PROPERTIES" | cut -d: -f4 )
FDP_COMMONS_VERSION=$( echo "$POM_PROPERTIES" | cut -d: -f5 )

NEW_REPOSYNC_VERSION=$( get_reposync_version .drone.star )
MAIN_BRANCH=$( get_main_branch )

git clone -qb "${MAIN_BRANCH}" "${GIT_REMOTE_ORIGIN_URL}" "${TMP_GIT_CLONE_DIR}"
OLD_REPOSYNC_VERSION=$( get_reposync_version "${TMP_GIT_CLONE_DIR}/.drone.star" )
rm -rf "${TMP_GIT_CLONE_DIR}"

ADAPTOR_NAME=$( echo "$INTEGRATION_TESTS_DIR" | cut -d- -f3 )
FAILSAFE_URL="https://failsafe-reports.dacc-dde-dev.dacc-notprod.homeoffice.gov.uk/feed/${ADAPTOR_NAME}"


echo "INFO: Adaptor Name and Version is ${ADAPTOR_NAME}-${PROJECT_VERSION}."
echo "INFO: FDP Core Version is ${FDP_CORE_VERSION}."
echo "INFO: FDP BoM Version is ${FDP_BOM_VERSION}."
echo "INFO: CDLZ Avro Schemas Version is ${CDLZ_AVRO_SCHEMAS_VERSION}."
echo "INFO: FDP Commons Version is ${FDP_COMMONS_VERSION}."
echo "INFO: Remote Git URL is ${GIT_REMOTE_ORIGIN_URL}."
echo "INFO: Production branch of Repo is ${MAIN_BRANCH}."
echo "INFO: Current RepoSync version is ${NEW_REPOSYNC_VERSION}."
echo "INFO: Previous RepoSync version is ${OLD_REPOSYNC_VERSION}."

cat <<_EOF
-----BEGIN MERGE REQUEST DESCRIPTION BLOCK-----
# Background

This MR is marked as Draft to avoid accidental merging.  Please review/approve
as normal as the branch needs to be finished with the Maven GitFlow plugin.

_EOF

if [ -n "${OLD_REPOSYNC_VERSION}" ] && [ "${OLD_REPOSYNC_VERSION}" != "${NEW_REPOSYNC_VERSION}" ]; then
cat <<_EOF
- Upgrade
  [RepoSync](https://gitlab.digital.homeoffice.gov.uk/dacc-de/dde-adaptor-reposync/-/blob/develop/CHANGELOG.md)
  from ${OLD_REPOSYNC_VERSION} to ${NEW_REPOSYNC_VERSION}.
_EOF
fi

cat <<_EOF
- Tickets relating to this release can be seen in
  [${ADAPTOR_NAME}-${PROJECT_VERSION}](${RELEASE_URL}).

# FDP Provided Components

These should match the latest supported matrix maintained by FDP Team
<https://confluence.dsa.homeoffice.gov.uk/pages/viewpage.action?pageId=145402402>.

| Component                         | Version                      |
| --------------------------------- | ---------------------------- |
| Kafka Connect (S3) Tag            | 1.1.5                        |
| Aggregator Core Tag               | ${FDP_CORE_VERSION}          |
| FDP-BOM                           | ${FDP_BOM_VERSION}           |
| CDLZ Avro Schemas                 | ${CDLZ_AVRO_SCHEMAS_VERSION} |
| FDP-Commons                       | ${FDP_COMMONS_VERSION}       |

# Failsafe Report
Reports available when attached to the KUBE-PLATFORM VPN during the hours
08:00 - 18:00 on week days:

- ${FAILSAFE_URL}
-----END MERGE REQUEST DESCRIPTION BLOCK-----
_EOF
