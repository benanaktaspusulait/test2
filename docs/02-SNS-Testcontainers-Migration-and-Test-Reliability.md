# FDP Command Adaptor SNS — Testcontainers Migration & Test Reliability

## Scope

This page describes the Testcontainers integration environment, CI Docker compatibility, business-suite preservation, false-green protections, Kafka polling changes, concurrent aggregate startup, diagnostics and graceful shutdown.

Related pages:

- [CI/CD optimisation overview](00-SNS-CI-CD-Optimisation-Implementation-Report.md)
- [Docker and CI pipeline optimisation](01-SNS-CI-CD-Docker-and-Pipeline-Optimisation.md)
- [Built-image validation and Maven optimisation](03-SNS-Built-Image-Validation-and-Maven-Optimisation.md)
- [Results, engineering learnings and reuse guide](04-SNS-CI-CD-Results-Learnings-and-Reuse.md)

## Architecture

**Where:** `cmd-adaptor-sns-integration-tests/pom.xml`, `IntegrationTest.java`, `SnsSteps.java`, and the `testcontainers` package.

The business suite now owns:

- Redis `5.0.6`;
- ZooKeeper, Kafka and Schema Registry `7.9.7`;
- party, object, location, event and service aggregate containers;
- a shared Testcontainers network;
- required topic creation and Schema Registry register/read verification;
- dynamic application, broker, registry and Redis endpoints;
- a unique topic suffix and run-specific consumer group;
- readiness, diagnostics and deterministic cleanup.

For the Cucumber suite, `CmdAdaptorApplication` starts inside the integration-test JVM through `SpringApplicationBuilder` with `--server.port=0`. Test code injects the dynamically mapped infrastructure endpoints. This removes fixed host-port assumptions and places lifecycle ownership beside the tests.

```text
Redis + ZooKeeper (concurrent)
          |
        Kafka
          |
    Schema Registry
          |
topic creation + registry round trip
          |
in-JVM SNS application
          |
five aggregates (concurrent) + parallel readiness
          |
14 business scenarios
```

> **Impact — Observed system effect:** Recent optimised Build/Test runs were approximately **3m10s–3m16s**. The older Compose steps overlapped and had different scope, so no isolated Testcontainers saving is asserted.

## CI Docker/Testcontainers Compatibility

The integration-test module pins Testcontainers **1.20.4**. Both the business-suite and built-image validation steps use:

```text
DOCKER_HOST=tcp://docker:2375
DOCKER_API_VERSION=1.41
TESTCONTAINERS_HOST_OVERRIDE=docker
TESTCONTAINERS_RYUK_DISABLED=true
```

The Maven test processes also receive the Docker API version through system properties. CI creates authenticated Docker client configuration for the approved registry path before private aggregate images are resolved.

Ryuk is disabled for this DIND CI setup; explicit Java lifecycle ownership, root-scope cleanup and bounded shutdown remain responsible for releasing resources.

> **Impact — Correctness/reliability:** Docker endpoint, API, host mapping, registry authentication and DIND reaper behaviour are aligned so that the suite runs reliably instead of being skipped or failing due to client/daemon incompatibility. No performance saving is attributed to this wiring.

## Business-Scenario Preservation

The current suite contains **seven feature files and 14 business scenarios**. Guardrails require at least seven feature files and at least 14 scenarios.

- `ci-testcontainers-snapshot` requires at least 14 completed scenarios.
- `SnsSteps` increments an atomic counter for each `TestCaseFinished` event and validates it at `TestRunFinished`.
- `TestcontainersSuiteCoverageTest` is a separate JUnit guard, not one of the 14 business scenarios.
- Failsafe uses `failIfNoTests=true` and `failIfNoSpecifiedTests=true`.
- The command-only profile expects its selected `@cmd` scenario.

### False-green protection — representative configuration

```xml
<sns.testcontainers.skip-if-docker-unavailable>false</sns.testcontainers.skip-if-docker-unavailable>
<sns.testcontainers.expected-scenarios>14</sns.testcontainers.expected-scenarios>
...
<failIfNoTests>true</failIfNoTests>
<failIfNoSpecifiedTests>true</failIfNoSpecifiedTests>
```

CI profiles make required Docker availability a hard failure. Required dependency images must resolve, topic creation and Schema Registry checks must succeed, and readiness timeouts fail the suite.

> **Engineering decision:** A faster pipeline is not an improvement if fewer business tests execute.

## Kafka Polling Correctness

**Where:** `cmd-adaptor-sns-integration-tests/src/test/java/uk/gov/ho/dacc/fdp/steps/SnsSteps.java`

### Before

```java
kafkaConsumerRunlogCmd.poll(
    Duration.ofSeconds(POLL_DURATION_MS)
);
```

### After

```java
private static final Duration POLL_DURATION =
        Duration.ofMillis(POLL_DURATION_MS);

kafkaConsumerRunlogCmd.poll(POLL_DURATION);
```

With `POLL_DURATION_MS = 500`, the previous unit represented a potential 500-second upper bound rather than the intended 500 milliseconds. Kafka can return earlier when records are available, so this does not mean every previous call waited 500 seconds.

The final implementation also sets `max.poll.records=10`, stops processing once the required result count is reached, removes duplicate initial consumer construction and retains bounded retry limits.

> **Impact — Correctness with performance consequences:** Intended 500ms semantics were restored and unnecessary polling/consumer work was removed. No isolated CI timing was collected.

## Aggregate Startup and Readiness

### Before — lifecycle shape

```java
for (Container aggregate : aggregates) {
    aggregate.start();
    waitForReadiness(aggregate);
}
```

### After — abridged

```java
Startables.deepStart(Stream.of(
        AGGREGATE_PARTY, AGGREGATE_OBJECT,
        AGGREGATE_LOCATION, AGGREGATE_EVENT,
        AGGREGATE_SERVICE)).join();

aggregates.parallel().forEach(this::waitForReadiness);
```

Redis and ZooKeeper start concurrently. Kafka then starts against ZooKeeper, followed by Schema Registry. Once shared dependencies are ready, the five independent aggregates start together and readiness checks run in parallel.

Each readiness request has a two-second HTTP timeout, polls every 500ms and has a maximum of 240 attempts. Either the profile-specific path or `/actuator/health/readiness` may confirm health; exhaustion fails the suite.

> **Impact — Structural critical-path improvement:** Five independent service starts and readiness checks no longer run serially. No isolated timing was collected.

## Cucumber Output and HTTP Reuse

Verbose Cucumber `pretty` output was removed while summary, HTML reporting and the CI event listener were retained. Readiness checks share an `HttpClient`, use two-second request timeouts and retain the latest failure for diagnostics. Poll-attempt messages are debug-level; business assertion and failure reporting remain.

> **Impact — Structural improvement:** Avoidable formatting, client construction and log volume were reduced without reducing validation. No isolated timing was collected.

## Failure Diagnostics

`TestcontainersFailureDiagnostics` captures container logs when a test fails and registers root-scope cleanup. `SnsTestcontainersEnvironment` can dump Redis, ZooKeeper, Kafka, Schema Registry and aggregate logs on infrastructure or application startup failure. The built-image smoke test reports image-container state and logs when startup, early exit or readiness fails.

The environment closes the application/Kafka Streams, aggregate containers, Schema Registry, Kafka, ZooKeeper and Redis before the shared network. Guards prevent reuse after shutdown.

## Kafka Streams and Application Shutdown

Successful tests previously showed an avoidable shutdown tail while managed Kafka Streams/application threads remained active.

### Final lifecycle — abridged

```java
for (KafkaStreams stream : managedStreams) {
    stream.close(Duration.ofSeconds(30));
}

waitForTerminalStates(managedStreams);
applicationContext.close();
```

The environment retrieves the managed `KafkaStreams` instances from `KafkaStreamConfig`, closes them gracefully with a 30-second allowance, and polls state every 100ms until each is `NOT_RUNNING` or `ERROR`. It then closes the Spring context and remaining infrastructure. Kafka producers and consumers receive bounded five-second close calls.

Reducing a process timeout was intentionally avoided because that could terminate active streams, hide leaks or truncate diagnostics.

> **Impact — Strong observed system effect:** Build/Test was observed around **3m53s** with an approximately **30s** shutdown tail; representative post-fix runs were approximately **3m09s–3m10s**. Only the known **~30s** wait is attributed to this change, not the full 43–44s step difference.

## Implementation Files

| File | Implementation responsibility |
| --- | --- |
| `cmd-adaptor-sns-integration-tests/pom.xml` | Testcontainers version/profiles, CI Docker API properties, scenario expectations and zero-test controls |
| `cmd-adaptor-sns-integration-tests/src/test/java/uk/gov/ho/dacc/fdp/IntegrationTest.java` | Docker prerequisite and Cucumber configuration |
| `cmd-adaptor-sns-integration-tests/src/test/java/uk/gov/ho/dacc/fdp/steps/SnsSteps.java` | Dynamic runtime configuration, scenario accounting, Kafka polling and cleanup |
| `cmd-adaptor-sns-integration-tests/src/test/java/uk/gov/ho/dacc/fdp/testcontainers/SnsTestcontainersEnvironment.java` | Infrastructure/application lifecycle, readiness, diagnostics and shutdown |
| `cmd-adaptor-sns-integration-tests/src/test/java/uk/gov/ho/dacc/fdp/testcontainers/TestcontainersFailureDiagnostics.java` | Failure log capture and root-scope cleanup |
| `cmd-adaptor-sns-integration-tests/src/test/java/uk/gov/ho/dacc/fdp/testcontainers/TestcontainersSuiteCoverageTest.java` | Minimum feature/scenario coverage guard |
