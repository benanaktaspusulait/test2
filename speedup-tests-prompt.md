Verify and complete ONLY the remaining SNS test-speed optimisation concerns.

This is a focused implementation/verification task.

Do NOT:
- create reports
- create markdown files
- create TODO files
- refactor unrelated code
- touch feature files
- change business assertions
- change Docker/image optimisation
- introduce new test execution models
- introduce JUnit 5
- introduce Cucumber runner splitting
- introduce CI matrix/sharding

Preserve the current working test-speed changes.

======================================================================
1. VERIFY CURRENT TESTCONTAINERS STARTUP IMPLEMENTATION
   ======================================================================

Inspect the CURRENT source of:

    cmd-adaptor-sns-integration-tests/src/test/java/uk/gov/ho/dacc/fdp/testcontainers/SnsTestcontainersEnvironment.java

Do NOT rely on git history, old patches, previous commits, or assumptions.

Inspect the exact current implementations of:

    startInfrastructure()
    startAggregators()

Required final behaviour:

BASE INFRASTRUCTURE

- REDIS and ZOOKEEPER are independent and should start concurrently if the
  current configuration confirms there is no dependency between them.

- KAFKA must start only after ZooKeeper is available.

- SCHEMA_REGISTRY must start only after Kafka is available.

Prefer Testcontainers-native concurrent startup, for example:

    Startables.deepStart(...).join()

Do not introduce a custom ExecutorService if Testcontainers-native startup
already solves the problem.

Do not:
- change images
- change Kafka configuration
- change network aliases
- change startup timeouts
- remove ZooKeeper
- migrate to KRaft

--------------------------------------------------

AGGREGATE CONTAINERS

Inspect:

    AGGREGATE_PARTY
    AGGREGATE_OBJECT
    AGGREGATE_LOCATION
    AGGREGATE_EVENT
    AGGREGATE_SERVICE

Verify whether they have any real startup dependency on each other.

If they only depend on shared infrastructure such as Kafka, Schema Registry
and Redis, all five containers must start concurrently.

Preferred shape:

    Startables.deepStart(Stream.of(
        AGGREGATE_PARTY,
        AGGREGATE_OBJECT,
        AGGREGATE_LOCATION,
        AGGREGATE_EVENT,
        AGGREGATE_SERVICE
    )).join();

or equivalent Testcontainers-native logic.

Do not preserve artificial sequential startup such as:

    start party -> wait
    start object -> wait
    start location -> wait
    start event -> wait
    start service -> wait

if there is no actual dependency requiring it.

======================================================================
2. VERIFY AGGREGATE FUNCTIONAL READINESS
   ======================================================================

Concurrent container startup is not sufficient.

After all five aggregate containers start, all five must still pass their
existing functional HTTP readiness checks.

startAggregators() must return only after ALL aggregates are ready.

Preserve:

- existing profile readiness path
- actuator fallback path
- HTTP_REQUEST_TIMEOUT
- READINESS_POLL_INTERVAL_MS
- approximately 120 seconds maximum readiness allowance
- failure propagation
- interruption handling
- Testcontainers diagnostics

Set:

    aggregatorsStarted = true

ONLY after:

    all five containers started successfully
    AND
    all five functional readiness checks succeeded.

If readiness checks are currently sequential and are independent, they may be
executed concurrently using a simple bounded mechanism such as
CompletableFuture.

Do not leave persistent thread pools behind.

If one readiness check fails, fail the whole aggregate startup.

======================================================================
3. DO NOT MODIFY CONCURRENCY IF IT ALREADY EXISTS
   ======================================================================

If the current source already has:

- concurrent Redis/ZooKeeper startup
- correct Kafka/ZooKeeper dependency
- correct Schema Registry/Kafka dependency
- concurrent five-aggregate startup
- all-five readiness protection

DO NOT rewrite or refactor it.

Only report that the current implementation already satisfies the requirement.

Avoid meaningless source churn.

======================================================================
4. REVIEW dependency:go-offline REMOVAL
   ======================================================================

Inspect the current .drone.star change that removes:

    mvn -B dependency:go-offline

after:

    mvn clean install

Do not assume this command is redundant.

Inspect:

- the full surrounding Drone step
- downstream steps
- whether a later command uses Maven offline mode
- whether this step intentionally primes dependency/plugin resolution
- whether this is cache preparation for another pipeline phase

Decision rule:

If there is NO concrete downstream requirement for dependency:go-offline and
mvn clean install already resolves everything required by that pipeline path:

    keep it removed

If its purpose is required for:
- offline Maven execution
- dependency/plugin cache preparation
- disconnected downstream stages
- another explicit pipeline requirement

then:

    restore mvn -B dependency:go-offline

Do not modify any other commands in that pipeline section.

This decision must be based on the current pipeline code.

======================================================================
5. PRESERVE CURRENT GOOD TEST-SPEED CHANGES
   ======================================================================

Do NOT revert or alter these unless compilation forces a direct fix:

SnsSteps.java

- INITIAL_POLL_DURATION uses Duration.ofMillis
- POLL_DURATION uses Duration.ofMillis
- Duration.ofSeconds(POLL_DURATION_MS) bug remains fixed
- unused kafkaConsumer.assignment() remains removed
- duplicate KafkaConsumer creation remains removed
- max.poll.records remains 10
- normal polling stops when requested count is reached
- runlog polling stops when requested count is reached
- repeated successful polling logs remain DEBUG
- shared HttpClient remains
- readiness performs a real HTTP check every invocation

IntegrationTest.java

- Cucumber "pretty" plugin remains removed
- summary / SnsSteps / HTML reporting remain

BuiltImageRuntimeIntegrationTest.java

- shared HttpClient remains
- request timeout constant remains
- 500ms polling remains
- 120 second maximum readiness timeout remains

SnsTestcontainersEnvironment.java

- shared HttpClient remains
- explicit .GET() remains
- Schema Registry round-trip remains active
- readiness functional validation remains active

.drone.star

- hard CI performance failure threshold remains removed
- main command remains:

      mvn -T 1C clean verify -Pci-testcontainers-snapshot

Do NOT add -T to built-image runtime smoke.

======================================================================
6. VERIFY NO TEST CONFIDENCE REGRESSION
   ======================================================================

Do not modify:

- strict testId correlation
- expected scenario count
- completed scenario guard
- TestcontainersSuiteCoverageTest
- Docker availability / false-green protection
- Schema Registry round-trip
- business assertions
- scenario selection
- JaCoCo
- BuiltImageRuntimeIntegrationTest functional checks
- Trivy

Speed must come from reduced overhead and safe concurrency only.

======================================================================
7. VALIDATION
   ======================================================================

If any source change is required, compile and run the affected path.

Where the environment permits, run:

    mvn -T 1C clean verify -Pci-testcontainers-snapshot

Confirm:

- BUILD SUCCESS
- real business IntegrationTest executes
- expected scenario count unchanged
- all non-ignored scenarios execute exactly once
- failures = 0
- errors = 0
- no unexpected skips
- TestcontainersSuiteCoverageTest passes
- Schema Registry round-trip executes
- all five aggregates start
- all five aggregates become functionally ready
- no startup race
- Docker failure cannot produce false green

Do not fake execution if private registry/Docker access blocks the run.

======================================================================
8. FINAL DIFF
   ======================================================================

Run:

    git diff
    git status

Preferred outcome:

- no code change if Testcontainers concurrency already exists
- possibly SnsTestcontainersEnvironment.java only if concurrency is genuinely missing
- possibly .drone.star only if dependency:go-offline must be restored

Do not touch any other files.

======================================================================
FINAL RESPONSE
======================================================================

Do not create any report file.

Reply only with:

- current Redis/ZooKeeper startup: CONCURRENT / SEQUENTIAL
- Kafka-after-ZooKeeper preserved: YES/NO
- SchemaRegistry-after-Kafka preserved: YES/NO
- five aggregate startup: CONCURRENT / SEQUENTIAL
- all-five functional readiness preserved: YES/NO
- code change required: YES/NO
- dependency:go-offline: REMOVED / RESTORED + one-line reason
- main suite result if run
- scenario count
- failures/errors/skips
- files changed
- blocker: none / exact blocker

Maximum 15 lines.