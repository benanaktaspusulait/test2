Fix the current SNS test-speed optimisation patch.

This is a focused IMPLEMENTATION task.

Do NOT:
- create reports
- create markdown files
- create TODO files
- create benchmark artefacts
- refactor unrelated code
- change business feature semantics
- remove test protections
- weaken assertions
- touch Docker/image optimisation work outside the exact areas below

Keep the current good optimisations unless explicitly told otherwise.

======================================================================
1. REMOVE READINESS RESULT CACHING FROM SNSSTEPS
   ======================================================================

In:

    cmd-adaptor-sns-integration-tests/src/test/java/uk/gov/ho/dacc/fdp/steps/SnsSteps.java

REMOVE:

    private static final AtomicBoolean READINESS_CONFIRMED ...

and all related logic such as:

    if (READINESS_CONFIRMED.get()) {
        ...
        return;
    }

    READINESS_CONFIRMED.set(true);

    READINESS_CONFIRMED.set(false);

Reason:

The Cucumber step:

    When Readiness health check is completed

must continue to perform a real readiness check each time it is invoked.

Do NOT turn this business/test step into a cached no-op after the first success.

KEEP:

- shared static HttpClient
- REQUEST_TIMEOUT constant
- debug-level repeated readiness logging
- current real HTTP readiness behaviour
- existing timeout/failure semantics

Do not weaken the readiness check.

======================================================================
2. FIX RUNLOG BATCH PROCESSING FOR max.poll.records=10
   ======================================================================

The current patch changes:

    max.poll.records

from:

    1

to:

    10

Keep this optimisation.

However:

    pollForRunlogRecords(...)

still processes the full Kafka batch using forEach.

Change it so it stops processing matching records as soon as:

    runlogRecords.size() >= number

Use an explicit loop instead of forEach where necessary.

Required behaviour:

    poll
    -> iterate records
    -> keep strict testId filtering
    -> add matching records
    -> immediately break when requested count is reached

Do not collect additional matching records beyond the number requested merely
because Kafka returned a larger batch.

Preserve all existing record validation and correlation behaviour.

Do NOT modify strict testId matching.

======================================================================
3. REVERT LEGACY app.py TEST-SPEED CHANGES
   ======================================================================

In:

    cmd-adaptor-sns-integration-tests/src/test/resources/docker-compose/pre-integration-test/app.py

Revert ONLY the test-speed optimisation changes introduced in the current patch.

Remove additions such as:

    from concurrent.futures import ThreadPoolExecutor

    CONNECT_RETRIES
    CONNECT_RETRY_SLEEP_SECONDS
    READINESS_SLEEP_SECONDS
    READINESS_ATTEMPTS

Restore the previous behaviour for:

- Kafka connection retry
- Redis retry
- Schema Registry readiness
- Kafdrop readiness
- command adaptor readiness
- aggregate readiness

Restore aggregate readiness checks to their pre-current-patch implementation.

Reason:

This is the legacy Docker Compose fallback path.

The active CI optimisation target is the Testcontainers path.

Do not alter legacy Compose behaviour merely to obtain test-speed gains.

IMPORTANT:

Do NOT revert older intentional baseline fixes unrelated to this current
test-speed patch.

Only revert the changes introduced by the current test-speed optimisation.

======================================================================
4. IMPLEMENT REAL TESTCONTAINERS AGGREGATE PARALLEL STARTUP
   ======================================================================

In:

    SnsTestcontainersEnvironment

inspect the current snapshot aggregate startup implementation.

The current flow is effectively sequential:

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

This is the actual path that should be optimised.

Analyse whether the five aggregate containers:

    AGGREGATE_PARTY
    AGGREGATE_OBJECT
    AGGREGATE_LOCATION
    AGGREGATE_EVENT
    AGGREGATE_SERVICE

have any real startup dependency on each other.

They all depend on shared infrastructure such as:

    Kafka
    Schema Registry
    Redis

Do NOT assume they depend on one another unless the code/configuration proves it.

If they are independent after shared infrastructure is ready:

start all five concurrently.

Preferred implementation:

use Testcontainers-supported dependency-aware concurrent startup such as:

    Startables.deepStart(...).join()

or another simple Testcontainers-native approach.

Do NOT introduce a custom thread pool if Testcontainers already provides the
appropriate startup primitive.

After containers have started:

verify readiness for each aggregate.

Readiness checks may also run concurrently if safe.

Preserve:

- aggregate image
- environment variables
- network aliases
- topic suffix
- startup timeout
- readiness URLs
- failure diagnostics
- shutdown behaviour

Do NOT make startup success mean only "container process exists".

All five aggregates must still become functionally ready.

======================================================================
5. PRESERVE THE SAME TOTAL AGGREGATE READINESS TIMEOUT
   ======================================================================

Current aggregate readiness logic uses approximately:

    240 attempts
    x
    500ms

which preserves about a 120 second maximum wait.

Keep this total bounded timeout behaviour.

Do not reduce the maximum allowed startup time just to make tests appear
faster.

Use:

    HTTP_REQUEST_TIMEOUT

and the shared:

    HTTP_CLIENT

where already implemented.

Do not create a new HttpClient per attempt/container.

======================================================================
6. REVIEW TESTCONTAINERS BASE INFRASTRUCTURE STARTUP
   ======================================================================

Inspect the current startup ordering of:

    Redis
    ZooKeeper
    Kafka
    Schema Registry

Determine actual dependencies.

Expected likely dependency graph:

    Redis             independent
    ZooKeeper         independent

    Kafka             depends on ZooKeeper

    Schema Registry   depends on Kafka

If current code starts Redis and ZooKeeper sequentially, and there is no
dependency between them, start them concurrently using Testcontainers-native
startup.

Then:

    wait/start Kafka

then:

    start Schema Registry

Do NOT violate actual container dependencies.

Do not redesign the Kafka image or switch to KRaft as part of this task.

======================================================================
7. KEEP CURRENT SAFE TEST-SPEED CHANGES
   ======================================================================

Keep:

- INITIAL_POLL_DURATION using Duration.ofMillis(...)
- POLL_DURATION using Duration.ofMillis(...)
- removal of unused kafkaConsumer.assignment()
- max.poll.records = 10
- reduced successful-loop INFO logs to DEBUG
- early exit in normal record polling
- shared HttpClient usage
- reusable timeout Duration constants
- aggregate readiness interval 500ms
- Cucumber "pretty" plugin removal
- BuiltImageRuntimeIntegrationTest shared HttpClient
- built-image readiness polling at 500ms
- Schema Registry round-trip validation
- hard CI performance threshold removal

Do not reintroduce:

    Duration.ofSeconds(POLL_DURATION_MS)

======================================================================
8. MAVEN -T 1C
   ======================================================================

Do NOT change the current main CI:

    mvn -T 1C clean verify -Pci-testcontainers-snapshot

in this fix.

Leave it as the current candidate.

Do not add Maven -T to the built-image runtime smoke.

We will decide whether -T 1C remains based on actual CI timing after this patch.

======================================================================
9. DO NOT CHANGE TEST EXECUTION MODEL YET
   ======================================================================

For this focused fix do NOT introduce:

- new Cucumber runners
- Failsafe forkCount changes
- JUnit 5 migration
- Cucumber parallel execution
- CI matrix/sharding
- static-state architecture refactors

Those will be evaluated after the Testcontainers startup bottleneck is fixed.

======================================================================
10. VALIDATION
    ======================================================================

Run the final main Testcontainers suite:

    mvn -T 1C clean verify -Pci-testcontainers-snapshot

Verify:

- BUILD SUCCESS
- real business IntegrationTest runs
- all expected non-ignored business scenarios execute exactly once
- expected scenario count unchanged
- TestcontainersSuiteCoverageTest passes
- failures = 0
- errors = 0
- no unexpected skips
- Schema Registry round-trip still runs
- strict testId filtering remains
- all five aggregate containers start and reach readiness
- no Testcontainers startup race
- Docker failure cannot silently produce green

If local environment cannot execute the full suite, do not fake success.

======================================================================
11. FINAL DIFF REVIEW
    ======================================================================

The final diff for this fix should mainly contain:

SnsSteps.java
- remove readiness cache
- runlog early-break
- retain existing safe polling/logging improvements

SnsTestcontainersEnvironment.java
- actual concurrent Testcontainers startup
- dependency-correct infrastructure startup
- existing shared HTTP/readiness improvements

app.py
- revert current test-speed experiment only

No unrelated files should be changed.

======================================================================
FINAL RESPONSE
======================================================================

Do not create a report file.

Reply only with a short terminal/chat summary:

- READINESS_CONFIRMED removed: YES/NO
- runlog early-break added: YES/NO
- legacy app.py speed changes reverted: YES/NO
- base Testcontainers startup model
- aggregate startup model
- aggregate readiness model
- full suite result
- scenario count
- failures/errors/skips
- files changed
- blocker: none / exact blocker

Maximum 15 lines.