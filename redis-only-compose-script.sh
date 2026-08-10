#!/usr/bin/env bash
set -euo pipefail

COMPOSE_FILE="${COMPOSE_FILE:-cmd-adaptor-sns-integration-tests/src/test/resources/docker-compose/docker-compose.yml}"
RUN_LABEL="${1:-compose-run-2}"
KEY="t43-compose-redis-${RUN_LABEL}"
VALUE="value-${RUN_LABEL}"

cleanup() {
  local cleanup_start cleanup_end

  cleanup_start=$(date +%s%N)
  docker compose -f "$COMPOSE_FILE" down --remove-orphans
  cleanup_end=$(date +%s%N)

  awk "BEGIN {print \"compose_cleanup_seconds=\" (($cleanup_end-$cleanup_start)/1000000000)}"
}

trap cleanup EXIT

docker compose -f "$COMPOSE_FILE" down --remove-orphans

START=$(date +%s%N)
docker compose -f "$COMPOSE_FILE" up -d redis

until [ "$(docker compose -f "$COMPOSE_FILE" exec -T redis redis-cli ping 2>/dev/null)" = "PONG" ]; do
  sleep 0.2
done

END=$(date +%s%N)

awk "BEGIN {print \"compose_startup_to_ready_seconds=\" (($END-$START)/1000000000)}"

PING_RESULT=$(docker compose -f "$COMPOSE_FILE" exec -T redis redis-cli ping)
SET_RESULT=$(docker compose -f "$COMPOSE_FILE" exec -T redis redis-cli set "$KEY" "$VALUE")
GET_RESULT=$(docker compose -f "$COMPOSE_FILE" exec -T redis redis-cli get "$KEY")
DEL_RESULT=$(docker compose -f "$COMPOSE_FILE" exec -T redis redis-cli del "$KEY")

printf 'PING=%s\n' "$PING_RESULT"
printf 'SET=%s\n' "$SET_RESULT"
printf 'GET=%s\n' "$GET_RESULT"
printf 'DEL=%s\n' "$DEL_RESULT"

if [ "$PING_RESULT" != "PONG" ] || [ "$SET_RESULT" != "OK" ] || [ "$GET_RESULT" != "$VALUE" ] || [ "$DEL_RESULT" != "1" ]; then
  echo "Redis smoke check failed for ${RUN_LABEL}" >&2
  exit 1
fi