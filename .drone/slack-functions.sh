#!/bin/bash

#
# Author: Anthony McKale
# Date: 21/02/2024
# Purpose: support functions for sending slack messages
# Version: 1.1
# 1.1 - add alarm on failure
#
# see dacc-aws/devops-manifest/drone-templates for latest version
#
# Slack Ref: https://api.slack.com/reference/surfaces/formatting
#

send_slack_header_text() {
   # Usage: send_slack_text <channel> <header> <body> <token>
  CHANNEL=$1
  HEADER=$2
  BODY=$3
  TOKEN=$4
  if [ "$TOKEN" = "" ]; then
    TOKEN=$FDP_APP_CHECKS_SLACK_TOKEN
  fi
  SLACK_APP_URL="https://slack.com/api/chat.postMessage"

  PAYLOAD="{
  \"channel\": \"${CHANNEL}\",
  \"blocks\": [
      {
        \"type\": \"header\",
        \"text\": {
          \"type\": \"plain_text\",
          \"text\": \"${HEADER}\",
          \"emoji\": true
        }
      },
      {
        \"type\": \"context\",
        \"elements\": [
          {
            \"type\": \"plain_text\",
            \"text\": \"${BODY}\",
            \"emoji\": true
          }
        ]
      }
    ]
}"
  curl -X POST -H "Authorization: Bearer ${TOKEN}" -H "Content-type: application/json; charset=utf-8" --data "$PAYLOAD" $SLACK_APP_URL
}

send_slack_text() {
   # Usage: send_slack_text <channel> <text> <token>
  CHANNEL=$1
  TEXT=$2
  TOKEN=$3
  if [ "$TOKEN" = "" ]; then
    TOKEN=$FDP_APP_CHECKS_SLACK_TOKEN
  fi
  SLACK_APP_URL="https://slack.com/api/chat.postMessage"

  PAYLOAD="{
  \"channel\": \"${CHANNEL}\",
  \"text\": \"${TEXT}\"
}"
  curl -X POST -H "Authorization: Bearer ${TOKEN}" -H "Content-type: application/json; charset=utf-8" --data "$PAYLOAD" $SLACK_APP_URL
}

send_slack_success() {
  # Usage: send_slack_success <token>
  SLACK_APP_TOKEN=$1
  SLACK_CHANNEL="fdp-alert-cicd"
  SLACK_TEXT=":large_green_circle: <${DRONE_REPO_LINK}|Drone Pipeline SUCCESS ${DRONE_REPO}> : <${DRONE_BUILD_LINK}|${DRONE_BUILD_NUMBER}> (@${DRONE_COMMIT_AUTHOR})"
  send_slack_text "${SLACK_CHANNEL}" "${SLACK_TEXT}" "${SLACK_APP_TOKEN}"
}

send_slack_failure() {
  # Usage: send_slack_failure <token>
  SLACK_APP_TOKEN=$1
  SLACK_CHANNEL="fdp-alert-cicd"
  SLACK_ALARM_CHANNEL="fdp-alarm-nonprod"
  SLACK_TEXT=":large_red_square: <${DRONE_REPO_LINK}|Drone Pipeline FAILURE ${DRONE_REPO}> : <${DRONE_BUILD_LINK}|${DRONE_BUILD_NUMBER}> (@${DRONE_COMMIT_AUTHOR})"
  send_slack_text "${SLACK_CHANNEL}" "${SLACK_TEXT}" "${SLACK_APP_TOKEN}"
  send_slack_text "${SLACK_CHANNEL}" "${SLACK_ALARM_CHANNEL}" "${SLACK_APP_TOKEN}"
}