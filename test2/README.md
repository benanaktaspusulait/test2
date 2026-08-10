# Fast Data Pipeline (FDP) Command Adaptor - SNS


This is a maven multi-module project consisting of the following modules:

1. ```cmd-adaptor-sns-common```:
   * Contains the Dnb Landing Avro Schema and generates the Java model from it
   * Common Java interfaces and Classes between the ```cmd-adaptor-sns``` and ```cmd-adaptor-sns-integration-tests``` projects
2. ```cmd-adaptor-sns```:
   * Spring Boot application for the Bitd Command Adaptor
   * Unit tests using the Confluent ```TopologyTestDriver```
3. [```cmd-adaptor-sns-integration-tests```](cmd-adaptor-sns-integration-tests/README.md)
   * Full containerised BDD Cucumber Feature File driven E2E tests
   * Supports both docker-compose and Testcontainers execution paths

![Command Adaptor Pipeline](./cmd-adaptor-pipeline.png)

## Stream Topology
![Kafka Stream Topology](./topology.png)

## Build

```mvn clean install```

This will:

 - build all modules
 - execute unit tests


To run the e2e tests against the local stack setup actions will be required - see [cmd-adaptor-pnr-integration-tests](./cmd-adaptor-pnr-integration-tests/README.md)

There are two Maven profiles for the legacy docker-compose integration path:

Profile Name | Description |
------------ | ----------- |
`local-int-cmd` | Starts containers, but not the Aker aggregators. |
`local-int-snapshot` | Starts containers, including the Aker aggregators. |

For example to run the integration suite against the command adaptor with docker-compose:

```
mvn -Plocal-int-cmd clean install
```

To run the full test suite including against the aggregators, use:

```
mvn -Plocal-int-snapshot clean install
```

## Testcontainers (step-by-step)

For local development, prefer the Testcontainers path because it does not rely
on the docker-compose lifecycle in this module.

1) Run Testcontainers smoke tests (Redis + Kafka + Schema Registry wiring):

```bash
mvn -pl cmd-adaptor-sns-integration-tests -am -Plocal-testcontainers -Dtest='*RedisTest,*SmokeTest' -Dsurefire.failIfNoSpecifiedTests=false test
```

2) Run command-path integration tests with Testcontainers:

```bash
mvn -pl cmd-adaptor-sns-integration-tests -am clean verify -Plocal-testcontainers
```

3) Run full snapshot integration tests (includes downstream aggregates in
Testcontainers):

```bash
mvn -pl cmd-adaptor-sns-integration-tests -am clean verify -Plocal-testcontainers-snapshot
```

For CI-style profile names, use `-Pci-testcontainers-cmd` and
`-Pci-testcontainers-snapshot` instead.

**Important note to integration test developers**: When developing integration
tests, it is best to leave the docker containers up to decrease the build-test
cycle. To do this use the following command:

```
mvn integration-test -Plocal-int-snapshot
```

To restart the containers (clearing Kafka topics down):

```
mvn clean integration-test -Plocal-int-snapshot
```
