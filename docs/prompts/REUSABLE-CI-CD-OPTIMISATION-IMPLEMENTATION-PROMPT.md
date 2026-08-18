# Reusable CI/CD Optimisation Implementation Prompt

Use this prompt inside a target repository that is expected to benefit from the same engineering principles demonstrated by the FDP Command Adaptor SNS pilot.

The SNS implementation is a **reference pattern**, not a patch to copy verbatim. Repository structure, CI topology, business-test coverage, Docker images, service dependencies, ports, health endpoints, Maven profiles, registry paths, security policy and infrastructure versions must be rediscovered in every target repository.

---

## Prompt

You are working directly in the current target repository.

Your task is to **analyse, implement and verify** a CI/CD optimisation based on the engineering approach proven in the FDP Command Adaptor SNS pilot:

- measure the current pipeline before changing it;
- identify the actual critical path and duplicated work;
- consolidate integration-test lifecycle ownership where appropriate;
- move independent preparation off the critical path;
- reuse verified build outputs;
- optimise Docker context, layers and cache reuse;
- preserve business, packaged-runtime and security validation;
- introduce explicit false-green protections;
- keep only changes supported by correctness reasoning or reproducible evidence.

The desired result is not merely a lower duration. The result must be a **shorter, simpler and more reliable feedback loop with equivalent or stronger validation**.

This is an implementation task. Do not stop after producing recommendations. Inspect the target repository, implement safe applicable changes, run proportionate verification, and report exactly what was and was not proven.

Do not blindly reproduce SNS-specific code or values.

---

## 1. Operating Mode

Work autonomously within the target repository.

Before editing:

1. Read repository-level agent/contributor instructions completely.
2. Inspect the current worktree and preserve all pre-existing user changes.
3. Discover the actual CI system and generated configuration source.
4. Understand the current integration-test architecture and validation surface.
5. Establish the strongest baseline supported by available evidence.
6. Identify which SNS patterns are applicable and which are not.

During implementation:

- make small, reviewable changes;
- validate after each material workstream;
- do not mix unrelated refactoring into the optimisation;
- do not overwrite or revert user-owned changes;
- do not use destructive Git commands;
- do not commit, push, open a merge request or trigger externally visible changes unless explicitly authorised;
- do not invent CI results when the pipeline cannot be run;
- do not create documentation, reports, benchmark files, temporary measurement scripts or generated artefacts in the repository;
- use temporary locations for investigation-only output and remove temporary content when finished;
- keep the final diff limited to implementation files required by the optimisation.

If an architectural choice cannot be resolved from the repository and would materially change validation semantics, stop and ask one concise question. Otherwise make the safest evidence-based assumption and state it in the final response.

---

## 2. Non-Negotiable Safety Constraints

The optimisation must not obtain speed by weakening validation.

Do not:

- remove, skip or reduce business scenarios;
- change test tags or filters in a way that executes fewer intended scenarios;
- silently tolerate Docker being unavailable in CI;
- allow a Maven test phase to pass with zero selected tests;
- remove exact built-image runtime validation if the current pipeline validates the packaged image;
- replace exact-image validation with an in-JVM test and call it equivalent;
- remove vulnerability scanning;
- remove secret scanning;
- change vulnerability severity filters;
- change `--ignore-unfixed` behaviour;
- change scanner exit-code policy;
- change approved vulnerability-database repositories;
- weaken database freshness semantics;
- remove failure diagnostics merely to reduce logs;
- replace current readiness checks with cached historical readiness results;
- lower timeouts without proving that active work and cleanup are still safe;
- hard-code SNS-specific feature counts, scenario counts, topic names, service images, ports, health paths or component versions;
- add sleeps as a substitute for deterministic readiness;
- add unbounded polling, unbounded futures or unbounded shutdown waits;
- sum overlapping CI step durations;
- add individual optimisation savings together and present the total as end-to-end saving;
- present a controlled local Docker result as a full-CI result;
- claim an observed best run as a guaranteed future duration.

Preserve the target repository's existing security and release policy unless the user explicitly authorises a policy change.

---

## 3. Reference Outcome and Evidence Boundaries

The SNS pilot provides a pattern and evidence model, not a target duration for every repository.

The reference implementation achieved the following execution shape:

```text
Retrieve required secrets
       |             |                    |
       |             |                    +--> Prepare scanner databases ----+
       |             +--> Extract build/adaptor metadata ----+               |
       +--> Wait for Docker -------------------------------+  |               |
                                                           |  |               |
                                      Build/Test with test-owned dependencies |
                                                     |                        |
                                               Build exact image              |
                                                     |                        |
                                      Validate exact built-image runtime      |
                                                     +------------------------+
                                                                              |
                                                                      Final scan
```

The essential rules are:

- independent setup work should overlap;
- correctness gates should remain sequential;
- infrastructure used only by integration tests should preferably be owned by the test lifecycle;
- the application may run in the test JVM for business testing if this preserves behaviour;
- the exact Docker image must still be validated separately when image/runtime correctness matters;
- security scanning must remain in the final path;
- verified build outputs should be reused rather than rebuilt;
- timing claims must match their measurement boundary.

Do not force this topology when the target repository has different requirements. Produce the smallest equivalent graph that preserves its validation responsibilities.

---

## 4. Repository and Worktree Discovery

Start with read-only inspection.

Record internally, without creating a report file:

- repository root and current branch;
- clean/dirty worktree state;
- modified and untracked files that already belong to the user;
- build system and module structure;
- Java/JDK, Maven/Gradle and framework versions;
- integration-test module or source set;
- current CI platform and pipeline-generation mechanism;
- Docker build contexts and Dockerfiles;
- Compose files and helper containers;
- test runner, Cucumber/JUnit versions and Maven plugin configuration;
- container registry and authentication flow;
- security scanner, version and policy flags;
- pipeline workspace and cache-sharing behaviour;
- availability of local Docker and whether local verification is possible.

Use repository search tools before making assumptions. Search for:

```text
pipeline step definitions
depends_on / needs / dependencies
docker-compose / compose
Dockerfile and .dockerignore
Testcontainers / GenericContainer / KafkaContainer
DOCKER_HOST / DOCKER_API_VERSION
TESTCONTAINERS_HOST_OVERRIDE / RYUK
Failsafe / Surefire profiles
Cucumber tags and plugins
failIfNoTests / failIfNoSpecifiedTests
readiness / health endpoints
poll loops and timeout units
Maven dependency pre-resolution
buildx / BuildKit / cache-from / cache-to
Trivy or equivalent scanner commands
image tags passed between CI stages
metadata extraction using repeated Maven calls
```

Determine whether the visible pipeline file is authoritative or generated. If it is generated, edit the source generator rather than only editing generated YAML.

---

## 5. Reconstruct the Current Pipeline Graph

Build an internal dependency map of every relevant step.

For each step, determine:

- direct dependencies;
- whether it runs in parallel with another step;
- inputs consumed;
- files or images produced;
- whether those outputs persist in the shared workspace or Docker daemon;
- secrets required;
- Docker daemon requirement;
- whether it owns a long-running process;
- whether it performs validation or only preparation;
- whether it duplicates work already performed elsewhere;
- whether downstream steps genuinely require it.

Explicitly identify:

1. secrets and registry-authentication steps;
2. Docker/DIND readiness;
3. dependency or infrastructure startup;
4. Maven build and unit tests;
5. integration/business tests;
6. application-container startup;
7. pre-integration readiness helpers;
8. image build;
9. built-image runtime validation;
10. security database preparation;
11. final security scan;
12. publication/deployment gates.

Do not assume that the longest visible step is the only critical path. Several steps may overlap, and lifecycle shutdown may extend a step after useful assertions have finished.

Before editing, be able to explain internally:

```text
Which work is sequential because correctness requires it?
Which work is sequential only because of the current graph?
Which work is duplicated?
Which infrastructure exists only for tests?
Which validation proves application behaviour?
Which validation proves the packaged image?
Which work can start immediately after secrets are available?
```

---

## 6. Establish a Baseline

Prefer successful full-pipeline wall-clock measurements from the CI platform.

If historical data is available:

- use multiple successful runs, preferably at least five and ideally ten;
- exclude cancelled, failed or infrastructure-corrupted runs from the successful-run baseline;
- record sample size, average, median, fastest and slowest;
- note relevant runner, cache or branch differences;
- record visible step averages only as supporting evidence;
- mark steps that overlap.

If only one or two baseline runs are available, state that limitation. Do not create statistical language that the sample cannot support.

If external CI data is not accessible:

- inspect existing logs or repository evidence;
- run safe local controlled measurements where possible;
- label local measurements as controlled observations;
- do not fabricate an end-to-end CI baseline;
- continue with correctness-supported structural improvements only when they are independently justified.

Use seconds internally for calculations. For a baseline `B` and optimised result `O`:

```text
saving_seconds = B - O
reduction_percent = ((B - O) / B) * 100
speed_up = B / O
```

Do not calculate the overall saving by summing component rows.

---

## 7. Inventory the Validation Surface Before Migration

Before changing test orchestration, determine exactly what currently executes.

Inventory:

- feature files;
- business scenarios after tag filtering;
- Cucumber runners and plugins;
- JUnit/Surefire tests;
- Failsafe integration tests;
- smoke tests;
- helper validation containers;
- topic-creation checks;
- Schema Registry registration/read checks;
- application readiness checks;
- downstream service readiness checks;
- exact-image validation;
- vulnerability and secret scanning;
- failure log collection;
- cleanup behaviour.

Determine the current expected feature/scenario/test counts programmatically from the target repository. Do not copy SNS values such as seven feature files or 14 business scenarios.

Capture the intended Cucumber tag expression and verify that ignored, command-only, smoke and full-suite profiles remain distinct.

Identify any current false-green behaviour, including:

- Docker-unavailable paths that skip tests;
- missing test classes that still produce success;
- profiles that select zero tests;
- scenario listeners that count discovered rather than completed scenarios;
- a green helper step that does not prove the business suite ran;
- readiness containers that return stale or synthetic success;
- background processes whose failure is not propagated.

No orchestration change is acceptable until equivalent coverage can be demonstrated.

---

## 8. Decide Whether Testcontainers Is Appropriate

Testcontainers is appropriate when:

- infrastructure exists primarily for integration tests;
- the tests need isolated Kafka, Redis, Schema Registry, databases or downstream services;
- dynamic ports and per-run networks are acceptable;
- the CI runner exposes a supported Docker endpoint;
- private images can be authenticated safely;
- lifecycle ownership can move into test code without changing business semantics.

Do not force Testcontainers when:

- tests intentionally validate an externally managed environment;
- infrastructure cannot legally or technically run in the CI Docker daemon;
- required images or licences prohibit this model;
- the application must be tested only as an immutable image and cannot have an equivalent in-JVM business-test path;
- the target CI platform cannot provide reliable Docker access;
- migration would silently remove behaviour performed by existing helper containers.

If Testcontainers is not appropriate, still apply the reusable principles that fit: Docker optimisation, graph simplification, cache reuse, parallel preparation, false-green protection and scanner preparation.

---

## 9. Target Integration-Test Architecture

When Testcontainers is appropriate, design one explicit environment owner in test code.

That owner should be responsible for:

- shared network creation;
- dependency image definitions;
- private registry compatibility;
- container aliases;
- dynamic host/port discovery;
- startup order;
- topic/database/schema preparation;
- application configuration injection;
- readiness checks;
- failure diagnostics;
- deterministic reverse-order cleanup;
- protection against reuse after shutdown.

Prefer this conceptual order, adapting it to the target system:

```text
independent base dependencies start concurrently
        |
ordered broker/database dependencies start
        |
schema/topic/data prerequisites are verified
        |
application under business test starts
        |
independent downstream services start concurrently
        |
readiness checks run concurrently with bounded timeouts
        |
business scenarios execute
        |
application and clients close gracefully
        |
containers and network close deterministically
```

Use dependency-aware concurrency. Do not start components concurrently when one requires another to be ready.

Avoid fixed host ports unless the target behaviour explicitly requires them. Use mapped ports, network aliases and runtime-injected endpoints.

Use unique per-run resource names where shared state could leak between executions:

- topic suffixes;
- consumer group IDs;
- database/schema names;
- bucket or queue names;
- temporary paths.

Do not hard-code SNS topic catalogues, aggregate names or application properties.

---

## 10. Application-under-Test Strategy

Separate two validation responsibilities.

### Business behaviour

If compatible with the application framework, start the application inside the integration-test JVM using an ephemeral HTTP port and dynamically injected dependency endpoints.

This path should prove:

- application business behaviour;
- message production/consumption;
- interactions with required dependencies;
- Cucumber or equivalent business scenarios;
- downstream service outcomes.

### Packaged runtime

After the business suite succeeds and CI builds the Docker image, start the exact image created by that pipeline and verify its runtime readiness separately.

This path should prove:

- Dockerfile correctness;
- packaged JAR/binary presence;
- runtime user and file permissions;
- entry command;
- runtime agent presence where required;
- container networking;
- required environment configuration;
- readiness and early-exit behaviour.

Do not claim that in-JVM business testing validates the Docker image. Do not rerun the full business suite against the image unless the target repository requires it and the duplicated cost is justified.

---

## 11. Docker and CI Compatibility

Inspect the target versions before setting compatibility variables.

Determine:

- Testcontainers version;
- Docker daemon and API compatibility;
- CI DIND endpoint;
- host override needed by mapped ports;
- registry authentication mechanism;
- whether Ryuk works in this environment;
- workspace and Docker-daemon lifetime between steps.

Configure only values proven necessary for the target CI environment. The SNS values below are examples, not defaults:

```text
DOCKER_HOST=tcp://docker:2375
DOCKER_API_VERSION=1.41
TESTCONTAINERS_HOST_OVERRIDE=docker
TESTCONTAINERS_RYUK_DISABLED=true
```

Do not copy these values without checking the target runner.

If Ryuk must be disabled:

- state the reason in code only where a short operational comment is useful;
- make explicit test-owned cleanup mandatory;
- close resources in bounded reverse dependency order;
- register root-scope cleanup for abnormal suite termination where practical;
- ensure the pipeline does not leave long-running containers behind.

Create Docker client authentication without printing credentials. Ensure private image resolution works from the exact Docker client configuration used by Testcontainers.

Never make Docker absence a silent success in CI. A local developer profile may optionally skip when Docker is unavailable, but the CI profile must fail.

---

## 12. False-Green Protections

Add protections appropriate to the target test framework.

At minimum:

1. CI must fail if required Docker access is unavailable.
2. Maven Failsafe/Surefire must fail when the selected test set is empty.
3. Narrow profiles must fail if their explicitly selected test disappears.
4. The business suite must verify a minimum expected feature/scenario count derived from the current target suite.
5. Count completed Cucumber test cases, not merely discovered features.
6. Dependency-image resolution failure must fail the suite.
7. Topic/schema/data prerequisite failure must fail the suite.
8. Readiness exhaustion must fail the suite.
9. Early application or container exit must fail the suite.
10. Failure diagnostics must remain accessible.

For Maven, inspect and configure the relevant plugin rather than assuming defaults. Applicable controls may include:

```xml
<failIfNoTests>true</failIfNoTests>
<failIfNoSpecifiedTests>true</failIfNoSpecifiedTests>
```

For Cucumber, use the target runner's event system to count completed scenarios. If a separate JUnit test protects the feature/scenario inventory, keep it distinct from the business-scenario count.

Do not inflate the business scenario total by counting a coverage guard or infrastructure smoke test as a business scenario.

---

## 13. Polling and Consumer Correctness

Inspect every poll duration and retry constant for unit mismatches.

Check for patterns such as:

```java
Duration.ofSeconds(VALUE_NAMED_MS)
Duration.ofMillis(VALUE_NAMED_SECONDS)
```

Correct the unit only after confirming intended behaviour from names, surrounding timeouts, tests and call sites.

For Kafka or similar consumers:

- use bounded poll duration;
- use an appropriate batch size;
- stop processing once the required result count is reached;
- avoid constructing duplicate consumers for the same role;
- use unique consumer groups where run isolation matters;
- close consumers and producers with bounded waits;
- retain meaningful assertion failures;
- do not turn a long upper bound into a claimed fixed wait when the client can return early.

Classify unit corrections primarily as correctness changes unless an isolated timing was actually measured.

---

## 14. Concurrent Startup and Readiness

Identify independent services currently started sequentially.

Start independent containers concurrently using the Testcontainers-supported dependency-aware mechanism available in the target version. Preserve required ordering for dependent services.

Examples of safe parallel groups may include:

- Redis and ZooKeeper when independent;
- multiple downstream aggregate services after their common broker/schema dependencies are ready;
- readiness checks for already-started independent services.

Every readiness check must have:

- a bounded total attempt count or deadline;
- a bounded per-request timeout;
- an intentional poll interval;
- a success predicate specific to the service;
- the latest failure retained for diagnostics;
- a hard failure when exhausted.

Reuse HTTP clients where safe. Avoid creating a new client for every poll.

Do not replace readiness with fixed sleeps. Do not cache a successful readiness result across separate validation stages when the later stage is intended to validate current state.

---

## 15. Diagnostics and Cleanup

Performance work must not make failures harder to diagnose.

On infrastructure or application failure, capture relevant:

- container state;
- exit code;
- recent logs;
- readiness failure;
- last connection exception;
- topic/schema preparation failure;
- application startup failure.

Avoid dumping all container logs on every successful run. Emit detailed logs when a test or startup phase fails.

Close resources in a deterministic order. A typical order is:

```text
application-managed streams and clients
application context
downstream services
schema service
broker
broker coordinator
cache/database
shared network
```

Use bounded graceful closure. For Kafka Streams or similar managed runtimes:

- retrieve actual managed instances;
- request graceful close with an explicit allowance;
- wait for terminal states with bounded polling;
- then close the application context;
- do not shorten the entire process timeout merely to hide a shutdown tail.

If the original pipeline shows a repeatable post-test tail, distinguish assertion completion from lifecycle cleanup and fix ownership rather than killing the process early.

---

## 16. Cucumber Output and Logging

Inspect Cucumber plugin configuration and CI reporting consumers.

Verbose formatting may be removed only when required output remains, such as:

- concise summary;
- HTML or machine-readable report used by CI;
- event listener required for completed-scenario accounting;
- failure details.

Do not claim performance improvement from logging reduction unless it is reproducible. Preserve useful diagnostics if no measurable gain exists.

Move repetitive readiness-attempt output to debug level if failure summaries retain the final useful evidence.

---

## 17. Maven Build and Artefact Reuse

Map every Maven invocation in the pipeline.

For each invocation, identify:

- selected modules;
- `-am`/`-amd` behaviour;
- lifecycle phase;
- profiles;
- local repository path;
- whether upstream modules were already verified;
- whether outputs are available to later steps;
- whether dependency pre-resolution duplicates earlier work.

The desired pattern is:

```text
full build/test verifies reactor outputs once
        |
verified outputs become available in the shared pipeline-local Maven repository
        |
focused later validation invokes only the module/test it needs
```

If a later runtime-smoke step currently uses `-am` and rebuilds upstream modules:

1. verify that the preceding build has produced the required artefacts;
2. use a shared pipeline-local Maven repository path;
3. make verified reactor outputs available to that repository at or after `verify`;
4. invoke only the focused module/profile in the later step;
5. retain fail-if-no-test protections;
6. confirm the later step cannot consume stale outputs from a different build.

An SNS-style implementation used a CI-only profile binding Maven Install Plugin to `verify`, then ran a module-only runtime-smoke profile against the shared `.m2/repository`. Reassess this mechanism against the target parent POM and lifecycle.

Do not remove `-am` until artefact availability is proven. Do not use `install` or a shared repository in a way that publishes or leaks unverified outputs.

Remove a separate dependency pre-resolution step only when the earlier Maven lifecycle demonstrably resolves the same dependencies. Do not assume `dependency:go-offline` is always redundant.

Do not retain Maven `-T` or other parallelism solely because it appears faster in theory. Keep it only if repeated end-to-end measurements show benefit without instability or resource contention.

---

## 18. Exact Built-Image Runtime Validation

If the pipeline produces a Docker image for deployment, validate the exact image built in the preceding CI step.

The runtime validation must:

- receive the exact image tag explicitly;
- confirm the image exists in the shared Docker daemon or approved registry;
- avoid silently pulling a different image with the same mutable tag;
- start only the dependencies required for boot/readiness validation;
- supply dynamic dependency endpoints;
- use the packaged image entry command and runtime user;
- fail on early container exit;
- poll a target-specific readiness endpoint with bounded timeouts;
- emit image-container and dependency logs on failure;
- clean up deterministically;
- run only after image build succeeds.

Keep this profile narrowly focused. Do not rerun the entire business suite unless required.

If the runtime-smoke profile selects one test class, configure the test runner so deletion or renaming of that class fails the step rather than producing a green zero-test result.

The final security scan must target the same exact image after runtime validation.

---

## 19. Docker Build Context

Inspect every file consumed by the Dockerfile.

Create or refine `.dockerignore` in the actual Docker build-context root.

Exclude content not used by the image build, such as:

- source code when the Dockerfile consumes only a prebuilt artefact;
- unrelated build output;
- Maven wrapper and metadata not used inside the Dockerfile;
- IDE files;
- VCS metadata;
- local logs and temporary files.

When excluding a generated-output directory, explicitly re-include every required runtime artefact.

Example pattern only:

```dockerignore
src/
target/**
!target/
!target/<application-artifact>
!target/dependencies/
!target/dependencies/<runtime-agent>
.mvn/
pom.xml
```

Do not copy these paths blindly. Docker ignore paths are relative to the build context, and required files vary by repository.

Verify the context by building the image. A narrow context that excludes a required file is a failed implementation.

Do not claim that context reduction reduces final image size unless the image contents actually change. Do not compare a content-store message with a full CI network-transfer metric as though they were identical.

---

## 20. Docker Layer Ordering and Runtime Preservation

Inspect Dockerfile layer invalidation.

Move expensive stable work before frequently changing application artefacts where semantics allow:

```text
base image
OS packages and trusted tools
runtime user creation
stable permissions/directories
application JAR or binary
runtime agent
artefact-specific permissions
entry command
```

The goal is for an application-code change to invalidate only artefact-related layers, not OS package installation or stable tooling.

Preserve:

- base image unless a separate upgrade is explicitly required;
- non-root runtime user;
- file ownership and executable permissions;
- runtime agent;
- entry command;
- exposed ports and health behaviour;
- required certificates and system packages.

For externally downloaded tools:

- follow redirects and fail on HTTP errors;
- pin the intended version;
- verify a trusted checksum when available;
- extract only after verification;
- remove downloaded archives and package-manager caches.

Measure at least these controlled Docker cases when possible:

1. cold build;
2. warm no-change rebuild;
3. warm rebuild after a real application artefact change.

The warm artefact-change case is the primary layer-order evidence. Label it as a controlled Docker measurement, not end-to-end CI saving.

---

## 21. BuildKit and Registry Cache Strategy

Inspect the runner's builder and cache lifecycle before changing commands.

Determine:

- whether `docker buildx` exists;
- which builder is currently selected;
- whether the Docker daemon persists during a pipeline;
- whether runners are clean between pipelines;
- approved cache registry location;
- authentication and write permissions;
- branch naming constraints;
- architecture/platform differences;
- whether cache writes from feature branches may pollute the shared cache.

Prefer a strategy with:

- stable shared-cache reads;
- writes to the shared cache only from the primary integration branch when appropriate;
- isolated branch-cache writes for independent development work;
- shared plus isolated reads for branch builds;
- sanitised cache tags;
- exact image loading for subsequent local validation;
- a tested fallback when buildx is unavailable.

Conceptual pattern:

```text
primary branch:
    read shared cache
    write shared cache

feature branch:
    read shared cache
    read branch-isolated cache
    write branch-isolated cache only
```

Do not create a custom docker-container builder merely because it supports advanced cache export. Compare it with the default builder in the actual environment. Retain the simplest reproducibly faster compatible path.

After image build:

- ensure the exact expected tag exists;
- load it into the daemon if later steps require local access;
- inspect the image and fail immediately if missing.

Do not claim registry-cache benefit separately unless it was isolated in measurement.

---

## 22. Pipeline Graph Optimisation

After correctness architecture is established, minimise unnecessary serial dependencies.

Candidates that may run immediately after secrets/setup include:

- Docker readiness;
- build/adaptor metadata extraction;
- vulnerability database preparation;
- other read-only metadata preparation.

Preserve sequential correctness gates:

```text
Build/Test succeeds
        -> exact image build succeeds
        -> exact-image runtime validation succeeds
        -> final security scan succeeds according to existing policy
```

The final scan may additionally depend on a parallel scanner-database-preparation step.

Do not serialise preparation unnecessarily. Moving a 30-second preparation step earlier but placing it directly before a three-minute build does not reduce the critical path.

Verify workspace and daemon-sharing assumptions. Files placed in a container's home directory may not survive into another CI step. Use explicit shared-workspace paths.

Preserve unrelated publication, quality and deployment dependencies.

After editing the pipeline source, inspect the generated graph or rendered CI configuration where tooling permits. Check for cycles, missing step names and accidental serialization.

---

## 23. Metadata Extraction Optimisation

Inspect scripts that call Maven repeatedly to extract project properties.

If several independent `help:evaluate` calls start separate Maven processes, evaluate them in one non-recursive invocation and split the returned values safely.

Requirements:

- preserve exact property order;
- preserve missing-value fallback behaviour;
- avoid shell features unavailable in the step image;
- do not expose secrets;
- fail or degrade exactly as the original contract requires;
- run after only the dependencies actually needed, not after Docker readiness if Docker is irrelevant.

Do not implement this optimisation when properties require different reactors, profiles or evaluation contexts.

Measure the visible step separately, and do not claim the entire difference as end-to-end saving if it overlaps other work.

---

## 24. Security Scanner Database Preparation

Inspect the exact scanner and version used by the target pipeline.

For Trivy, inspect `trivy --help` and `trivy image --help` for the installed version before selecting commands.

If the final scan downloads vulnerability and language databases on its critical path, create the smallest possible early preparation step.

The preparation step should:

- start after required secrets or registry setup;
- not wait for Build/Test unless technically necessary;
- use the same scanner version as the final scan;
- use the same approved vulnerability DB repository;
- use the same approved Java/language DB repository;
- use an explicit cache directory inside the shared CI workspace;
- prepare every database needed by the final scan;
- fail if required preparation fails;
- avoid concurrent writes to the same cache unless the scanner explicitly supports them.

The final scan should:

- depend on both exact-image runtime validation and successful database preparation;
- use the same explicit cache directory;
- scan the exact image produced by the pipeline;
- retain vulnerability scanning;
- retain secret scanning;
- retain severity filters;
- retain ignore-unfixed behaviour;
- retain database repositories;
- retain exit-code policy;
- retain reporting output.

Do not use skip-update flags unless the same-pipeline preparation step has already refreshed the database, the final scan cannot run without that step, and the scanner version requires the flag for cache reuse. Prefer normal cache metadata reuse when supported.

Verify from logs that the final scan does not download the same databases again. If it redownloads them, the implementation is not working. Investigate:

- wrong cache path;
- cache stored outside shared workspace;
- different user/home directory;
- incompatible scanner versions;
- different database repositories;
- cache metadata mismatch;
- preparation and final steps using different filesystems.

Do not say “Trivy became faster” when only database preparation moved. The accurate claim is that database preparation moved off the final critical path and the final scan reused the prepared cache.

---

## 25. Experiments to Treat Skeptically

The SNS pilot did not retain the following experiments because they produced no reproducible benefit or changed semantics:

- Maven `-T` parallel build;
- background image prefetch;
- logging reduction as a performance technique;
- readiness-result caching.

Do not automatically prohibit them in every repository, but require target-specific evidence before keeping them.

For every optional experiment:

1. make one isolated change;
2. run comparable measurements;
3. check correctness and failure semantics;
4. keep it only if the benefit is reproducible;
5. revert only the experiment's own changes if it fails;
6. preserve all unrelated user work.

Avoid speculative complexity that cannot be tied to a measured bottleneck.

---

## 26. Recommended Implementation Order

Use this order unless repository evidence requires another sequence.

### Stage A — Discovery and safety baseline

- inspect worktree and instructions;
- reconstruct pipeline graph;
- inventory validations and counts;
- collect baseline evidence;
- identify generated configuration sources;
- run current focused tests where practical.

Do not edit before this stage is complete.

### Stage B — Low-risk Docker/build improvements

- focused `.dockerignore`;
- stable Docker layer ordering;
- trusted tool download verification;
- remove proven duplicate Maven preparation;
- collapse repeated metadata extraction where safe.

Verify image build and runtime parity.

### Stage C — Test lifecycle consolidation

- implement target-specific Testcontainers environment if appropriate;
- inject dynamic endpoints;
- preserve business scenarios;
- add Docker and zero-test hard failures;
- add scenario/feature guardrails;
- implement bounded readiness, diagnostics and cleanup;
- fix polling unit or duplicate-consumer issues found during inspection;
- start independent services/readiness checks concurrently.

Run focused integration tests before changing the CI graph.

### Stage D — Packaged-runtime separation and Maven reuse

- build the exact deployment image;
- add or preserve focused exact-image runtime validation;
- make verified Maven outputs available pipeline-locally;
- eliminate proven upstream rebuild duplication;
- retain fail-if-no-test safeguards.

### Stage E — CI graph and cache strategy

- replace obsolete Compose/helper-container steps only after test-owned coverage is proven;
- overlap Docker readiness, metadata extraction and scanner preparation;
- preserve Build/Test -> image -> runtime-validation ordering;
- configure safe BuildKit/registry cache use;
- move scanner DB preparation off the final path;
- preserve final security scan policy.

### Stage F — Full verification and measurement

- run local/focused tests;
- render or validate pipeline configuration;
- run full CI at least twice when authorised and available;
- inspect final scanner logs and test counts;
- compare successful end-to-end wall-clock results;
- remove failed experiments and temporary files;
- inspect final diff and status.

Do not delete old Compose resources merely because CI no longer uses them. First search for local-development, smoke-test, deployment or other consumers. Remove only resources proven obsolete and in scope.

---

## 27. Verification Requirements

Run the strongest safe verification available for the target repository.

At minimum:

### Static and diff checks

```text
git status --short
git diff --check
inspect complete diff
search for accidentally changed test filters
search for zero-test/skip behaviour
search for hard-coded SNS values
validate generated CI configuration if applicable
```

### Build/test checks

- compile affected modules;
- run unit tests for changed lifecycle utilities;
- run the full business/integration profile when Docker is available;
- confirm the expected business scenario count;
- run the focused exact-image runtime profile;
- build and inspect the exact Docker image;
- confirm Docker-unavailable CI mode fails rather than skips;
- confirm a missing explicitly selected runtime test would fail;
- confirm readiness failure and early container exit produce failure and logs.

### Pipeline checks

- Build/Test cannot run before required secrets and Docker readiness;
- image build cannot run before Build/Test succeeds;
- runtime validation cannot run before image build succeeds;
- final scan cannot run before runtime validation succeeds;
- final scan cannot run before scanner DB preparation succeeds;
- scanner DB preparation overlaps useful work;
- metadata extraction does not wait for unrelated Docker readiness;
- exact image exists in the daemon/registry visible to runtime validation;
- shared cache paths resolve inside the actual workspace.

### Security checks

- same target image;
- same scanner version unless an upgrade was separately required;
- same scanners enabled;
- same severity policy;
- same ignore-unfixed behaviour;
- same exit-code policy;
- same approved DB repositories;
- both vulnerability and language databases available;
- final scan reuses prepared DB cache;
- no credentials printed.

If a check cannot be run, state `NOT RUN` and the concrete reason. Do not describe an unexecuted check as passed.

---

## 28. Measurement Plan

Separate evidence into four classes:

1. **Direct measurement** — comparable before/after timing for one specific change.
2. **Observed system effect** — a step/system difference with multiple possible contributors.
3. **Structural improvement** — work or dependencies demonstrably removed, without isolated timing.
4. **Correctness improvement** — incorrect or false-green behaviour fixed, without a performance claim.

For full CI, record:

```text
baseline sample size
baseline average
baseline median
baseline fastest and slowest
optimised successful run 1
optimised successful run 2
additional optimised runs if available
best observed comparison
```

For supporting observations, record only applicable values:

```text
Build/Test duration
image-build duration
exact-image runtime-validation duration
metadata extraction duration
scanner DB preparation duration
final scan duration
Docker cold build
Docker warm no-change build
Docker warm artefact-change rebuild
observed shutdown tail
```

Evidence rules:

- successful-run baseline and optimised sample sizes must be explicit;
- visible overlapping steps must not be summed;
- component savings must not be added to explain total saving;
- controlled Docker measurements must be labelled as controlled;
- local and CI observations must not be conflated;
- runner, network, registry and cache variability must be acknowledged;
- best observed performance must not be presented as guaranteed;
- structural changes without isolated timings must remain unquantified;
- a disappeared tail should be described as “no longer observed in representative post-fix runs”, not “permanently removed”.

---

## 29. Keep/Revert Criteria

Keep the complete implementation only if:

- intended business scenarios still execute;
- test selection cannot silently become empty;
- Docker-required CI behaviour fails hard when unavailable;
- required dependencies and prerequisites fail loudly;
- exact built-image validation remains or is added where required;
- security scan coverage and policy are unchanged;
- scanner cache reuse is real;
- independent preparation genuinely overlaps useful work;
- duplicated work is proven redundant before removal;
- runtime cleanup is bounded and deterministic;
- failure diagnostics remain useful;
- local tests and/or CI checks pass at the strongest available level;
- the final graph has no accidental serialization or missing dependency;
- the implementation is simpler or operationally clearer than the previous path;
- any performance claim is supported by matching evidence.

Revert or redesign the affected experiment if:

- fewer scenarios or tests execute;
- a missing Docker daemon produces success in CI;
- a selected test can disappear without failure;
- the image tested is not the image built;
- security scanning or policy changes unintentionally;
- scanner databases download again in the final step;
- preparation serialises the pipeline;
- registry-cache writes are unsafe or cross-contaminate branches;
- Testcontainers cleanup leaks resources;
- readiness semantics weaken;
- the change creates intermittent failures;
- repeated measurement shows no benefit and the change adds complexity.

When reverting, revert only changes introduced by the failed experiment. Never discard unrelated worktree changes.

---

## 30. SNS-specific Details That Must Be Rediscovered

The following values from the SNS reference implementation must not be copied without target-repository evidence:

- module names and Maven coordinates;
- executable JAR name;
- OpenTelemetry agent path;
- Docker image tag;
- Docker build context;
- Java version;
- Testcontainers version;
- Docker API version;
- DIND hostname and port;
- Ryuk configuration;
- registry hostname and authentication method;
- BuildKit cache repository and branch rules;
- vulnerability and Java DB repositories;
- Trivy version and supported flags;
- feature-file count;
- business-scenario count;
- Cucumber tags;
- JUnit coverage guards;
- service and aggregate image names;
- Kafka/ZooKeeper/KRaft architecture;
- topic names and topic count;
- consumer group IDs;
- Schema Registry subjects;
- Redis/database configuration;
- application property names;
- readiness paths;
- application and management ports;
- startup and shutdown timeouts;
- publication and deployment dependencies.

Derive every value from the target repository, its current CI configuration and approved platform policy.

---

## 31. Final Diff Hygiene

Before finishing:

1. inspect `git status --short`;
2. inspect the complete diff;
3. run `git diff --check`;
4. confirm no credentials or generated cache content are present;
5. confirm no temporary scripts, benchmark outputs or log dumps were added;
6. confirm existing user changes were preserved;
7. confirm deleted Compose/helper files have no remaining consumers;
8. confirm all new files are necessary implementation files;
9. confirm pipeline step names and dependencies match exactly;
10. confirm all comments describe current behaviour rather than historical experiments.

Do not add a report, migration document, timing spreadsheet, presentation, TODO file or patch export unless the user explicitly requests one.

---

## 32. Definition of Done

The task is complete only when all applicable statements are true:

- current pipeline architecture was inspected before editing;
- baseline evidence and its limits are understood;
- validation inventory is explicit;
- target-specific values replaced all reference placeholders;
- applicable implementation work is complete;
- business-test coverage is retained;
- false-green protections are active;
- exact built-image validation is retained where required;
- Docker context and layers are safe and verified;
- Maven outputs are reused only after verification;
- independent CI preparation overlaps where possible;
- security scanning and policy remain unchanged;
- scanner DB cache reuse is verified when implemented;
- cleanup and diagnostics are deterministic;
- focused tests pass;
- full CI was run when authorised and available, otherwise clearly marked not run;
- unsuccessful experiments were removed;
- final diff contains no unrelated or generated content.

Do not claim completion if a required test or correctness gate is still knowingly broken.

---

## 33. Required Final Response

Return a concise implementation handoff in chat/terminal only. Do not create another file.

Use this structure:

```text
Outcome
- Overall result and whether implementation is complete.

Architecture
- Previous execution/lifecycle problem.
- Final execution shape.
- Independent work now running in parallel.
- Sequential correctness gates retained.

Validation preserved
- Business scenarios: expected / executed.
- Docker-required failure: PASS / FAIL / NOT RUN.
- Zero-test protection: PASS / FAIL / NOT RUN.
- Exact built-image validation: PASS / FAIL / NOT APPLICABLE.
- Vulnerability scanning retained: YES / NO.
- Secret scanning retained: YES / NO.
- Security policy changed: YES / NO.

Verification
- Commands/checks run and results.
- Full CI run IDs or NOT RUN with reason.
- Scanner DB redownload in final scan: YES / NO / NOT RUN.

Measurements
- Baseline sample and wall-clock result.
- Optimised runs.
- Direct measurements.
- Structural/correctness changes without timing claims.
- Explicit evidence limitations.

Files changed
- Each changed file and one-line responsibility.

Not retained / not applicable
- Experiments reverted.
- SNS patterns intentionally not applied and why.

Remaining risk
- Only concrete unresolved risks or “None identified”.
```

Keep the handoff factual. Do not include self-congratulation, invented savings or claims unsupported by the target repository's evidence.

