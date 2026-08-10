#!/usr/bin/env bash
#
# T3.3 - Dockerfile Layer-Order Prototype Measurement Script
# Repository: fdp-cmd-adaptor-sns
# Module: cmd-adaptor-sns
#
# Run this from the repository root (the directory containing the
# cmd-adaptor-sns/ module folder), on the customer machine where Docker
# is available and Maven can resolve the private FDP artifacts.
#
# Usage:
#   cd <repo-root>
#   ./cmd-adaptor-sns/T3.3-run-measurements.sh
#
# All raw output is captured under /tmp/sns-t33-*.log and a machine-readable
# summary is written to /tmp/sns-t33-summary.txt. Nothing here modifies the
# production Dockerfile.

set -uo pipefail

MODULE_DIR="cmd-adaptor-sns"
PROD_DOCKERFILE="${MODULE_DIR}/Dockerfile"
PROTO_DOCKERFILE="${MODULE_DIR}/Dockerfile.layer-order-prototype"
JAR="${MODULE_DIR}/target/cmd-adaptor-sns-exec.jar"
AGENT="${MODULE_DIR}/target/dependencies/opentelemetry-javaagent.jar"

# Write all output under the repo checkout, not /tmp - some environments
# (VDI / ephemeral dev containers) clear /tmp between sessions or commands,
# which silently loses the evidence after the script has already finished.
RESULTS_DIR="${MODULE_DIR}/T3.3-artifacts"
mkdir -p "$RESULTS_DIR"
SUMMARY="${RESULTS_DIR}/summary.txt"

log() { echo "[$(date '+%H:%M:%S')] $*"; }
section() { echo; echo "=== $* ==="; echo; }

: > "$SUMMARY"
record() { echo "$*" | tee -a "$SUMMARY"; }

section "0. Pre-flight checks"

FAIL=0

if [ ! -f "$PROD_DOCKERFILE" ]; then
  log "ERROR: production Dockerfile not found at $PROD_DOCKERFILE"
  FAIL=1
else
  log "OK: production Dockerfile found at $PROD_DOCKERFILE"
fi

if [ ! -f "$PROTO_DOCKERFILE" ]; then
  log "ERROR: prototype Dockerfile not found at $PROTO_DOCKERFILE"
  FAIL=1
else
  log "OK: prototype Dockerfile found at $PROTO_DOCKERFILE"
fi

if [ ! -f "$JAR" ]; then
  log "ERROR: required artefact missing: $JAR"
  log "Run: mvn -pl ${MODULE_DIR} -am -DskipTests clean package (or install) from repo root first."
  FAIL=1
else
  log "OK: found $JAR"
fi

if [ ! -f "$AGENT" ]; then
  log "ERROR: required artefact missing: $AGENT"
  FAIL=1
else
  log "OK: found $AGENT"
fi

if ! docker version >/dev/null 2>&1; then
  log "ERROR: Docker daemon not reachable. Start Docker and re-run."
  FAIL=1
else
  log "OK: Docker daemon reachable"
fi

# Confirm production Dockerfile is untouched by this script (checksum only, no writes)
PROD_SHA_BEFORE=$(shasum -a 256 "$PROD_DOCKERFILE" 2>/dev/null | awk '{print $1}')

if [ "$FAIL" -ne 0 ]; then
  log "Pre-flight checks failed. Aborting before any build."
  exit 1
fi

record "artefact_check=pass"
record "production_dockerfile_sha_before=${PROD_SHA_BEFORE}"

section "1. Current Dockerfile no-cache build (after T3.2)"
/usr/bin/time -p docker build --no-cache \
  -t cmd-adaptor-sns:t33-current-no-cache \
  -f "$PROD_DOCKERFILE" \
  "$MODULE_DIR/" 2>&1 | tee ${RESULTS_DIR}/current-no-cache.log
CURRENT_NOCACHE_TIME=$(grep -E '^real' ${RESULTS_DIR}/current-no-cache.log | tail -1)
record "current_no_cache_build_timing=${CURRENT_NOCACHE_TIME}"

docker images cmd-adaptor-sns:t33-current-no-cache | tee -a "$SUMMARY"

log "Smoke check: current no-cache image"
docker run --rm --entrypoint sh cmd-adaptor-sns:t33-current-no-cache -c \
  'java -version && test -f /local/cmd-adaptor-sns-exec.jar && test -f /local/opentelemetry-javaagent.jar && echo "current image smoke passed"' \
  2>&1 | tee -a ${RESULTS_DIR}/current-no-cache.log

section "2. Layer-order prototype no-cache build"
/usr/bin/time -p docker build --no-cache \
  -t cmd-adaptor-sns:t33-layer-order-no-cache \
  -f "$PROTO_DOCKERFILE" \
  "$MODULE_DIR/" 2>&1 | tee ${RESULTS_DIR}/layer-order-no-cache.log
LAYERORDER_NOCACHE_TIME=$(grep -E '^real' ${RESULTS_DIR}/layer-order-no-cache.log | tail -1)
record "layer_order_no_cache_build_timing=${LAYERORDER_NOCACHE_TIME}"

docker images cmd-adaptor-sns:t33-layer-order-no-cache | tee -a "$SUMMARY"

log "Smoke check: layer-order no-cache image"
docker run --rm --entrypoint sh cmd-adaptor-sns:t33-layer-order-no-cache -c \
  'java -version && envconsul --version && test -f /local/cmd-adaptor-sns-exec.jar && test -f /local/opentelemetry-javaagent.jar && echo "layer-order candidate smoke passed"' \
  2>&1 | tee -a ${RESULTS_DIR}/layer-order-no-cache.log

section "3. Application JAR change — touch method"
touch "$JAR"
JAR_SHA_AFTER_TOUCH=$(shasum -a 256 "$JAR" | awk '{print $1}')
record "jar_sha_after_touch=${JAR_SHA_AFTER_TOUCH}"

section "3a. Current Dockerfile warm-cache rebuild after touch"
/usr/bin/time -p docker build \
  -t cmd-adaptor-sns:t33-current-warm-after-jar-touch \
  -f "$PROD_DOCKERFILE" \
  "$MODULE_DIR/" 2>&1 | tee ${RESULTS_DIR}/current-warm-after-jar-touch.log
CURRENT_WARM_TOUCH_TIME=$(grep -E '^real' ${RESULTS_DIR}/current-warm-after-jar-touch.log | tail -1)
record "current_warm_after_touch_timing=${CURRENT_WARM_TOUCH_TIME}"

CURRENT_YUM_CACHED=$(grep -iE 'yum install|CACHED' ${RESULTS_DIR}/current-warm-after-jar-touch.log | grep -i CACHED | head -3)
record "current_warm_after_touch_cached_lines:"
echo "${CURRENT_YUM_CACHED}" | tee -a "$SUMMARY"

section "3b. Layer-order prototype warm-cache rebuild after touch"
/usr/bin/time -p docker build \
  -t cmd-adaptor-sns:t33-layer-order-warm-after-jar-touch \
  -f "$PROTO_DOCKERFILE" \
  "$MODULE_DIR/" 2>&1 | tee ${RESULTS_DIR}/layer-order-warm-after-jar-touch.log
LAYERORDER_WARM_TOUCH_TIME=$(grep -E '^real' ${RESULTS_DIR}/layer-order-warm-after-jar-touch.log | tail -1)
record "layer_order_warm_after_touch_timing=${LAYERORDER_WARM_TOUCH_TIME}"

LAYERORDER_YUM_CACHED=$(grep -iE 'yum install|CACHED' ${RESULTS_DIR}/layer-order-warm-after-jar-touch.log | grep -i CACHED | head -3)
record "layer_order_warm_after_touch_cached_lines:"
echo "${LAYERORDER_YUM_CACHED}" | tee -a "$SUMMARY"

# Detect whether touch alone changed the JAR's content hash vs a real rebuild.
# If Docker's COPY cache key is content-based, a timestamp-only touch may not
# invalidate the layer. Flag this explicitly rather than assuming either way.
record "note=If current_warm_after_touch shows the COPY layer as CACHED with no yum re-run either way, timestamp-only touch may not have invalidated content-based cache keys. Repeat with a real artefact rebuild (mvn package) if so, and re-run sections 3a/3b."

section "4. Image size comparison"
for img in \
  cmd-adaptor-sns:t33-current-no-cache \
  cmd-adaptor-sns:t33-layer-order-no-cache \
  cmd-adaptor-sns:t33-current-warm-after-jar-touch \
  cmd-adaptor-sns:t33-layer-order-warm-after-jar-touch ; do
  docker images "$img" | tail -n +2
done | tee -a "$SUMMARY"

section "5. Optional Trivy scan (layer-order image only, non-blocking)"
if command -v trivy >/dev/null 2>&1; then
  trivy image --severity CRITICAL,HIGH --exit-code 0 cmd-adaptor-sns:t33-layer-order-no-cache 2>&1 | tee ${RESULTS_DIR}/trivy.log
else
  log "trivy not installed - skipping optional scan"
  record "trivy_scan=skipped (not installed)"
fi

section "6. Confirm production Dockerfile was not modified"
PROD_SHA_AFTER=$(shasum -a 256 "$PROD_DOCKERFILE" 2>/dev/null | awk '{print $1}')
record "production_dockerfile_sha_after=${PROD_SHA_AFTER}"
if [ "$PROD_SHA_BEFORE" = "$PROD_SHA_AFTER" ]; then
  record "production_dockerfile_unmodified=true"
else
  record "production_dockerfile_unmodified=FALSE -- INVESTIGATE, SHA CHANGED"
fi

section "Done"
log "Raw logs: ${RESULTS_DIR}/*.log"
log "Summary: $SUMMARY"
cat "$SUMMARY"