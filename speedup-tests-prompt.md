Complete and correct the remaining SNS test-speed optimisation work.

This is a FOCUSED IMPLEMENTATION task.

Do NOT:
- create reports
- create markdown files
- create TODO files
- create benchmark artefacts
- refactor unrelated code
- change business behaviour
- change feature files
- weaken test assertions
- remove validation
- introduce JUnit 5
- introduce new Cucumber runners
- introduce CI matrix/sharding
- change Docker image optimisation
- touch unrelated files

The current working diff already contains several correct optimisations.
Preserve them.

======================================================================
1. PRESERVE THE CURRENT CORRECT CHANGES
   ======================================================================

Do NOT revert these existing changes:

SnsSteps.java:
- INITIAL_POLL_DURATION uses Duration.ofMillis(...)
- POLL_DURATION uses Duration.ofMillis(...)
- Duration.ofSeconds(POLL_DURATION_MS) bug is fixed
- unused kafkaConsumer.assignment() call removed
- duplicate temporary KafkaConsumer creation removed
- max.poll.records = 10
- record polling stops when expected count is reached
- runlog polling stops when expected count is reached
- repeated successful polling logs use DEBUG
- shared HttpClient
- shared request timeout Duration
- readiness still performs a real HTTP check every time

IntegrationTest.java:
- Cucumber "pretty" plugin removed
- summary / SnsSteps / HTML report preserved

BuiltImageRuntimeIntegrationTest.java:
- shared HttpClient
- reusable request timeout
- 500ms polling interval
- 120 second maximum readiness timeout unchanged

SnsTestcontainersEnvironment.java:
- shared HttpClient
- request timeout constant
- 500ms aggregate readiness polling
- total aggregate readiness allowance remains approximately 120 seconds
- validateSchemaRegistryRoundTrip() remains active

.drone.star:
- hard performance failure threshold removed
- current main Maven -T 1C candidate remains for now

Do not weaken any of the above protections.

======================================================================
2. IMPLEMENT ACTUAL BASE TESTCONTAINERS CONCURRENT STARTUP
   ======================================================================

Inspect:

    SnsTestcontainersEnvironment.startInfrastructure()

Determine the actual dependency graph of:

    REDIS
    ZOOKEEPER
    KAFKA
    SCHEMA_REGISTRY

Expected dependency structure, subject to verification from the code:

    REDIS       independent
    ZOOKEEPER   independent

    KAFKA       depends on ZOOKEEPER

    SCHEMA_REGISTRY depends on KAFKA

If this is correct, do not start Redis and ZooKeeper sequentially.

Start REDIS and ZOOKEEPER concurrently using Testcontainers-native facilities.

Prefer:

    Startables.deepStart(...).join()

or another simple Testcontainers-supported mechanism.

Then:

    start Kafka only after ZooKeeper is ready
    start Schema Registry only after Kafka is ready

Do NOT:
- introduce a custom ExecutorService unless Testcontainers cannot express it
- change Kafka image/config
- migrate Kafka to KRaft
- remove ZooKeeper
- weaken readiness conditions
- change startup timeouts

The final dependency ordering must remain correct.

======================================================================
3. IMPLEMENT ACTUAL PARALLEL AGGREGATE CONTAINER STARTUP
   ======================================================================

Inspect:

    SnsTestcontainersEnvironment.startAggregators()

The current implementation must NOT remain equivalent to:

    start PARTY
    wait PARTY

    start OBJECT
    wait OBJECT

    start LOCATION
    wait LOCATION

    start EVENT
    wait EVENT

    start SERVICE
    wait SERVICE

First verify from container configuration whether these five aggregates have
real startup dependencies on each other:

    AGGREGATE_PARTY
    AGGREGATE_OBJECT
    AGGREGATE_LOCATION
    AGGREGATE_EVENT
    AGGREGATE_SERVICE

They share dependencies on:

    Kafka
    Schema Registry
    Redis

Do not assume inter-aggregate dependencies unless the configuration proves
them.

If they are independent after shared infrastructure is ready:

START ALL FIVE CONTAINERS CONCURRENTLY.

Prefer Testcontainers-native concurrent startup:

    Startables.deepStart(Stream.of(
        AGGREGATE_PARTY,
        AGGREGATE_OBJECT,
        AGGREGATE_LOCATION,
        AGGREGATE_EVENT,
        AGGREGATE_SERVICE
    )).join();

or equivalent.

Do not introduce artificial sequential ordering.

======================================================================
4. PARALLELISE AGGREGATE FUNCTIONAL READINESS CHECKS
   ======================================================================

Container start completion is NOT enough.

All five aggregates must still pass their existing HTTP functional readiness
checks.

After concurrent container startup, perform readiness checks for all five.

If readiness checks are independent, run those checks concurrently too.

Use a small bounded Java concurrency mechanism only for the readiness checks
if required.

Examples acceptable:

    CompletableFuture

or another simple standard-library construct.

Do NOT create persistent thread pools.

All readiness tasks must:

- propagate failures
- preserve the existing readiness URLs
- preserve profile-path fallback behaviour
- preserve HTTP_REQUEST_TIMEOUT
- preserve READINESS_POLL_INTERVAL_MS
- preserve approximately 120 seconds maximum readiness allowance
- preserve interruption handling

startAggregators() must return only when:

    ALL five aggregates are functionally ready.

If any one aggregate fails readiness:

    fail the entire startup
    retain useful diagnostics

Do not silently ignore readiness failures.

======================================================================
5. FAILURE HANDLING FOR CONCURRENT STARTUP
   ======================================================================

Concurrent startup must remain fail-fast and diagnosable.

If one container fails:

- propagate the root failure
- do not mark aggregatorsStarted=true
- allow existing Testcontainers failure diagnostics to collect logs
- preserve shutdown behaviour

Set:

    aggregatorsStarted = true

ONLY after:

    all five containers started
    AND
    all five readiness checks succeeded.

Do not mark the environment ready early.

======================================================================
6. CHECK EXPLICIT HTTP GET SEMANTICS
   ======================================================================

In SnsTestcontainersEnvironment.isReadinessUp(...), the current speed patch
removed the explicit:

    .GET()

from HttpRequest creation.

Although Java defaults to GET, this provides no speed benefit.

Restore explicit:

    .GET()

for clarity and to minimise unnecessary semantic diff.

Likewise, do not remove explicit HTTP methods elsewhere merely for speed.

======================================================================
7. REVIEW dependency:go-offline REMOVAL
   ======================================================================

The current .drone.star diff removes:

    mvn -B dependency:go-offline

after:

    mvn clean install

Do not assume this is redundant.

Inspect the surrounding pipeline step and downstream dependencies.

Determine why dependency:go-offline existed.

If no later command/job depends on having the Maven repository explicitly
prepared for offline execution, and clean install already resolves everything
required, the removal may remain.

BUT:

If the step exists to prepare dependencies for:
- later offline Maven execution
- disconnected build stage
- cache preparation
- another pipeline job

then restore it.

Do not optimise by removing required dependency preparation.

Make an evidence-based decision from the pipeline code.

Do not modify other Maven commands in that pipeline section.

======================================================================
8. KEEP MAIN MAVEN -T 1C AS A CANDIDATE
   ======================================================================

Do NOT remove:

    mvn -T 1C clean verify -Pci-testcontainers-snapshot

during this focused fix.

Do NOT add -T to BuiltImageRuntimeIntegrationTest execution.

We will evaluate the actual CI timing separately.

Do not introduce:
- -T 2
- -T 2C
- alternative thread counts
- Surefire forkCount
- Cucumber parallelism

in this task.

======================================================================
9. VERIFY NO ACCIDENTAL TEST SEMANTIC CHANGES
   ======================================================================

Confirm the final diff does NOT change:

- strict testId filtering
- scenario selection
- expected scenario count
- completed scenario guard
- TestcontainersSuiteCoverageTest
- Docker availability hard-fail
- Schema Registry round-trip validation
- business assertions
- feature files
- aggregate functional readiness semantics
- JaCoCo
- BuiltImageRuntimeIntegrationTest functional checks
- Trivy

Speed must come from lower overhead/concurrency, not reduced validation.

======================================================================
10. COMPILE AND TEST
    ======================================================================

First compile the affected test module.

Then run, where environment permits:

    mvn -T 1C clean verify -Pci-testcontainers-snapshot

Confirm:

- BUILD SUCCESS
- real business Cucumber suite runs
- expected business scenario count unchanged
- all scenarios execute exactly once
- failures = 0
- errors = 0
- no unexpected skips
- TestcontainersSuiteCoverageTest passes
- Schema Registry round-trip executes
- all five aggregate containers start
- all five aggregates pass readiness
- no startup race
- strict testId matching remains

If Docker/private registry access prevents execution, report the exact blocker.
Do not claim success without evidence.

======================================================================
11. REVIEW FINAL DIFF
    ======================================================================

Run:

    git diff
    git status

The new fix should mainly affect:

    SnsTestcontainersEnvironment.java

Potentially:

    .drone.star

ONLY if dependency:go-offline needs restoration.

SnsSteps.java should require no new functional changes unless a compilation
problem directly caused by the current patch must be fixed.

Do not touch app.py.

Do not touch feature files.

Do not introduce new permanent helper classes unless absolutely required.

======================================================================
EXPECTED FINAL TESTCONTAINERS FLOW
======================================================================

The intended structure should be approximately:

    Redis --------\
                   -> independent concurrent startup
    ZooKeeper ----/

    ZooKeeper ready
          |
        Kafka
          |
    Schema Registry
          |
    create topics
          |
    schema registry round-trip
          |
    SNS application
          |
    -----------------------------------------
    |        |         |        |           |
Party   Object   Location   Event      Service
|        |         |        |           |
-------- concurrent container startup ---
|
-------- concurrent readiness checks ----
|
all aggregates ready
|
Cucumber scenarios

Preserve the actual dependency graph if repository configuration proves a
different required ordering.

======================================================================
FINAL RESPONSE
======================================================================

Do not create a report file.

Reply only with a concise terminal/chat summary:

- Redis/ZooKeeper concurrent startup: YES/NO
- Kafka dependency preserved: YES/NO
- Schema Registry dependency preserved: YES/NO
- five aggregate concurrent startup: YES/NO
- aggregate readiness concurrent: YES/NO
- explicit HTTP GET restored: YES/NO
- dependency:go-offline: KEPT REMOVED / RESTORED + one-line reason
- main suite result
- scenario count
- failures/errors/skips
- files changed
- blocker: none / exact blocker

Maximum 15 lines.