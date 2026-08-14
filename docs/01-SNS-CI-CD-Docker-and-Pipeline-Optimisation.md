# FDP Command Adaptor SNS — Docker & CI Pipeline Optimisation

## Scope

This page explains the Docker build and CI dependency-path changes for `fdp-cmd-adaptor-sns`. It covers `.dockerignore`, Docker layer ordering, the BuildKit builder/cache strategy, the pipeline graph, adaptor-information extraction and Trivy database preparation.

Related pages:

- [CI/CD optimisation overview](00-SNS-CI-CD-Optimisation-Implementation-Report.md)
- [Testcontainers migration and test reliability](02-SNS-Testcontainers-Migration-and-Test-Reliability.md)
- [Built-image validation and Maven optimisation](03-SNS-Built-Image-Validation-and-Maven-Optimisation.md)
- [Results, engineering learnings and reuse guide](04-SNS-CI-CD-Results-Learnings-and-Reuse.md)

## Docker Build Context

**Where:** `cmd-adaptor-sns/.dockerignore`

### Before

The module had no focused Docker ignore rules. The measured context was approximately **191.27 MB**, although the image consumes only the packaged application JAR and OpenTelemetry agent from `target`.

### After — abridged

```dockerignore
src/
target/**
!target/
!target/cmd-adaptor-sns-exec.jar
!target/dependencies/
!target/dependencies/opentelemetry-javaagent.jar
.mvn/
pom.xml
```

The runtime payload from `target` is restricted to the application JAR and OpenTelemetry agent, while unrelated source/build content is excluded. BuildKit reported a **189 B** content-store observation in the controlled measurement.

> **Impact — Direct controlled Docker measurement:** The input was substantially narrowed. This is not a universal CI network-transfer saving; the cold build remained broadly similar and the image remained approximately **906 MB**.

## Docker Layer Ordering

**Where:** `cmd-adaptor-sns/Dockerfile`

### Before — abridged

```dockerfile
COPY ./target/cmd-adaptor-sns-exec.jar /local

RUN yum install ... \
    && install-envconsul ...
```

### After — abridged

```dockerfile
RUN yum install ... \
    && install-envconsul ...

COPY ./target/cmd-adaptor-sns-exec.jar /local/cmd-adaptor-sns-exec.jar
```

The stable OS, envconsul and user setup now precedes volatile application artefacts, including the application JAR and OpenTelemetry agent. A normal JAR change therefore invalidates the artefact and permission layers, not the expensive system/tooling layer.

The final image still uses Amazon Corretto 17, runs as `fdpuser`, contains the JAR and agent, and retains the runtime command. Envconsul `0.13.4` is downloaded with redirect/error handling and a pinned SHA-256 verification before extraction.

> **Impact — Direct controlled Docker measurement:** A same-daemon warm-cache rebuild after a real JAR change reduced from approximately **75.82–77.90s** to **4.62–5.08s**, approximately **15–16x** faster for this specific case. This is neither a cold-build nor a full-CI timing.

Additional observations: cold build **1m17.855s**, warm no-change build **0m0.851s**, prepared JAR approximately **166 MB**, Docker image-history layer approximately **173 MB**, OpenTelemetry agent approximately **18 MB**, and system/yum layer approximately **249 MB**.

## BuildKit Builder/Cache Strategy

**Where:** `.drone.star`, `Build Command Adaptor Image`

### Before

The Compose-oriented application build had no explicit registry-backed cache policy. A custom docker-container builder was also evaluated during the optimisation work.

### After — representative configuration

```sh
docker buildx build --builder default --load \
  --cache-from=type=registry,ref="$SHARED_CACHE" \
  --cache-from=type=registry,ref="$ISOLATED_CACHE" \
  --cache-to=type=registry,ref="$ISOLATED_CACHE",mode=max \
  --tag "$COMMAND_ADAPTOR_IMAGE" cmd-adaptor-sns
```

The primary delivery stream reads and writes the shared cache. Independent development work reads the shared and isolated caches but writes only to its isolated cache. An inline-cache fallback is retained when buildx is unavailable. The exact resulting image is loaded, tagged as `docker-compose-command-adaptor:latest`, and must pass `docker image inspect`.

> **Impact — Observed system effect:** The default-builder path completed in approximately **41–42s** and was approximately **18–20s faster** than the custom docker-container builder path in the controlled comparison. The isolated benefit of registry caching itself was not measured.

## Pipeline Architecture

**Where:** `.drone.star`

### Before

```text
Secrets / Docker readiness
          |
Kafka & Redis ---- Aggregators ---- Command Adaptor
          |                              |
     Maven build                  Pre-Integration
                                         |
                                 Integration Tests
                                         |
                                      Trivy
```

The lifecycle was distributed across Compose services and helper containers. Visible baseline averages included Command Adaptor **11:01**, Integration Tests **9:43**, Kafka & Redis **2:18**, Maven build **1:24**, Aggregators **0:29**, Pre-Integration **0:06** and Trivy **0:44**. These steps overlapped and must not be added.

### After

```text
Retrieve Artifactory Secrets
       |              |                  |
       |              |                  +--> Prepare Trivy DB --------+
       |              +--> Extract Adaptor Information --+             |
       +--> Wait for Docker ------------------------------+             |
                                                          |             |
                                        Build/Test with Testcontainers  |
                                                  |                     |
                                             Build image                |
                                                  |                     |
                                      Validate built-image runtime      |
                                                  +----------+----------+
                                                             |
                                                         Trivy scan
```

Build/Test must succeed before image build; image build must succeed before runtime validation; runtime validation and Trivy preparation must both finish before the final scan. Docker readiness, adaptor-information extraction and Trivy preparation can progress independently after secrets are available.

The separate Kafka & Redis, Aggregators, detached Command Adaptor, Pre-Integration and Integration Tests steps are replaced by one test-owned lifecycle. The final image is built once and validated directly.

> **Impact — Observed system effect:** The dependency graph overlaps independent work and removes orchestration stages from the critical path. Its isolated saving was not measured; it contributes to the end-to-end result.

## Adaptor Information

**Where:** `bin/adaptor-info.sh`, `.drone.star`

### Before — simplified

```sh
mvn help:evaluate -Dexpression=aggregator-core.version
mvn help:evaluate -Dexpression=fdp-bom.version
mvn help:evaluate -Dexpression=cdlz-avro-schemas.version
mvn help:evaluate -Dexpression=fdp-commons.version
```

### After — abridged

```sh
echo '${aggregator-core.version}:${fdp-bom.version}:${cdlz-avro-schemas.version}:${fdp-commons.version}' |
  mvn org.apache.maven.plugins:maven-help-plugin:3.2.0:evaluate \
    -N -q -DforceStdout
```

One non-recursive Maven evaluation returns the four values, which are split by POSIX shell parsing. The existing `N/A` fallback remains. The step depends on secrets rather than Docker readiness, so it can start earlier.

> **Impact — Observed CI step:** Representative values improved from approximately **15–21s** to approximately **11s**, a visible **4–10s** difference. Not all of that difference is claimed as end-to-end saving.

## Trivy Critical-Path Optimisation

**Where:** `.drone.star`, `Prepare Trivy DB` and `Scan with Trivy`

### Before — execution shape

```text
runtime validation
       |
download vulnerability DB
       |
download Java DB
       |
scan and report image
```

The final Trivy step included database preparation and took approximately **40–49s**.

### After — execution shape

```text
secrets --> Prepare Trivy DB --------------------+
                                                  |
Build/Test --> image --> runtime validation ------+--> final scan/report
```

Both databases are prepared in `$PWD/.cache/trivy` while other useful work continues. The final scan uses the same cache directory and waits for both runtime validation and database preparation.

The final scan still targets `docker-compose-command-adaptor:latest`, retains `CRITICAL,HIGH`, `--ignore-unfixed`, the approved database repositories and `--exit-code 0`. No scanner was disabled; vulnerability- and secret-scanning behaviour and the existing exit-code policy remain unchanged.

> **Impact — Direct CI critical-path measurement:** Preparation was approximately **28–31s** in parallel and the final scan approximately **14–15s**, removing approximately **25–35s** from the final Trivy critical-path contribution. Database preparation itself was not made faster, and the two durations must not be added as a sequential phase.

## Implementation Files

| File | Implementation responsibility |
| --- | --- |
| `.drone.star` | Final CI dependency graph, builder/cache strategy, adaptor-information scheduling and Trivy preparation/scan |
| `cmd-adaptor-sns/.dockerignore` | Focused Docker build context |
| `cmd-adaptor-sns/Dockerfile` | Stable layer ordering and verified envconsul acquisition |
| `bin/adaptor-info.sh` | Single Maven evaluation for four metadata values |
