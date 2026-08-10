#!/bin/sh -e

#############################################################################
# WARNING: This file is controlled via RepoSync, any changes made in the
# command adaptor repository will be overwritten by the RepoSync process.
# See https://gitlab.digital.homeoffice.gov.uk/dacc-de/dde-adaptor-reposync
#############################################################################

# Used to run the container as the same user as host with write permission to Downloads folder
export DOCKER_USER="$(id -u):$(id -g)"
DOCKER_COMPOSE_CONFIG_FILE=cmd-adaptor-*-integration-tests/src/test/resources/docker-compose/docker-compose.yml

docker-compose -f $DOCKER_COMPOSE_CONFIG_FILE build kafka-topic-extract
docker-compose -f $DOCKER_COMPOSE_CONFIG_FILE run --rm kafka-topic-extract
