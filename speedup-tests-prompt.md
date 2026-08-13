Revert ONLY the Maven reactor parallelism experiment from the SNS test-speed optimisation.

This is a focused implementation task.

Do NOT:
- change any other test-speed optimisation
- refactor unrelated code
- create reports
- create markdown files
- create benchmark artefacts
- modify business tests
- modify Testcontainers behaviour
- modify Docker/image optimisation
- modify built-image runtime validation
- modify Trivy
- modify JaCoCo
- change Cucumber execution model

======================================================================
1. REVERT ONLY -T 1C FROM THE MAIN CI TEST COMMAND
   ======================================================================

In:

    .drone.star

change:

    mvn -T 1C clean verify -Pci-testcontainers-snapshot

back to:

    mvn clean verify -Pci-testcontainers-snapshot

Reason:

Two consecutive CI runs with the -T 1C candidate completed at approximately:

    6:58
    6:56

and the Build and Test with Testcontainers step was approximately:

    3:58

The parallel Maven reactor candidate has not demonstrated an improvement and
may be creating CPU/memory contention with Testcontainers, Kafka, Schema
Registry, Spring and aggregate containers.

Treat -T 1C as a rejected optimisation experiment.

======================================================================
2. DO NOT REVERT THE OTHER TEST-SPEED IMPROVEMENTS
   ======================================================================

Preserve all current valid changes, including:

SnsSteps.java:
- INITIAL_POLL_DURATION uses Duration.ofMillis
- POLL_DURATION uses Duration.ofMillis
- the old Duration.ofSeconds(POLL_DURATION_MS) bug remains fixed
- unused kafkaConsumer.assignment() remains removed
- duplicate KafkaConsumer construction remains removed
- max.poll.records remains 10
- normal Kafka polling stops when requested record count is reached
- runlog polling stops when requested record count is reached
- repeated polling logs remain DEBUG
- shared HttpClient remains
- readiness still performs a real HTTP check every invocation

IntegrationTest.java:
- Cucumber "pretty" remains removed
- summary / SnsSteps / HTML report remain

SnsTestcontainersEnvironment.java:
- shared HttpClient remains
- HTTP timeout constants remain
- aggregate readiness polling remains 500ms with approximately 120s maximum
- Schema Registry round-trip validation remains active
- existing concurrent Testcontainers startup remains unchanged

BuiltImageRuntimeIntegrationTest.java:
- shared HttpClient remains
- 500ms readiness polling remains
- 120s maximum readiness timeout remains

.drone.star:
- hard CI performance failure threshold remains removed
- do not change any other CI step

======================================================================
3. CHECK THE FINAL DIFF
   ======================================================================

After the change, inspect:

    git diff
    git status

The ONLY new change from the current working state should be:

    .drone.star
        mvn -T 1C clean verify ...
        ->
        mvn clean verify ...

Do not clean up or modify anything else.

======================================================================
4. LOCAL VALIDATION
   ======================================================================

Run the non-parallel command locally if the environment supports Docker and
required registry access:

    mvn clean verify -Pci-testcontainers-snapshot

Confirm:

- BUILD SUCCESS
- real Cucumber IntegrationTest executes
- expected scenario count unchanged
- all business scenarios execute exactly once
- failures = 0
- errors = 0
- no unexpected skips
- TestcontainersSuiteCoverageTest passes
- Schema Registry round-trip succeeds
- aggregate Testcontainers become ready

If local Docker/private registry access prevents execution, report the exact
blocker and do not fake success.

Do not add alternative thread counts such as:

    -T 2
    -T 0.5C
    -T 2C

This task is only to remove the unsuccessful -T 1C experiment.

======================================================================
5. AFTER LOCAL SUCCESS
   ======================================================================

Do not make further performance changes.

Leave the branch ready for CI.

We will compare the next CI runs against the two observed -T 1C runs:

    6:58
    6:56

The key comparison will be:

    overall CI duration
    Build and Test with Testcontainers duration

======================================================================
FINAL RESPONSE
======================================================================

Do not create a report file.

Reply only with a short summary:

- -T 1C removed: YES/NO
- final Maven command
- other speed optimisations preserved: YES/NO
- local build result
- scenario count
- failures/errors/skips
- files changed
- blocker: none / exact blocker

Maximum 10 lines.