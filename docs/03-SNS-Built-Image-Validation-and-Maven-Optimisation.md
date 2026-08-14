# FDP Command Adaptor SNS — Built-Image Validation & Maven Optimisation

## Scope

This page explains why the packaged Docker image is validated separately from the in-JVM business suite and how Maven runtime reuse reduced that validation step without removing coverage.

Related pages:

- [CI/CD optimisation overview](00-SNS-CI-CD-Optimisation-Implementation-Report.md)
- [Docker and CI pipeline optimisation](01-SNS-CI-CD-Docker-and-Pipeline-Optimisation.md)
- [Testcontainers migration and test reliability](02-SNS-Testcontainers-Migration-and-Test-Reliability.md)
- [Results, engineering learnings and reuse guide](04-SNS-CI-CD-Results-Learnings-and-Reuse.md)

## Why Separate Runtime Validation Is Required

The Cucumber business suite starts `CmdAdaptorApplication` inside the test JVM. That validates application behaviour against Redis, Kafka, Schema Registry and the downstream aggregates, but it does not validate:

- Dockerfile behaviour and image contents;
- the packaged executable JAR;
- the OpenTelemetry agent;
- file ownership and the non-root runtime user;
- the image entry command;
- container network/runtime configuration.

The pipeline therefore keeps these responsibilities separate:

```text
Build/Test with Testcontainers
          |
Build Command Adaptor Image
          |
Validate Built Image Runtime
          |
Scan with Trivy
```

## Exact Built-Image Runtime Test

**Where:** `BuiltImageRuntimeIntegrationTest.java`

The test first confirms that the exact image produced earlier in the pipeline is available. It starts Redis, ZooKeeper, Kafka and Schema Registry on the shared Testcontainers network, supplies the image with dynamic broker, registry, Redis and topic configuration, then polls `/actuator/health/readiness`.

Readiness uses two-second HTTP requests and a 500ms poll interval for up to 120 seconds. The test fails if the image is absent, the container exits or readiness is never reached. Container and infrastructure logs are emitted on failure.

> **Impact — Correctness:** The packaged artefact remains independently validated. The step was not removed to gain speed.

## Maven Runtime Reuse

**Where:** root `pom.xml`, integration-test `pom.xml`, `.drone.star`

### Before

```sh
mvn -pl cmd-adaptor-sns-integration-tests \
    -am verify \
    -Pci-built-image-runtime-smoke
```

`-am` selected and rebuilt upstream reactor modules even though the preceding Build/Test step had already verified them.

### After

```sh
export MAVEN_REPO_LOCAL="$PWD/.m2/repository"
mkdir -p "$MAVEN_REPO_LOCAL"

mvn -Dmaven.repo.local="$MAVEN_REPO_LOCAL" \
    -pl cmd-adaptor-sns-integration-tests verify \
    -Pci-built-image-runtime-smoke \
    -Dsns.runtime.image=docker-compose-command-adaptor:latest
```

`Build and Test with Testcontainers` activates `ci-local-install-artifacts`. That profile binds `maven-install-plugin:install` to `verify`, making already-verified reactor outputs available to the later module-only invocation.

The runtime-smoke profile selects only `BuiltImageRuntimeIntegrationTest`, excludes the suite-coverage JUnit guard from this narrowly scoped invocation, and retains `failIfNoTests=true` and `failIfNoSpecifiedTests=true`.

> **Impact — Direct CI measurement:** Runtime validation reduced from approximately **1m06s** to **30–34s**, a step reduction of approximately **32–36s**, while the same exact-image readiness validation remained.

## Redundant Dependency Preparation

Separate dependency pre-resolution was removed where the preceding Maven lifecycle had already resolved the dependencies required by the build and tests.

```text
Before: clean verify/install -> separate dependency pre-resolution
After:  clean verify with reusable outputs -> focused runtime verify
```

> **Impact — Structural improvement:** Duplicate Maven dependency work was removed. No isolated timing was collected.

## Safety Controls

- Runtime validation cannot start before image build succeeds.
- The image name is passed explicitly through `sns.runtime.image`.
- Image availability is checked before startup.
- The runtime profile fails if its selected test is absent.
- Readiness failure and early container exit fail the step.
- Failure diagnostics include container and dependency logs.
- Trivy runs only after runtime validation and database preparation complete.

## Implementation Files

| File | Implementation responsibility |
| --- | --- |
| `pom.xml` | `ci-local-install-artifacts` profile and Maven Install Plugin binding |
| `cmd-adaptor-sns-integration-tests/pom.xml` | Focused runtime-smoke profile, exact test selection and zero-test controls |
| `cmd-adaptor-sns-integration-tests/src/test/java/uk/gov/ho/dacc/fdp/testcontainers/BuiltImageRuntimeIntegrationTest.java` | Exact-image startup, readiness and diagnostics |
| `.drone.star` | Ordered image build, focused Maven invocation and Trivy dependency |
