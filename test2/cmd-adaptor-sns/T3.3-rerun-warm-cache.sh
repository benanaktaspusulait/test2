#!/usr/bin/env bash
#
# T3.3 - Warm-cache re-test with a REAL content change (not timestamp-only touch)
#
# The first run showed both Dockerfiles reporting the COPY layer as CACHED
# after a `touch` on the jar. That proves touch did not change the file's
# content hash - it does NOT prove or disprove the layer-order hypothesis.
#
# This script forces an actual content change to the jar (appends a byte),
# then reruns the two warm-cache builds so the COPY layer is genuinely
# invalidated in both Dockerfiles. This is the valid version of Section 3
# from T3.3-run-measurements.sh.
#
# Run from the repo root, same as the main script.

set -uo pipefail

MODULE_DIR="cmd-adaptor-sns"
PROD_DOCKERFILE="${MODULE_DIR}/Dockerfile"
PROTO_DOCKERFILE="${MODULE_DIR}/Dockerfile.layer-order-prototype"
JAR="${MODULE_DIR}/target/cmd-adaptor-sns-exec.jar"

# Write under the repo checkout, not /tmp - some environments (VDI / ephemeral
# dev containers) clear /tmp between sessions, silently losing the evidence
# after the script has already finished successfully.
RESULTS_DIR="${MODULE_DIR}/T3.3-artifacts"
mkdir -p "$RESULTS_DIR"
SUMMARY="${RESULTS_DIR}/rerun-summary.txt"

log() { echo "[$(date '+%H:%M:%S')] $*"; }
section() { echo; echo "=== $* ==="; echo; }
record() { echo "$*" | tee -a "$SUMMARY"; }

: > "$SUMMARY"

if [ ! -f "$JAR" ]; then
  log "ERROR: $JAR not found. Run the Maven build first."
  exit 1
fi

SHA_BEFORE=$(shasum -a 256 "$JAR" | awk '{print $1}')
record "jar_sha_before_content_change=${SHA_BEFORE}"

section "Forcing a real content change to the JAR (append one byte)"
# This changes the file's content hash without needing a full Maven rebuild.
# It is a legitimate way to test Docker's content-based cache invalidation,
# though a real `mvn package` rebuild is closer to the real-world trigger.
# We do this non-destructively: append then keep the file usable as a cache-key
# test artefact only (not run as a real jar in this test).
printf '\0' >> "$JAR"

SHA_AFTER=$(shasum -a 256 "$JAR" | awk '{print $1}')
record "jar_sha_after_content_change=${SHA_AFTER}"

if [ "$SHA_BEFORE" = "$SHA_AFTER" ]; then
  log "ERROR: content hash did not change - append failed. Aborting."
  exit 1
fi
record "content_hash_changed=true"

section "3a-rerun. Current Dockerfile warm-cache rebuild after real content change"
/usr/bin/time -p docker build \
  -t cmd-adaptor-sns:t33-current-warm-after-real-change \
  -f "$PROD_DOCKERFILE" \
  "$MODULE_DIR/" 2>&1 | tee ${RESULTS_DIR}/current-warm-after-real-change.log
CURRENT_TIME=$(grep -E '^real' ${RESULTS_DIR}/current-warm-after-real-change.log | tail -1)
record "current_warm_after_real_change_timing=${CURRENT_TIME}"
record "current_warm_after_real_change_cached_lines:"
grep -iE 'CACHED' ${RESULTS_DIR}/current-warm-after-real-change.log | tee -a "$SUMMARY"

section "3b-rerun. Layer-order prototype warm-cache rebuild after real content change"
/usr/bin/time -p docker build \
  -t cmd-adaptor-sns:t33-layer-order-warm-after-real-change \
  -f "$PROTO_DOCKERFILE" \
  "$MODULE_DIR/" 2>&1 | tee ${RESULTS_DIR}/layer-order-warm-after-real-change.log
PROTO_TIME=$(grep -E '^real' ${RESULTS_DIR}/layer-order-warm-after-real-change.log | tail -1)
record "layer_order_warm_after_real_change_timing=${PROTO_TIME}"
record "layer_order_warm_after_real_change_cached_lines:"
grep -iE 'CACHED' ${RESULTS_DIR}/layer-order-warm-after-real-change.log | tee -a "$SUMMARY"

section "Image sizes"
docker images cmd-adaptor-sns:t33-current-warm-after-real-change | tee -a "$SUMMARY"
docker images cmd-adaptor-sns:t33-layer-order-warm-after-real-change | tee -a "$SUMMARY"

section "Interpretation guide (fill in manually)"
record "If current_* shows the yum/envconsul RUN step as CACHED: unexpected (current Dockerfile has COPY before yum, so invalidating COPY should force yum to rerun too under normal Docker layer semantics). Investigate if seen."
record "If layer_order_* shows the yum/envconsul RUN step as CACHED while current_* does not: this CONFIRMS the layer-order hypothesis."
record "If both show yum/envconsul as CACHED: touch/change still did not propagate as expected - investigate BuildKit cache mode (check for --cache-from or registry cache being used)."

section "Done"
log "Restore the jar to its original state if you need a clean artefact:"
log "  (re-run: mvn -pl ${MODULE_DIR} -am -DskipTests clean package)"
log "Summary: $SUMMARY"
cat "$SUMMARY"