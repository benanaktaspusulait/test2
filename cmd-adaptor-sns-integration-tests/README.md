# Command Adaptor Integration Tests

This module supports both docker-compose and Testcontainers. For day-to-day
local runs, use Testcontainers first.

## Testcontainers (step-by-step)

1) Run command-path Cucumber integration tests:

```bash
mvn -pl cmd-adaptor-sns-integration-tests -am clean verify -Plocal-testcontainers
```

2) Run snapshot/full integration tests with downstream aggregates:

```bash
mvn -pl cmd-adaptor-sns-integration-tests -am clean verify -Plocal-testcontainers-snapshot
```

For CI-style names, the same runs are available as
`-Pci-testcontainers-cmd` and `-Pci-testcontainers-snapshot`.

These profiles require a reachable Docker daemon with a supported Docker API.
If Docker is unavailable, the Testcontainers Cucumber suite is skipped by
default instead of failing during bootstrap. To make Docker availability a hard
failure, add:

```bash
-Dsns.testcontainers.skip-if-docker-unavailable=false
```

## Snapshot profile prerequisites

To run snapshot tests with downstream aggregate images, connect to ACP VPN and
authenticate to JFrog Docker registry. In the login example below, `JFROG_TOKEN`
is set in your shell environment:

```shell
docker login -u ben.dalling@digital.homeoffice.gov.uk -p "${JFROG_TOKEN}" \
             docker.digital.homeoffice.gov.uk
```


## Legacy docker-compose path

By default, `post-integration-test` tears down docker-compose infrastructure.
To keep compose containers running during iteration, use:

```shell
mvn integration-test -Plocal-int-snapshot
```

When containers are running, you can connect to:

* Confluent Control Center - http://localhost:9021/clusters


To run Maven without integration tests:

```shell
mvn clean install
```

However, please run the full test suite *before* pushing to CI to ensure that
the full suite passes.
