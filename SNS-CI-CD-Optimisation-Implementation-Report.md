# FDP Command Adaptor SNS — CI/CD Optimisation Implementation Report

## 1. Executive Summary

The `fdp-cmd-adaptor-sns` pilot replaced a Docker Compose-heavy CI integration-test path with a test-owned Testcontainers environment. The previous pipeline split Kafka and Redis, downstream aggregators, Maven compilation, command-adaptor startup, readiness checks and Cucumber execution across several Drone steps and helper containers. This created orchestration overhead and a long dependency chain around the integration suite.

The final implementation consolidates compilation and business integration testing into **Build and Test with Testcontainers**. Redis, ZooKeeper, Kafka, Schema Registry and the five downstream aggregate services are controlled from Java test code, while the SNS application runs in the integration-test JVM. The exact Docker image is then built and validated separately before vulnerability scanning. This distinction preserves both business-scenario coverage and deployable-artifact confidence.

Docker build context, layer ordering and registry-backed BuildKit caching were also changed. Duplicate Maven work was reduced, adaptor metadata extraction was collapsed from four Maven evaluations to one, and Trivy database preparation was moved onto a parallel pipeline path so that it does not normally extend the final scan's critical-path contribution.

> **Measured:** The successful CI baseline averaged **13m35s** across ten runs. Two measured optimised runs completed in **4m57s** and **4m44s**.
>
> **Best observed comparison:** Comparing the historical baseline average with the fastest observed optimised run gives an **8m51s** reduction, approximately **65.2%**, or approximately **2.87x** faster. The **4m44s** result is the best observed result, not a guaranteed duration for subsequent runs.

The optimisation did not remove the Cucumber business suite, built-image runtime validation or Trivy scanning. Explicit Docker-availability, zero-test, feature/scenario-count, readiness and failure-diagnostic protections were added or strengthened so that a shorter run cannot be achieved by silently doing less validation.

| Metric | Before | After |
| --- | ---: | ---: |
| Successful CI average baseline | 13:35 | — |
| Measured optimised run 1 | — | 4:57 |
| Measured optimised run 2 | — | 4:44 |
| Best measured reduction | — | ~65.2% |
| Best measured speed-up | — | ~2.87x |

## 2. Changeset Overview

The implementation consists of coordinated changes to the CI dependency graph, Docker build caching, Maven execution, Testcontainers lifecycle management, test-completeness protections, runtime-image verification and scanner preparation. Section 16 lists the files that directly implement these changes.

| Area | Main implementation files | Purpose |
| --- | --- | --- |
| Docker build | `cmd-adaptor-sns/.dockerignore`, `cmd-adaptor-sns/Dockerfile` | Improve context handling and stable-layer cache reuse |
| CI pipeline | `.drone.star` | Simplify execution flow, overlap independent work and reduce the critical path |
| Integration testing | Integration-test POM and Testcontainers classes | Move infrastructure lifecycle and diagnostics into test code |
| Test correctness | `IntegrationTest.java`, `SnsSteps.java`, suite coverage test | Prevent incomplete execution from appearing successful |
| Runtime validation | `BuiltImageRuntimeIntegrationTest.java` | Validate the actual packaged image after business tests |
| Metadata | `bin/adaptor-info.sh` | Reduce repeated Maven property-evaluation work |

### Implementation Summary

| Change | Previous behaviour | Final implementation | Why | Observed result |
| --- | --- | --- | --- | --- |
| `.dockerignore` | The Docker context included the module's wider file set | Only the packaged application JAR and OpenTelemetry agent are retained from `target` | Remove irrelevant context and cache-key inputs | BuildKit context observation reduced from approximately 191.27 MB to 189 B in the controlled measurement |
| Docker layer ordering | Application artefacts preceded expensive OS and tooling setup | Stable OS, envconsul and user setup precedes volatile artefact copies | Preserve expensive stable layers when application content changes | Same-daemon warm-cache rebuild after a real JAR change reduced from 75.82–77.90s to 4.62–5.08s |
| BuildKit/registry cache | The application-image build had no explicit registry-backed cache policy | Reusable shared cache plus isolated writes, with an inline-cache fallback | Reuse stable image layers across clean CI workers without allowing isolated work to overwrite the shared cache | Default-builder build-path observations were approximately 41–42s and approximately 18–20s faster than the custom builder path; full-CI contribution was not isolated |
| Testcontainers integration | Compose steps and helper containers split infrastructure and test lifecycle across CI | Java test code owns Redis, ZooKeeper, Kafka, Schema Registry, five aggregates and the in-JVM SNS application | Reduce orchestration transitions and keep lifecycle beside the tests | No isolated timing measured; this contributed to the end-to-end reduction |
| False-green protection | Docker unavailability or missing test discovery could allow incomplete execution to appear successful | Mandatory Docker checks, Maven zero-test controls, expected feature/scenario counts and runtime readiness assertions fail explicitly | Ensure speed is not achieved by silently running less validation | Seven feature files and 14 scenarios are enforced. No isolated timing measured |
| Kafka polling | A millisecond-named value was applied with seconds semantics, and polling could continue after success | Millisecond duration semantics and early exit after expected records | Correct excessive waits and stop completed polling promptly | Correctness fix with performance consequences. No isolated timing measured |
| Aggregate startup/readiness | Aggregate containers and readiness checks were largely serial | Concurrent container start and parallel readiness checks with bounded polling | Remove avoidable sequential waiting while preserving health checks | No isolated timing measured |
| Kafka Streams shutdown | Test teardown lacked explicit bounded stream lifecycle handling | Streams close gracefully with a 30-second allowance and state polling before application-context closure | Prevent leaked lifecycle state and nondeterministic teardown | Approximately 30s of observed shutdown waiting was removed; the complete Build/Test difference is not attributed to this change |
| Exact built-image validation | In-process business tests did not prove the packaged image could start | A focused smoke test starts the exact image produced by CI and requires readiness | Cover packaging, entrypoint and runtime configuration separately from business scenarios | Required runtime coverage retained; no standalone performance claim |
| Maven runtime reuse | Runtime validation could rebuild upstream modules | Verified reactor artefacts are installed once and reused by a focused module-only invocation | Avoid recompiling work already proven earlier in the pipeline | Runtime validation reduced from approximately 1m06s to approximately 30–34s, a 32–36s step reduction |
| `adaptor-info` | Four Maven evaluations retrieved four reported properties | One non-recursive Maven evaluation returns all four values | Reduce repeated Maven startup and model processing | Representative observations improved from approximately 15–21s to approximately 11s; not treated as deterministic |
| Trivy DB overlap | Database preparation occurred inside the final 40–49s scan step | Vulnerability and Java databases are prepared earlier on an independent path; the final scan reuses them | Move download work off the final dependency path without weakening scanning | Preparation observed at 28–31s and final scan/reporting at 14–15s |

### Measured Impact by Optimisation

The measurements below distinguish independently comparable timings from system-level observations and implementation effects without isolated benchmarks. Individual rows must not be added together: pipeline steps overlap, some changes affect the same dependency path, and the measurements were collected at different scopes and stages.

| Optimisation | Before | After | Observed impact | Evidence |
| --- | ---: | ---: | --- | --- |
| Docker build context | Approximately 191.27 MB | Controlled BuildKit/content-store observation: 189 B | Docker input was substantially narrowed. Cold-build duration remained broadly similar and the image remained approximately 906 MB; this is not a universal CI transfer saving | Direct measurement — controlled Docker |
| Docker layer ordering | Approximately 75.82–77.90s | Approximately 4.62–5.08s | Approximately 15–16x faster for the controlled same-daemon warm-cache rebuild after a real JAR change; not a cold-build or full-CI saving | Direct measurement — controlled Docker |
| BuildKit/registry cache | Custom docker-container builder path used in the comparison | Default-builder path approximately 41–42s with reusable stable layers | Approximately 18–20s faster than the custom builder path in those build-path measurements; full-CI contribution was not isolated | Observed system effect — partial build-path measurement |
| Testcontainers architecture | Command Adaptor 11:01; Integration Tests 9:43; Kafka & Redis 2:18; Aggregators 0:29; Pre-Integration 0:06 | Consolidated Build/Test approximately 3:10–3:16 in recent optimised runs | Major architectural contributor, but the old and new values are not directly subtractable because steps overlapped and their scopes differ | Observed system effect — system-level comparison |
| Kafka polling unit correction | `POLL_DURATION_MS = 500` passed to `Duration.ofSeconds(...)` | `Duration.ofMillis(500)` | Restores the intended 500ms semantics and removes an incorrect potential long-poll bound; a poll could still return earlier when data was available | Correctness improvement — performance consequences, no isolated CI timing |
| Polling and consumer improvements | One-record batches, continued batch processing after the required count, and duplicate initial consumer construction | `max.poll.records=10`, early exit after the required records, one consumer per topic and retained bounded polling | Reduces unnecessary consumer construction and poll processing | Structural improvement — no isolated timing |
| Aggregate startup | Independent aggregate lifecycle work was serialised | Five aggregates start concurrently after shared prerequisites; readiness checks also run in parallel | Removes unnecessary serialisation from the startup path | Structural improvement — no isolated timing |
| Kafka Streams shutdown | Build/Test approximately 3:53 with an observed shutdown tail of approximately 30s | Representative post-fix Build/Test approximately 3:09–3:10 | Approximately 30s of known shutdown waiting was removed. The complete 43–44s step difference is not attributed to this change because normal execution variation also contributes | Observed system effect — strong before/after observation |
| Built-image Maven reuse | Runtime validation approximately 1:06 | Approximately 0:30–0:34 | Approximately 32–36s reduction in the step while retaining exact built-image runtime validation | Direct measurement — CI step |
| Adaptor information | Representative runs approximately 15–21s | Representative run approximately 11s | Approximately 4–10s visible-step improvement, with earlier overlap also enabled; not all visible-step improvement translates directly to end-to-end saving | Observed system effect — CI step |
| Trivy critical-path move | Final Trivy step approximately 40–49s with DB preparation on the final path | Prepare Trivy DB approximately 28–31s in parallel; final scan approximately 14–15s | Approximately 25–35s removed from the final Trivy critical-path contribution; DB preparation itself was not made faster | Direct measurement — CI critical path |
| Full CI | Successful baseline average 13:35 across ten runs | Measured optimised runs 4:57 and 4:44 | Best observed comparison: 8:51, approximately 65.2%, or approximately 2.87x faster | Direct measurement — end-to-end result |

**Evidence classification**

- **Direct measurement:** A comparable before/after timing exists for the specific change.
- **Observed system effect:** A before/after system or step difference exists, but multiple factors may contribute.
- **Structural improvement:** The dependency or work reduction is clear from the implementation, but no isolated timing was collected.
- **Correctness improvement:** The change fixes incorrect behaviour and may improve runtime, but performance is not presented as its primary measured result.

The largest independently visible improvements were the runtime-validation Maven reuse, moving Trivy preparation off the final critical path, Docker layer-cache behaviour in the controlled Docker test and removal of the known Kafka Streams shutdown tail. Each has a clear evidence boundary in the table.

The largest architectural change was replacing the Compose-heavy integration orchestration with the Testcontainers-based Build/Test model. It consolidated several lifecycle stages and removed orchestration boundaries, but no invented duration is assigned to that migration because the old steps overlapped and did not have one-to-one scope with the final step.

The **13:35 baseline average to 4:57/4:44 measured optimised runs** is the cumulative end-to-end outcome of the complete solution. It is not the arithmetic sum of the individual rows: measurements overlap, some affect the same critical path, controlled Docker observations are not CI timings, and infrastructure or network conditions vary.

## 3. Docker Build Changes

### Change: Focused Docker build context

**Where**

`cmd-adaptor-sns/.dockerignore`

**Previous behaviour**

The module had no `.dockerignore`. The measured original context was approximately **191.27 MB**, even though the Dockerfile consumes only the packaged application JAR and OpenTelemetry Java agent from `target`.

**Change made**

The new ignore file excludes source, Maven wrapper/build metadata, IDE files, VCS files, logs and temporary directories. It excludes `target/**` by default, then explicitly includes:

```text
!target/cmd-adaptor-sns-exec.jar
!target/dependencies/opentelemetry-javaagent.jar
```

**Why**

Files that cannot affect the runtime image should not enter Docker's build context or cache-key calculation. Reducing that input makes the build more focused and avoids unrelated source or local-file changes invalidating Docker work.

**How it works**

Docker applies `.dockerignore` before transmitting the context to the builder. Negated rules retain the two runtime artefacts required by the `COPY` instructions.

**Validation / safety**

The executable JAR and OpenTelemetry agent remain present. No runtime command, user, ownership or application behaviour is removed.

**Measured result**

> **Controlled Docker measurement:** BuildKit reported a **189 B** context observation after the ignore rules. This is a content-store observation from the controlled experiment, not a universal CI network-transfer size.

> **Impact — Direct measurement:** Docker input was substantially narrowed from approximately **191.27 MB** to a **189 B** controlled BuildKit/content-store observation. No material image-size or cold-build reduction is attributed to this change.

### Change: Stable Docker layers before volatile artefacts

**Where**

`cmd-adaptor-sns/Dockerfile`

**Previous behaviour**

The application JAR and OpenTelemetry agent were copied before the expensive `yum`/system-package and envconsul setup. A JAR content change therefore invalidated the following stable setup layer.

**Change made**

The final ordering is:

```text
base image
  -> OS packages, updates, envconsul and user creation
  -> application JAR and OpenTelemetry agent
  -> runtime permissions/ownership
  -> non-root runtime command
```

**Why**

The application JAR changes frequently; OS packages and bootstrap tooling change comparatively infrequently. Docker reuses a layer only while its instruction and all preceding layers remain valid. Moving volatile `COPY` operations after stable expensive setup retains the system layer across application rebuilds.

**How it works**

The stable `RUN` completes before Docker considers the JAR content. A real JAR change now invalidates only the artefact and subsequent permission layers, rather than the OS/tooling work.

**Validation / safety**

The final image remains based on Amazon Corretto 17, creates and runs as `fdpuser`, installs the required system packages, includes the JAR and OpenTelemetry agent, and retains the Java runtime command. Envconsul is downloaded as version `0.13.4` with redirect/error handling and a pinned SHA-256 verification before extraction.

**Measured result**

> **CONTROLLED SAME-DAEMON WARM-CACHE EXPERIMENT:** After a real JAR content change, the previous ordering took approximately **75.82–77.90s**; the optimised ordering took approximately **4.62–5.08s**. This demonstrates cache-invalidation behaviour. It is neither a cold-build result nor an isolated CI-pipeline saving.

Additional verified Docker baseline observations were: image size **906 MB**, cold build **1m17.855s**, warm no-change build **0m0.851s**, application JAR approximately **166 MB before packaging / 173 MB in image history**, OpenTelemetry agent approximately **18 MB**, system/yum layer approximately **249 MB**, and yum-related cold work approximately **75.1s**.

> **Impact — Direct measurement:** The controlled same-daemon warm-cache rebuild after a real JAR change was approximately **15–16x faster**, from **75.82–77.90s** to **4.62–5.08s**. This is not a cold-build or full-CI saving.

### Change: BuildKit registry cache reuse and write isolation

**Where**

`.drone.star`, step `Build Command Adaptor Image`

**Previous behaviour**

The previous CI path used `docker-compose ... up --build command-adaptor`; the final pipeline did not have an explicit registry-backed cache policy for the application image build.

**Change made**

The final step constructs a reusable shared cache reference and an isolated cache reference for the current development stream. The primary delivery stream reads and writes the shared cache with `mode=max`. Other work reads both the shared and isolated caches but writes only to its isolated cache. If buildx is unavailable, an inline-cache fallback pulls the applicable images, builds with `BUILDKIT_INLINE_CACHE=1`, then publishes the appropriate cache tag.

**Why**

Independent development work can reuse stable layers from the shared cache without overwriting it. Isolated output also preserves reuse across repeated runs for the same development stream.

**Validation / safety**

The exact output is still loaded and tagged as `docker-compose-command-adaptor:latest`, and `docker image inspect` must succeed. Cache misses affect performance, not correctness. No isolated CI timing was collected for registry caching alone.

In the build-path comparison, the default-builder path completed in approximately **41–42s** and was approximately **18–20s faster** than the custom docker-container builder path. This measures those build strategies, not the cache's complete contribution to end-to-end CI.

> **Impact — Observed system effect:** The measured build path was approximately **18–20s faster** in that comparison. Registry-cache contribution to the complete pipeline was not isolated.

## 4. CI Pipeline Architecture Change

### Previous execution model

The previous `.drone.star` used separate steps for infrastructure and test orchestration:

- `Kafka & Redis` installed Docker Compose and started/waited for shared infrastructure;
- `Aggregators` started downstream services;
- `mvn clean install` built the reactor and also evaluated aggregator metadata;
- detached `Command Adaptor` used Compose to build and start the SUT;
- `Pre-Integration Tests` ran preparation scripts;
- `Integration Tests` repeated readiness operations and started a dedicated integration-test container;
- `Scan with Trivy` ran only after integration testing.

```text
Retrieve secrets
      |
Wait for Docker
      |
      +---- Extract metadata ---- Maven clean install --------+
      |                                                       |
      +---- Kafka & Redis ---- Aggregators --------------------+--> Pre-Integration
      |                                                       |          |
      +---------------------- Command Adaptor (detached) ------+     Integration Tests
                                                                         |
                                                                       Trivy
```

This architecture made Docker Compose and helper containers responsible for lifecycle across multiple Drone steps. The measured baseline visible averages were substantial: Command Adaptor 11:01, Integration Tests 09:43, Kafka & Redis 02:18, Maven build 01:24, Aggregators 00:29, Pre-Integration 00:06 and Trivy 00:44.

> These Drone steps overlapped. Their durations must not be added; end-to-end CI time is determined by the longest dependency path.

### Final execution model

The final CI uses the following exact step names and dependencies:

```text
Platform setup / RepoSync Version
                 |
   Retrieve Artifactory Secrets
       |              |                  |
       |              |                  +--> Prepare Trivy DB -----------+
       |              |                                                       |
       |              +--> Extract Adaptor Information --+                    |
       |                                                   |                    |
       +--> Wait for Docker -------------------------------+                    |
                                                           |                    |
                                         Build and Test with Testcontainers     |
                                               |                 |              |
                                               |                 +--> Sonar*    |
                                               v                                |
                                    Build Command Adaptor Image                 |
                                               |                                |
                                    Validate Built Image Runtime                |
                                               |                                |
                                               +--------------+-----------------+
                                                              |
                                                       Scan with Trivy
                                                              |
                                                      success/failure message

* Sonar runs only for the configured delivery event and is not a dependency of Trivy.
```

**Work removed or consolidated**

- CI no longer has separate `Kafka & Redis`, `Aggregators`, detached `Command Adaptor`, `Pre-Integration Tests` and `Integration Tests` steps.
- Test infrastructure, the in-JVM SUT and Cucumber execution are consolidated into `Build and Test with Testcontainers`.
- The application image is built once after that reactor succeeds, then validated directly.

**Work that overlaps**

- `Wait for Docker`, `Extract Adaptor Information` and `Prepare Trivy DB` all begin after secrets retrieval.
- Trivy database preparation can overlap Docker readiness, Maven/test work, image build and runtime validation.
- `Extract Adaptor Information` no longer waits for Docker.

**Work that remains sequential**

- Build/Test must succeed before the Docker image is built.
- The image must exist before its runtime smoke test.
- Runtime validation and Trivy DB preparation must both complete before the final scan.

This graph targets critical-path latency while retaining necessary correctness gates.

> **Impact — Observed system effect:** The dependency graph overlaps independent work and removes orchestration stages from the final path. Its contribution is represented by the end-to-end result; no isolated pipeline-architecture timing was collected.

## 5. Testcontainers Migration

**Where**

- `cmd-adaptor-sns-integration-tests/pom.xml`
- `cmd-adaptor-sns-integration-tests/src/test/java/uk/gov/ho/dacc/fdp/IntegrationTest.java`
- `cmd-adaptor-sns-integration-tests/src/test/java/uk/gov/ho/dacc/fdp/steps/SnsSteps.java`
- `cmd-adaptor-sns-integration-tests/src/test/java/uk/gov/ho/dacc/fdp/testcontainers/SnsTestcontainersEnvironment.java`
- supporting tests and documentation in the same module

**Previous behaviour**

Maven's Docker Compose plugin and Drone steps jointly started dependency services, downstream aggregators, the application container and an integration-test container. Fixed Compose service names/ports and external readiness containers coupled test execution to shell and pipeline orchestration.

**Change made**

New Maven profiles select command-only, full snapshot and built-image Testcontainers modes. In the main CI snapshot profile, Java test code owns:

- Redis 5.0.6;
- ZooKeeper 7.9.7;
- Kafka 7.9.7;
- Schema Registry 7.9.7;
- aggregate-party, aggregate-object, aggregate-location, aggregate-event and aggregate-service;
- a shared Testcontainers network;
- topic creation, readiness, diagnostics and shutdown.

For the main Cucumber Testcontainers suite, `CmdAdaptorApplication` is launched **inside the integration-test JVM** using `SpringApplicationBuilder` and `--server.port=0`. It is not the CI-built Docker image. Test code injects dynamically mapped Redis, Kafka, Schema Registry and application endpoints.

**Why**

The infrastructure definition and lifecycle now sit beside the tests that require it. This removes several external orchestration boundaries, avoids fixed host-port assumptions and gives the test suite direct ownership of startup failures and cleanup.

**How it works**

1. The Cucumber class rule checks Docker when Testcontainers is enabled.
2. `SnsSteps` defers runtime setup until Cucumber's `TestRunStarted` event.
3. `SnsTestcontainersEnvironment` verifies required dependency images can be resolved.
4. Redis and ZooKeeper start concurrently; Kafka then starts against ZooKeeper, followed by Schema Registry.
5. Required SNS/matching/runlog topics are explicitly created and Schema Registry is exercised with a register/read round trip.
6. The application starts in the JVM on a dynamic port with Testcontainers endpoints and a unique topic suffix.
7. Snapshot execution starts the five downstream aggregates on the shared network and waits for readiness.
8. Cucumber consumers use the generated topic suffix and an isolated run-specific consumer group.

**Correctness protections**

- Testcontainers is enabled only through explicit Maven profiles; the legacy Compose profiles remain available for compatibility.
- CI profiles make Docker unavailability a hard failure.
- The full snapshot profile expects at least 14 completed scenarios.
- Required topics and Schema Registry operations fail the suite on error.
- Aggregate and application readiness are bounded and fail rather than silently continuing.
- The exact CI-built image receives a separate runtime smoke test.

**Result**

The architectural consolidation is a contributor to the full-pipeline improvement. No isolated number was collected for Testcontainers migration alone; Testcontainers should not be assumed to be faster in every repository without measurement.

> **Impact — Observed system effect:** The final Build/Test step was approximately **3m10s–3m16s** in recent optimised runs. This is a major architectural contributor, but it must not be directly subtracted from the old overlapping steps because scope and orchestration changed.

## 6. Cucumber and Business-Scenario Preservation

The final snapshot suite contains **seven feature files and 14 scenarios**. The Maven profile `ci-testcontainers-snapshot` sets `sns.testcontainers.expected-scenarios` to `14`; the command-only profile expects one selected `@cmd` scenario.

`SnsSteps` increments an atomic counter for every `TestCaseFinished` event. At `TestRunFinished`, after client and environment cleanup, it throws if the completed count is below the configured expectation. Separately, `TestcontainersSuiteCoverageTest` scans feature files and asserts at least seven feature files and 14 scenarios. Failsafe is configured with `failIfNoTests=true` and `failIfNoSpecifiedTests=true`.

> **Engineering decision:** A faster pipeline is not an improvement if fewer business tests execute.

The runner continues to use the existing Cucumber feature directory and glue. Tag selection moved into Maven's `cucumber.filter.tags`, making command-only and full-snapshot selection explicit per profile rather than a fixed runner annotation.

Testcontainers requires runtime-derived values, so topic names are now constructed after the generated suffix is available. The environment uses a UUID-derived topic suffix and a separate run ID; Kafka consumers use `e2e-testing-<run-id>` in Testcontainers mode. This reduces cross-run collisions while preserving the same business assertions.

Producer and consumer lifecycle is explicitly closed on test-run completion with bounded five-second client close durations. On a failed Cucumber run, infrastructure logs are dumped before shutdown.

> **Impact — Correctness improvement:** Seven feature files and 14 scenarios are enforced, alongside zero-test and completed-scenario checks. No performance saving is attributed to these protections.

## 7. Testcontainers Failure Diagnostics

**Where**

- `TestcontainersFailureDiagnostics.java`
- `SnsTestcontainersEnvironment.java`
- `BuiltImageRuntimeIntegrationTest.java`
- Cucumber finish hooks in `SnsSteps.java`

When infrastructure responsibility moved from Compose scripts into Java, failure evidence also needed to move. The environment can dump logs for Redis, ZooKeeper, Kafka, Schema Registry and, when enabled, all five aggregates. It invokes diagnostics on infrastructure, Redis or application startup failure. Cucumber invokes diagnostics when the overall run fails.

The JUnit 5 `TestcontainersFailureDiagnostics` extension reports container logs on test failure and installs a root-store `CloseableResource` that owns final environment shutdown. The built-image smoke test adds image-container state and logs when startup, early exit or readiness fails.

Cleanup closes the application/Kafka Streams, aggregate containers, Schema Registry, Kafka, ZooKeeper and Redis before closing the shared network. Guards prevent reuse after network shutdown. These logs and deterministic ownership matter in ephemeral CI, where the failing containers otherwise disappear with the job.

> **Impact — Structural improvement:** Failure evidence and cleanup now follow the test-owned lifecycle. No isolated timing was collected.

## 8. Docker Availability and False-Green Protection

The final runner calls `SnsTestcontainersEnvironment.assumeDockerAvailableIfEnabled()` through a JUnit class rule. Local profiles retain the option to skip when Docker is unavailable, which supports development environments that do not intend to run Testcontainers.

CI profiles explicitly set:

```xml
<sns.testcontainers.skip-if-docker-unavailable>false</sns.testcontainers.skip-if-docker-unavailable>
```

If Docker is unavailable, the environment therefore throws instead of using a JUnit assumption. An additional Drone guard rejects a contradictory configuration in which expected scenarios are greater than zero while CI is configured to skip on Docker failure.

The controls address separate false-green modes:

| Risk | Protection |
| --- | --- |
| Docker absent, Cucumber skipped | CI profiles disable skip-on-unavailable |
| Wrong profile expects tests but none are discovered | Failsafe `failIfNoTests` and `failIfNoSpecifiedTests` |
| Cucumber starts but executes too few scenarios | `COMPLETED_SCENARIOS` compared with profile expectation |
| Feature/scenario assets are accidentally removed | `TestcontainersSuiteCoverageTest` minimums |
| Required dependency image is unavailable | Pre-start image-resolution verification |

> **Impact — Correctness improvement:** CI fails when Docker is required but unavailable, when no expected tests are discovered or when business-suite coverage falls below the enforced minimum. No performance saving is attributed to these controls.

## 9. Kafka Polling and Test-Execution Fixes

**Duration correctness**

The pre-change runlog poll called `Duration.ofSeconds(POLL_DURATION_MS)` while `POLL_DURATION_MS` was `500`. That represented 500 seconds, not 500 milliseconds. The final code constructs and reuses `Duration.ofMillis(500)`. This is both a correctness fix and a protection against pathological waits; no isolated saving was measured.

> **Impact — Correctness improvement:** The intended **500ms** poll semantics were restored, removing an incorrect potential long-poll bound. This does not mean every previous poll waited 500 seconds, and no isolated CI timing was collected.

**Polling and record limits**

`max.poll.records` changed from one to ten. Poll loops still have an upper bound, still filter records by the scenario's `testId`, and still assert the exact expected result count. They now break out of the current batch once the required count has been collected rather than processing unnecessary extra records.

**Consumer creation**

The previous setup instantiated one set of consumers directly, then immediately replaced each with a second consumer from `awakeConsumer`. The duplicate construction was removed. Each command, snapshot and runlog topic now receives one assigned and initially polled consumer.

**Readiness and HTTP reuse**

A shared `HttpClient` and two-second request timeout are used for readiness. The step checks both the actuator path and profile-specific path, records the latest failure, and fails after 90 bounded attempts. Poll-attempt logs were moved to debug level, but payload/assertion logging performance experiments were not retained as final behaviour.

**Dynamic configuration**

Kafka host/port, Schema Registry host/port, SUT host/port and topic suffix come from the Testcontainers runtime. This is required for dynamic mapped ports and isolated topics; legacy configuration-file behaviour remains when Testcontainers is disabled.

> **Impact — Structural improvement:** Larger poll batches, early exit and removal of duplicate consumer construction reduce unnecessary processing while bounded polling remains. No isolated timing was collected.

## 10. Aggregate Startup and Readiness

The full snapshot path uses five downstream services: party, object, location, event and service. They share the Testcontainers network with Redis, Kafka and Schema Registry and receive SNS-specific topic suffix, broker, registry, Redis and single-replica settings.

Shared prerequisites start first. Redis and ZooKeeper are launched concurrently using `Startables.deepStart`; Kafka then starts because it depends on ZooKeeper, and Schema Registry follows Kafka. The five aggregates start together using another `Startables.deepStart`, after which readiness checks run in parallel.

Each readiness check accepts the aggregate profile-specific path or `/actuator/health/readiness`, uses a shared client with a two-second request timeout, polls every 500 ms and permits up to 240 attempts. A timeout throws and fails the suite. Parallelism is safe here because shared messaging and state dependencies are already available and each aggregate has its own readiness endpoint.

Command-only execution avoids aggregate startup based on the selected Cucumber tag expression. Snapshot execution starts them once, tracked by `aggregatorsStarted`, so repeated application access does not duplicate the lifecycle.

> **Impact — Structural improvement:** Five independent aggregate starts and their readiness checks no longer run serially. No isolated timing was collected.

## 11. Kafka Streams and Application Shutdown

Successful test execution had been followed by a shutdown tail in which application/Kafka Streams threads remained active and Maven/Surefire waited for the forked JVM. The final environment makes lifecycle ownership explicit rather than masking the symptom with a shorter arbitrary process timeout.

Before the Spring context is closed, the environment retrieves managed `KafkaStreams` instances from `KafkaStreamConfig`, asks each to close gracefully with a 30-second bound, and polls their state every 100 ms until they are `NOT_RUNNING` or `ERROR`. It then closes the application context and the remaining containers/network. Kafka producers and consumers are also closed explicitly by the Cucumber finish hook.

This preserves graceful semantics while removing avoidable unmanaged tail behaviour. Simply reducing a Surefire timeout could terminate active streams, hide resource leaks or truncate diagnostics. Before the lifecycle correction, Build/Test was observed at approximately **3m53s** with an approximately **30s** shutdown tail. Representative post-fix runs were approximately **3m09s–3m10s**.

> **Impact — Observed system effect:** Approximately **30s** of known shutdown waiting was removed. The full **43–44s** Build/Test difference is not attributed solely to this change because normal run variation can account for the remainder.

## 12. Exact Built-Image Validation

The main business suite starts `CmdAdaptorApplication` in the test JVM. Passing that suite proves application behaviour against the ephemeral dependencies, but it does not prove that the Dockerfile, packaged JAR, agent, permissions, entry command and image runtime work together.

The final pipeline therefore retains this validation sequence:

```text
Build and Test with Testcontainers
        -> Build Command Adaptor Image
        -> Validate Built Image Runtime
        -> Scan with Trivy
```

`BuiltImageRuntimeIntegrationTest` first confirms that the exact local image exists. It connects the image to the same Testcontainers dependency network, supplies the dynamic Kafka, Schema Registry, Redis and topic settings, starts the container and polls `/actuator/health/readiness` for up to 120 seconds. It fails if the container exits, never becomes ready or is absent, and emits container/infrastructure diagnostics.

This guard was intentionally not removed for speed: JVM execution and container execution validate different artefacts.

> **Impact — Correctness improvement:** The exact packaged image remains independently validated. The runtime step's measured speed-up comes from Maven reuse described below, not from removing this coverage.

## 13. Runtime-Validation Maven Optimisation

**Previous behaviour**

Runtime validation used Maven with `-pl cmd-adaptor-sns-integration-tests -am verify`. `-am` selected and rebuilt upstream reactor modules even though the preceding Build/Test step had already built them.

**Change made**

`Build and Test with Testcontainers` activates `ci-local-install-artifacts`, which binds `maven-install-plugin:install` to `verify` and places reactor outputs in the pipeline-local Maven repository. Runtime validation then runs only:

```text
mvn -Dmaven.repo.local="$PWD/.m2/repository" \
    -pl cmd-adaptor-sns-integration-tests verify \
    -Pci-built-image-runtime-smoke \
    -Dsns.runtime.image=docker-compose-command-adaptor:latest
```

The dedicated profile selects only `BuiltImageRuntimeIntegrationTest` and excludes the suite-coverage unit test for this narrowly scoped invocation. Failsafe still requires tests to be present.

**Why and safety**

The change reuses already verified reactor artefacts rather than rebuilding/re-verifying upstream modules. It does not remove the image smoke test or change the image under test.

**Measured result**

Runtime validation moved from approximately **1m06s** to approximately **30–34s**.

> **Impact — Direct measurement:** Runtime validation reduced by approximately **32–36s** while retaining the same exact built-image smoke validation.

## 14. Extract Adaptor Information

**Where**

`bin/adaptor-info.sh` and `.drone.star`

**Previous behaviour**

The script launched Maven four times to evaluate aggregator-core, FDP BOM, CDLZ Avro schemas and FDP Commons versions. The Drone step also depended on `Wait for Docker`, although reading POM metadata does not require Docker.

**Change made**

One non-recursive (`-N`) Maven Help Plugin evaluation resolves a colon-delimited expression containing all four values. POSIX shell parsing splits the result and preserves the existing `N/A` fallback for an unavailable CDLZ expression. The step uses the pipeline-local Maven repository and now depends directly on `Retrieve Artifactory Secrets`.

**Why and safety**

The step reports metadata; repeated Maven startup/model processing and Docker serialisation were unnecessary. The same four report rows remain.

**Measured observation**

Earlier representative values were approximately **15–21s**; a later representative run was approximately **11s**. Runner and network variance means this should not be treated as a deterministic per-run saving.

> **Impact — Observed system effect:** The visible step improved by approximately **4–10s**, and its dependency change allows earlier overlap. The full visible difference is not claimed as an end-to-end saving.

## 15. Trivy Optimisation

### Previous behaviour

The final `Scan with Trivy` step also prepared the vulnerability DB and Java DB. The visible step was approximately **40–49s**. Within that work, the vulnerability DB was observed at approximately **4–5s** and the Java DB at approximately **19–20s**.

### Change made

`.drone.star` adds `Prepare Trivy DB` immediately after `Retrieve Artifactory Secrets`. It downloads both databases into:

```text
$PWD/.cache/trivy
```

The final scan uses the same directory and depends on both `Prepare Trivy DB` and `Validate Built Image Runtime`.

### Why and how

Because Drone steps share the pipeline filesystem and cache directory, the prepared databases are available to the later scan. Preparation runs in parallel with Docker readiness, Maven/test execution, image build and runtime validation. The optimisation therefore moves preparation off the final dependency path; it does not claim that the database download itself became faster.

### Validation and security

The final scan still targets `docker-compose-command-adaptor:latest`, retains `CRITICAL,HIGH`, `--ignore-unfixed`, the approved vulnerability and Java DB repositories, and `--exit-code 0`. Scanning and reporting remain enabled under the existing security policy; that policy is unchanged. Preparation is a required dependency, so preparation failure prevents the final scan from running rather than bypassing it.

### Result

> **Measured:** Recent runs showed **Prepare Trivy DB at 28s and 31s**, and the final scan at **15s and 14s**. Preparation remains useful at 28–31 seconds because it overlaps other work. These durations must not be added and interpreted as a slower sequential Trivy phase.

> **Impact — Direct measurement:** Moving preparation into parallel work removed approximately **25–35s** from the final Trivy critical-path contribution. DB preparation itself was not made faster, and scanning/reporting remain enabled under the existing security policy.

## 16. Implementation File Reference

The following files directly implement or support the CI optimisation.

| File | Implementation change | Why |
| --- | --- | --- |
| `.drone.star` | Defines the consolidated Testcontainers build/test flow, explicit image build and runtime validation, registry caching, Maven artefact reuse, parallel Trivy preparation and final dependency graph | Shorten the critical path and remove repeated orchestration while retaining required validation |
| `README.md` | Describes the Testcontainers execution profiles alongside the retained Compose path | Make the supported developer and CI execution modes clear |
| `bin/adaptor-info.sh` | Resolves four reported Maven properties with one non-recursive invocation | Reduce repeated Maven startup and model-processing work |
| `cmd-adaptor-sns/.dockerignore` | Restricts the Docker context to the two packaged runtime artefacts required by the image | Remove irrelevant context and cache invalidation inputs |
| `cmd-adaptor-sns/Dockerfile` | Places stable OS/tooling setup before application artefact copies and verifies the pinned envconsul download | Preserve reusable layers while retaining runtime and supply-chain protections |
| `pom.xml` | Adds the `ci-local-install-artifacts` profile so verified reactor outputs can be installed for later reuse | Avoid rebuilding upstream modules during focused runtime validation |
| `cmd-adaptor-sns-integration-tests/README.md` | Describes Testcontainers commands, Docker requirements and snapshot-image prerequisites | Support repeatable execution and troubleshooting |
| `cmd-adaptor-sns-integration-tests/pom.xml` | Adds Testcontainers dependencies and profiles, exact test selection, scenario expectations and zero-test failure controls | Execute the new lifecycle and prevent incomplete test runs from succeeding |
| `cmd-adaptor-sns-integration-tests/src/test/java/uk/gov/ho/dacc/fdp/IntegrationTest.java` | Enforces the Docker prerequisite when required and centralises suite selection in Maven configuration | Make infrastructure requirements explicit and test selection auditable |
| `cmd-adaptor-sns-integration-tests/src/test/java/uk/gov/ho/dacc/fdp/steps/SnsSteps.java` | Uses dynamic endpoints and topics, records completed scenarios, corrects Kafka polling, exits completed polls early and closes resources explicitly | Adapt the Cucumber suite to ephemeral infrastructure and prevent false-green execution |
| `cmd-adaptor-sns-integration-tests/src/test/java/uk/gov/ho/dacc/fdp/testcontainers/BuiltImageRuntimeIntegrationTest.java` | Starts the exact CI-built image with its dependencies and requires bounded readiness | Validate packaging, entrypoint and runtime configuration independently of in-JVM business tests |
| `cmd-adaptor-sns-integration-tests/src/test/java/uk/gov/ho/dacc/fdp/testcontainers/SnsTestcontainersEnvironment.java` | Owns dependency, aggregate and application lifecycle; dynamic configuration; topic creation; readiness; Schema Registry verification; diagnostics; and graceful shutdown | Consolidate infrastructure control in test code and reduce serial orchestration |
| `cmd-adaptor-sns-integration-tests/src/test/java/uk/gov/ho/dacc/fdp/testcontainers/TestcontainersFailureDiagnostics.java` | Captures container logs on failure and performs root-scope cleanup | Keep failures actionable despite ephemeral infrastructure |
| `cmd-adaptor-sns-integration-tests/src/test/java/uk/gov/ho/dacc/fdp/testcontainers/TestcontainersSuiteCoverageTest.java` | Requires at least seven feature files and 14 scenarios | Detect silent loss of business-suite coverage |
| `cmd-adaptor-sns-integration-tests/src/test/resources/docker-compose/docker-compose.yml` | Allows the command-adaptor service to select an already-built image while retaining the compatibility path | Support exact-image reuse without duplicating the image build |

## 17. Results and Impact

### Full CI

The baseline used ten successful runs so that infrastructure/test failures did not distort the normal successful critical path.

| Evidence | Result |
| --- | ---: |
| Baseline successful runs | N=10 |
| Baseline average | 13:35 |
| Baseline median | 13:31 |
| Baseline fastest | 13:20 |
| Baseline slowest | 13:57 |
| Measured optimised run 1 | 4:57 |
| Measured optimised run 2 | 4:44 |
| Baseline average to fastest measured optimised run | 8:51 (531 seconds) |
| Best measured reduction | ~65.2% |
| Best measured speed-up | ~2.87x |

The result does not establish that every future run will take 4m44s. Runner state, registry/network performance and cache availability remain variable.

### Selected component evidence

| Area | Before | Final/after | Evidence boundary |
| --- | ---: | ---: | --- |
| Runtime image validation | ~1:06 | ~0:30–0:34 | CI step observation |
| Final Trivy scan | ~0:40–0:49 | ~0:14–0:15 | CI step observation; DB preparation moved earlier |
| Trivy DB preparation | Included in final scan | ~0:28–0:31 in parallel | CI step observation; not added to final scan duration |
| Build/Test | — | ~3:10–3:16 | Representative final runs; no isolated baseline equivalent asserted |
| Docker layer invalidation | ~75.82–77.90s | ~4.62–5.08s | **Controlled same-daemon warm-cache experiment**, not CI |

No precise causal allocation of the full 8m51s saving is claimed. The result comes from changes to orchestration, lifecycle, Docker caching, Maven reuse and dependency-graph structure.

## 18. Why These Changes Worked

The implementation reduced transitions and repeated work rather than reducing validation:

- infrastructure lifecycle moved closer to the tests that define and consume it;
- multiple Compose/helper-container phases became one Maven-owned test phase;
- stable Docker work was separated from volatile application artefacts;
- registry caches provide reuse across clean CI workers and repeated development runs;
- already verified Maven reactor artefacts are reused by runtime validation;
- independent metadata, Docker readiness and Trivy preparation run concurrently;
- the exact built image remains a separate validation step because in-JVM tests cannot validate packaging;
- scenario, test-discovery, Docker and readiness failures are explicit;
- vulnerability scanning remains, while its preparatory downloads are moved off the final critical path.

The common principle is to optimise the dependency graph and lifecycle ownership, not to sum visible step durations or suppress work.

## 19. Experiments That Were Not Retained

The following evaluated options were not retained in the final implementation.

| Experiment | Observation | Decision |
| --- | --- | --- |
| Maven parallel build | No reproducible benefit | Not retained |
| Background image prefetch | Slower results and no consistent benefit | Not retained |
| Logging reduction for performance | No reproducible performance gain | Not retained |
| Readiness-result caching | Changed validation semantics | Not retained |

These experiments were useful evidence: they prevented speculative complexity from remaining in the final changeset.

## 20. Applying This Work to Other Repositories

The reusable engineering patterns are to measure the successful critical path, minimise Docker inputs, place stable layers before volatile artefacts, reuse registry and Maven outputs, overlap independent preparation, move suitable infrastructure lifecycle into Testcontainers, enforce test completeness and validate the exact packaged image separately.

SNS-specific topics, scenario counts, aggregate services, image versions, registry locations, health paths and application properties must be reassessed for each target system. The architecture should be transferred only after establishing equivalent coverage and measuring the target pipeline.

## 21. Conclusion

SNS was used as a pilot for an evidence-led combination of Docker, test architecture, Maven reuse and CI critical-path improvements. The successful CI baseline averaged **13m35s**; two measured optimised runs completed in **4m57s** and **4m44s**, while business-scenario, built-image and vulnerability validation remained in place.

The main reusable outcome is the method: measure, change lifecycle or dependency structure, add explicit correctness guards, validate the exact artefact, and keep only repeatable improvements. SNS-specific topics, aggregates, counts and configuration should not be copied without independent assessment.

## Document Review Notes

- Add the relevant Jira/Epic links.
- Add the merge request URL.
- Add screenshots of the before/after Drone pipeline if useful.
- Link the baseline sample and both measured optimised pipeline runs, including the latest post-cleanup run.
- Confirm rollout ownership and which centrally managed `.drone.star`, `Dockerfile` and `bin/adaptor-info.sh` changes must be promoted through RepoSync.
- Confirm ownership of the centrally managed pipeline configuration.
