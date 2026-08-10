#!/bin/sh -e

#############################################################################
# WARNING: This file is controlled via RepoSync, any changes made in the
# command adaptor repository will be overwritten by the RepoSync process.
# See https://gitlab.digital.homeoffice.gov.uk/dacc-de/dde-adaptor-reposync
#############################################################################

#############################################################################
# Extract the Avro schema from the schema registry and consume Avro data
# from the Kafka brokers for populated topics.
#
# Requires the following environment variables to be set:
#   - ADAPTOR_NAME (e.g. pnr).
#   - KAFKA_REST_BOOTSTRAP_SERVERS the URL to the Kafka broker(s).
#   - KAFKA_REST_SCHEMA_REGISTRY_URL the URL of the Schema registry.
#############################################################################

ARCHIVE_NAME="/mnt/downloads/local-${ADAPTOR_NAME}-$( date -u +'%Y%m%dT%H%MZ' ).tgz"
DIR_BASE_NAME="${ADAPTOR_NAME}-local"
DIR_FULL_NAME="/tmp/${DIR_BASE_NAME}"
SUMMARY_FILE="${DIR_FULL_NAME}/${ADAPTOR_NAME}-topic-count.txt"
TIMEOUT_MS=1000

consume_avro() {
  # Consume Avro from the topic.
  kafka-avro-console-consumer \
    --bootstrap-server "$KAFKA_REST_BOOTSTRAP_SERVERS" \
    --property schema.registry.url="${KAFKA_REST_SCHEMA_REGISTRY_URL}" \
    --from-beginning \
    --timeout-ms "${TIMEOUT_MS}" \
    --topic "$topic" \
  | grep '^{'
}

get_schema() {
  # Extract the Avro schema from the Schema Registry.
  curl -s "${KAFKA_REST_SCHEMA_REGISTRY_URL}/subjects/${topic}-value/versions/latest" \
    | jq .schema \
    | sed -e 's|^"||g' -e 's|"$||g' -e 's|\\"|"|g' -e 's|\\\\n||g' -e 's|\\\\"||g'
}

list_all_topics() {
  # List all topics on the brokers.
  kafka-topics --list --bootstrap-server "${KAFKA_REST_BOOTSTRAP_SERVERS}"
}

list_non_empty_topics() {
  # List topics that have one or messages in one or more partitions.
  kafka-run-class kafka.tools.GetOffsetShell \
    --bootstrap-server "$KAFKA_REST_BOOTSTRAP_SERVERS" \
    --exclude-internal-topics \
  | grep -v -e ':0$' \
  | cut -d: -f1 \
  | sort -u
}

topic_filter() {
  # Filter out bollocks topics.
  grep -e '^fdp' -e '^from-matching' -e '^to-matching' -e '^runlog_fdp' \
  | grep -v -e '^_' -e 'changelog$' -e 'repartition$'
}

echo "INFO: Recreating ${DIR_FULL_NAME}"
if [ -d "${DIR_FULL_NAME}" ]; then
  rm -rf "${DIR_FULL_NAME}"
fi
mkdir -p "${DIR_FULL_NAME}"

for topic in $( list_non_empty_topics | topic_filter ); do
  echo "INFO: Extracting the schema for ${topic}."
  get_schema > "${DIR_FULL_NAME}/${topic}-schema.json"
  echo "INFO: Consuming Avro for ${topic}."
  consume_avro > "${DIR_FULL_NAME}/${topic}-data.json"
done

# Create the topic summary file.  If a data file exists for the topic count
# the number of lines for the topic as the message count.  Otherwise assume
# it was zero messages.
for topic in $( list_all_topics | topic_filter ); do
  if [ -f "${DIR_FULL_NAME}/${topic}-data.json" ]; then
    topic_count=$( wc -l "${DIR_FULL_NAME}/${topic}-data.json" | awk '{print $1}' )
  else
    topic_count=0
  fi

  echo "${topic}:${topic_count}" >> "${SUMMARY_FILE}"
done

cd /tmp || exit 2
tar cvzf "$ARCHIVE_NAME" "./${DIR_BASE_NAME}"
