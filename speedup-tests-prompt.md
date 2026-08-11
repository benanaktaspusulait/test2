Implement a comprehensive test and CI speed optimisation for the SNS repository.

This is an IMPLEMENTATION task.

Do not create:
- reports
- markdown documents
- proposal files
- benchmark files
- TODO files
- analysis artefacts
- temporary scripts that remain in the final diff

Work directly in the existing source, Maven configuration and CI pipeline.

The objective is:

    make the SNS test/build pipeline as fast as reasonably possible

while preserving:

    test correctness
    all existing business scenarios
    coverage
    failure visibility
    Testcontainers protections
    built-image validation
    security scanning

Do not optimise by simply removing validation.

======================================================================
0. PROTECT THE CURRENT WORKING STATE
   ======================================================================

The repository already contains important Container/CI optimisation work.

Do NOT break or remove:

- .dockerignore optimisation
- final Dockerfile layer ordering
- BuildKit / registry cache behaviour
- Testcontainers-based integration environment
- Redis
- Kafka
- Schema Registry
- downstream aggregate Testcontainers
- dynamic topic suffix/isolation
- real Cucumber business suite
- expected scenario protection
- completed scenario protection
- TestcontainersSuiteCoverageTest
- Docker availability / false-green protection
- strict testId correlation
- validateSchemaRegistryRoundTrip()
- TestcontainersFailureDiagnostics
- BuiltImageRuntimeIntegrationTest
- built-image runtime readiness validation
- Trivy
- JaCoCo / coverage gates
- legacy compose fallback resources where still intentionally retained

Do not weaken assertions to gain speed.

Do not allow:

    Tests run: 0
    skipped business suite
    Docker unavailable -> green build

======================================================================
1. KEEP AND COMPLETE CURRENT LOW-RISK OPTIMISATIONS
   ======================================================================

Keep the current safe changes:

A. Cucumber output

Remove the Cucumber:

    pretty

plugin.

Keep:

    summary
    SnsSteps
    HTML report

Do not change scenario selection.

--------------------------------------------------

B. Kafka polling Duration correctness

Keep:

    INITIAL_POLL_DURATION =
        Duration.ofMillis(INITIAL_POLL_DURATION_MS)

    POLL_DURATION =
        Duration.ofMillis(POLL_DURATION_MS)

The values named *_MS must be interpreted as milliseconds.

Do NOT reintroduce:

    Duration.ofSeconds(POLL_DURATION_MS)

This is a correctness fix.

--------------------------------------------------

C. Remove useless calls

Keep removal of:

    kafkaConsumer.assignment();

where its result is not used.

Search the touched test code for similar obvious no-op calls.

Remove only when behaviour is unquestionably unchanged.

--------------------------------------------------

D. Logging

Change high-frequency successful polling/retry logging from INFO to DEBUG.

Examples:

- poll attempt
- current record count
- per-record successful correlation diagnostics
- repeated readiness attempts

Keep:

- failures
- warnings
- final timeout information
- container diagnostics
- useful suite summaries

at appropriate visible levels.

Do not hide failure information.

--------------------------------------------------

E. HTTP client reuse

Reuse immutable HttpClient instances where the same test class/environment
currently creates them repeatedly.

Use constants for immutable timeout Durations.

Keep the built-image runtime readiness maximum timeout unchanged.

The current:

    120 second readiness deadline

must remain unless there is strong correctness evidence to change it.

A 500 ms polling interval is acceptable.

======================================================================
2. AUDIT ALL WAITING AND POLLING CODE
   ======================================================================

Search the entire SNS repository, especially test code, for:

    Thread.sleep
    Duration.ofSeconds
    Duration.ofMillis
    poll(
    await
    retry
    maxAttempts
    timeout
    readiness
    health
    MAX_RETRIES
    POLL_DURATION
    WAIT_

Inspect every test-side waiting loop.

Fix:

- milliseconds interpreted as seconds
- unnecessarily long fixed sleeps
- polling after success
- duplicate readiness checks
- redundant first polls
- unnecessarily slow retry intervals
- loops whose timeout is much larger than intended because of unit errors

Do NOT simply shorten legitimate functional timeouts.

Prefer:

    bounded frequent polling

over:

    large fixed sleeps

where correctness is equivalent.

======================================================================
3. OPTIMISE KAFKA TEST POLLING
   ======================================================================

Inspect all Kafka consumers used by tests.

Optimise:

- initial assignment polling
- consumer poll duration
- record collection loops
- repeated empty polling
- batch processing
- consumer group setup

Where appropriate:

- reuse Duration objects
- break immediately when expected records are found
- avoid scanning records after the expected result is satisfied
- avoid unnecessary consumer recreation
- reduce logging in successful loops

Inspect:

    max.poll.records

and related test consumer settings.

If scenarios commonly expect several records, use a sensible batch size so
multiple records can be collected in one poll.

Do not introduce a value without understanding the expected scenario sizes.

Preserve strict testId/correlation filtering.

======================================================================
4. CACHE IMMUTABLE TEST CONFIGURATION AND RESOURCES
   ======================================================================

Inspect test code for repeated reads of:

- configuration.properties
- feature support files
- JSON templates
- Avro templates
- immutable test metadata
- ObjectMapper construction
- HTTP clients
- immutable Properties/config maps
- classpath resources

If the same immutable resource is repeatedly loaded for multiple scenarios,
cache it safely at class/suite level.

Do NOT cache mutable scenario state.

Do NOT create shared mutable state that makes parallel execution unsafe.

======================================================================
5. SPRING APPLICATION / CONTEXT REUSE
   ======================================================================

Inspect the Testcontainers integration path and normal application tests.

Ensure the SNS application is started only once per intended integration suite.

Avoid:

- repeated SpringApplicationBuilder startup
- repeated application context creation
- repeated infrastructure bootstrap
- repeated topic setup

unless isolation requires it.

Preserve clean shutdown.

Do not restart the application between scenarios if the existing suite can
safely share one runtime.

======================================================================
6. TESTCONTAINERS INFRASTRUCTURE STARTUP
   ======================================================================

Optimise Testcontainers startup.

Current infrastructure contains relationships such as:

    Redis
    ZooKeeper
    Kafka
    Schema Registry

and snapshot runs contain aggregate containers:

    party
    object
    location
    event
    service

Do not start independent containers sequentially without reason.

Analyse dependencies carefully.

For example:

- Redis and ZooKeeper may be started concurrently if independent.
- Kafka must wait for ZooKeeper if this image/config still requires it.
- Schema Registry must wait for Kafka.
- Aggregate services should only start after their required Kafka/Redis/
  Schema Registry infrastructure is available.

Use Testcontainers dependency-aware parallel startup where suitable.

Consider:

    Startables.deepStart(...)

or equivalent Testcontainers-supported concurrent startup.

Do NOT create race conditions.

======================================================================
7. PARALLELISE DOWNSTREAM AGGREGATE STARTUP
   ======================================================================

The five aggregate containers are currently a high-value optimisation target
if they are started in sequence.

Current anti-pattern to remove when safe:

    start party
    wait party
    start object
    wait object
    start location
    wait location
    start event
    wait event
    start service
    wait service

If these services do not require each other to become ready during startup,
start them concurrently after their shared dependencies are ready.

Then perform readiness validation for all of them.

Use a bounded overall timeout.

If there are actual inter-aggregate startup dependencies, preserve only those
dependencies and parallelise the independent subset.

Do not assume dependency order: inspect configuration and test behaviour.

This optimisation must preserve snapshot scenario behaviour.

======================================================================
8. AVOID DUPLICATE READINESS WORK
   ======================================================================

Readiness should not be repeated unnecessarily.

Where readiness is valid for the entire suite:

    verify once
    remember that the service is ready
    avoid repeating the same health wait for every scenario

Do not cache readiness across an actual restart.

Apply this to:

- SNS application
- aggregate services
- Testcontainers infrastructure

where safe.

======================================================================
9. MAVEN REACTOR PARALLELISM
   ======================================================================

Evaluate and implement Maven reactor parallelism.

Candidate:

    mvn -T 1C clean verify -Pci-testcontainers-snapshot

Compare against:

    mvn clean verify -Pci-testcontainers-snapshot

Use the same source state.

Run comparable successful executions.

Keep Maven -T 1C if it gives a meaningful repeatable improvement without:

- CPU starvation
- memory pressure
- Testcontainers instability
- intermittent Maven failures
- test ordering problems

If 1C is too aggressive, evaluate a conservative fixed value such as:

    -T 2

Do not increase concurrency blindly.

Select the fastest stable setting.

Do not add -T to the built-image runtime smoke automatically.

The runtime smoke is dominated by container/application startup and should
remain non-parallel unless independent measurement proves Maven reactor
parallelism materially improves it.

======================================================================
10. SUREFIRE / FAILSAFE OPTIMISATION
    ======================================================================

Inspect root and module POMs.

Determine exactly which tests are executed by:

    Surefire
    Failsafe

Ensure tests are not executed twice.

Inspect:

- includes
- excludes
- IntegrationTest patterns
- test phases
- verify/integration-test bindings

Remove duplicate test execution if present.

Evaluate:

    forkCount
    reuseForks

for materially expensive suites.

Use conservative values first.

Example candidate:

    forkCount = 2
    reuseForks = true

Preserve JaCoCo compatibility.

If argLine is configured, use JaCoCo-safe composition such as:

    @{argLine}

Do not break coverage instrumentation.

======================================================================
11. CUCUMBER RUNNER PARALLELISM
    ======================================================================

The current real integration suite uses one Cucumber runner.

Inspect all feature files and scenario tags.

If test execution itself remains a material cost after infrastructure
optimisation, split the suite into balanced runner groups.

Possible grouping dimensions:

- command scenarios
- snapshot scenarios
- logical feature groups
- approximately equal observed execution time

Do NOT duplicate scenarios.

The original catch-all runner must not execute the same features in addition
to new grouped runners.

Every non-ignored business scenario must execute exactly once.

Preserve:

    expected scenario count
    coverage guard
    testId isolation
    unique consumer groups
    dynamic topic suffix

Start with 2 groups/forks.

Increase only when stable and beneficial.

======================================================================
12. HANDLE STATIC MUTABLE STATE BEFORE TEST PARALLELISM
    ======================================================================

Before enabling same-process or multi-runner concurrency, inspect:

    static mutable fields

in:

- SnsSteps
- integration step classes
- helper classes
- scenario data holders

Classify each static field:

1. immutable suite configuration
2. shared infrastructure
3. mutable scenario state

Do not parallelise mutable scenario state unsafely.

Where required, convert scenario-specific state to:

- instance fields
- scenario scoped state
- ThreadLocal only where technically justified

Do not perform unnecessary architectural refactoring.

Fix only what is required to make selected parallelism safe.

======================================================================
13. JVM TEST PROCESS TUNING
    ======================================================================

If Maven/Surefire/Failsafe forks are retained, evaluate conservative
short-lived JVM optimisation settings.

Candidates include:

    -XX:TieredStopAtLevel=1

and a suitable GC for short-lived test JVMs.

Do not add JVM flags blindly.

Keep only settings that improve wall-clock without introducing instability.

Do not alter production JVM settings.

======================================================================
14. JUNIT 5 / CUCUMBER PLATFORM PARALLEL EXECUTION
    ======================================================================

Evaluate JUnit Platform / Cucumber JUnit 5 parallel execution as a deeper
optimisation.

This is an implementation experiment, not documentation work.

Do not keep both competing concurrency models for the same suite.

Compare:

A. JUnit4 Cucumber runners + Failsafe forks

versus

B. Cucumber JUnit Platform Engine same-JVM parallelism

Only migrate if JUnit5:

- executes every business scenario exactly once
- preserves all assertions
- preserves hooks/plugins/reports
- preserves Testcontainers lifecycle
- preserves scenario isolation
- produces a meaningful additional wall-clock improvement
- does not introduce flaky shared-state behaviour

If JUnit5 is not clearly better, revert the experiment completely.

Do not leave migration scaffolding behind.

======================================================================
15. CI PARALLEL EXECUTION / MATRIX
    ======================================================================

Evaluate whether independent test groups can run as separate Drone steps.

Candidate architecture:

    build/common prerequisites
             |
      -----------------
      |               |
runner group A   runner group B
|               |
-----------------
|
final validation

Only use a CI matrix/separate steps if it improves total pipeline wall-clock
more than Maven/Failsafe forks and does not duplicate expensive Testcontainers
infrastructure unnecessarily.

Do not combine CI sharding and JVM fork sharding just because both are
available.

Test competing models and keep the fastest stable architecture.

======================================================================
16. BUILT-IMAGE RUNTIME TEST OPTIMISATION
    ======================================================================

Keep:

    BuiltImageRuntimeIntegrationTest

Do not remove functionality from it.

Optimise only overhead:

- shared HttpClient
- reusable Duration
- 500 ms readiness polling
- immediate exit after readiness succeeds
- avoid duplicate startup checks
- avoid duplicate Maven work if it is provably unnecessary

Do not add Maven -T here unless separately proven useful.

Do not shorten the 120 second maximum readiness protection merely for speed.

======================================================================
17. DO NOT REBUILD THINGS TWICE
    ======================================================================

Inspect the complete CI flow for duplicate work.

Look for repeated:

- Maven clean/package/install
- dependency compilation
- integration module compilation
- application JAR creation
- Docker image build
- container image preparation
- Avro generation

Reuse already-created outputs where safe.

Do not bypass correctness or create stale-artifact risk.

The final pipeline should avoid rebuilding the same deterministic artefact
multiple times without a technical reason.

======================================================================
18. JACOCO
    ======================================================================

Keep CI JaCoCo coverage enabled.

Do NOT remove coverage for pipeline speed.

Ensure any Surefire/Failsafe fork changes preserve JaCoCo instrumentation.

Local-only skip options may remain if already supported, but CI coverage must
stay active.

======================================================================
19. REMOVE EXPERIMENTS THAT LOSE
    ======================================================================

During this task you may temporarily test multiple approaches.

That is expected.

But the final Git diff must contain only the winning implementation.

If an experiment is rejected, completely remove:

- temporary classes
- runner classes
- POM properties
- temporary profiles
- CI steps
- scripts
- timing helpers
- debug-only source changes
- comments describing rejected approaches

Do not leave disabled experiments in the repository.

======================================================================
20. PERFORMANCE DECISION RULE
    ======================================================================

For compatible optimisations:

    combine them.

For mutually exclusive approaches:

    test both and keep the better one.

Examples of potentially competing strategies:

    Failsafe forks
    vs
    CI runner matrix
    vs
    JUnit5 same-JVM parallelism

Do NOT stack all three automatically.

Use the fastest stable model.

Performance decisions must be based on wall-clock behaviour of successful
runs, not theoretical expectations.

Do not introduce hard CI performance failure thresholds.

Timing may be printed temporarily or to terminal output, but do not make
pipeline success depend on arbitrary duration limits.

======================================================================
21. REQUIRED PARITY
    ======================================================================

After every retained major optimisation verify:

- BUILD SUCCESS
- complete Maven reactor
- real uk.gov.ho.dacc.fdp.IntegrationTest or its final legitimate replacement
- all non-ignored business scenarios execute exactly once
- expected scenario count preserved
- TestcontainersSuiteCoverageTest passes
- failures = 0
- errors = 0
- no unexpected skipped business tests
- Docker/Testcontainers genuinely executed
- Kafka/Schema Registry functional path works
- aggregate snapshot scenarios work
- strict testId correlation remains
- JaCoCo remains active
- failure diagnostics remain available

A green build with zero real business scenarios is a FAILURE.

======================================================================
22. RUN THE PIPELINE MULTIPLE TIMES
    ======================================================================

After selecting the final combination, run the final main suite at least twice
if the environment allows.

Use the final exact command selected for CI.

Check for:

- timing consistency
- flakes
- container startup races
- Kafka timing problems
- scenario ordering issues
- resource contention

Do not accept an optimisation that is fast only once but unstable.

======================================================================
23. FINAL BUILT-IMAGE VALIDATION
    ======================================================================

Run the final built-image runtime path using the exact final image:

    docker-compose-command-adaptor:latest

and the normal non-parallel runtime command unless measurement explicitly
proved otherwise:

    mvn -pl cmd-adaptor-sns-integration-tests -am verify \
      -Pci-built-image-runtime-smoke \
      -Dsns.runtime.image=docker-compose-command-adaptor:latest

Confirm:

    BuiltImageRuntimeIntegrationTest
    Tests run: 1
    Failures: 0
    Errors: 0
    Skipped: 0

======================================================================
24. FINAL DIFF CLEANUP
    ======================================================================

Inspect:

    git status
    git diff

The final diff must contain only test/CI speed improvements required by the
winning solution.

Do not perform unrelated production refactoring.

Do not modify business behaviour.

Do not modify feature semantics solely to make parallelisation easier.

Do not weaken assertions.

Do not create documentation.

======================================================================
25. EXPECTED FINAL OUTCOME
    ======================================================================

The final implementation should contain as many compatible optimisations as
prove technically sound, including where beneficial:

- timing-unit correctness fixes
- faster Kafka polling
- reduced successful-loop logging
- cached immutable config/resources
- shared HttpClient/Duration objects
- reduced duplicate readiness
- Spring/application reuse
- Testcontainers lifecycle reuse
- dependency-aware parallel infrastructure startup
- parallel aggregate startup
- Maven reactor parallelism
- duplicate Maven/test execution removal
- Surefire/Failsafe tuning
- safe Cucumber runner parallelisation
- necessary static-state isolation
- conservative test JVM tuning
- CI-level parallelism if it beats JVM forks
- JUnit5 parallel execution only if it beats the alternatives
- no duplicate build work
- unchanged coverage and validation protections

Do not stop after implementing only the obvious quick wins.

Inspect the whole repository and pursue the remaining material test/CI
bottlenecks until there is no further technically justified optimisation in
the above scope.

======================================================================
FINAL RESPONSE
======================================================================

Do not create a report file.

Reply only in terminal/chat with a concise final summary containing:

- final main Maven command
- final concurrency model
- Testcontainers startup changes
- aggregate startup model
- Kafka/polling changes
- config/context reuse changes
- Cucumber execution model
- Maven/Surefire/Failsafe changes
- rejected competing approaches
- before/after successful wall-clock observations
- scenario count
- failures/errors/skips
- coverage status
- built-image runtime result
- final files changed
- blocker: none / exact blocker

Maximum 25 lines.