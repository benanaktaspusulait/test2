Clean up and complete the current SNS test-speed optimisation changes.

This is an IMPLEMENTATION task.

Do NOT create:
- reports
- markdown files
- benchmark documents
- TODO files
- proposal files
- analysis files

Make the code changes directly, run the relevant tests, and leave only
production-quality optimisations in the final diff.

The current green branch before these test-speed changes is the baseline.

======================================================================
1. KEEP THE SAFE EXISTING OPTIMISATIONS
   ======================================================================

Keep these current changes unless testing proves they cause a regression:

A. Cucumber console noise reduction

In:

    cmd-adaptor-sns-integration-tests/src/test/java/uk/gov/ho/dacc/fdp/IntegrationTest.java

Keep removal of:

    "pretty"

from the Cucumber plugins.

Keep:

    "summary"
    "uk.gov.ho.dacc.fdp.steps.SnsSteps"
    "html:target/cucumber.html"

Do not change scenario selection or assertions.

--------------------------------------------------

B. Remove useless Kafka assignment getter

In SnsSteps.awakeConsumer(...), keep removal of:

    kafkaConsumer.assignment();

because its return value was unused.

--------------------------------------------------

C. Reuse Duration constants

Keep:

    kafkaConsumer.poll(INITIAL_POLL_DURATION)

and:

    kafkaConsumerRunlogCmd.poll(POLL_DURATION)

BUT verify the constants preserve the intended behaviour.

Explicitly inspect the definitions of:

    INITIAL_POLL_DURATION
    POLL_DURATION

They must represent the same intended units/values as the correct previous
implementation.

In particular, do NOT accidentally reintroduce the old bug where a value named
POLL_DURATION_MS was interpreted using Duration.ofSeconds(...).

If POLL_DURATION_MS is milliseconds, POLL_DURATION must be based on:

    Duration.ofMillis(...)

Do not change timeout semantics just for speed.

--------------------------------------------------

D. Reduce polling log noise

Keep:

    log.debug(...)

for repeated poll-attempt / record-level successful diagnostic messages instead
of INFO.

Do not downgrade warnings/errors or failure diagnostics.

--------------------------------------------------

E. Built-image readiness HTTP client reuse

Keep:

    private static final HttpClient HTTP_CLIENT = HttpClient.newHttpClient();

and:

    private static final Duration REQUEST_TIMEOUT = Duration.ofSeconds(2);

Reuse the client across readiness attempts.

--------------------------------------------------

F. Built-image readiness polling interval

Keep the current:

    Thread.sleep(500L)

instead of 1000ms.

Keep the total readiness deadline unchanged:

    READINESS_TIMEOUT = 120 seconds

This changes polling granularity, not the maximum allowed startup time.

======================================================================
2. RESTORE SCHEMA REGISTRY FUNCTIONAL VALIDATION
   ======================================================================

In:

    SnsTestcontainersEnvironment.startInfrastructure()

restore:

    validateSchemaRegistryRoundTrip();

after:

    createRequiredTopics();

The resulting flow should again be:

    messagingStarted = true;
    createRequiredTopics();
    validateSchemaRegistryRoundTrip();

Do NOT remove this functional validation merely for speed.

The Schema Registry HTTP readiness endpoint only proves that the service is
reachable.

The round-trip validation proves that the Registry can actually:

    register a schema
    and
    read it back

This protection should remain unless there is explicit evidence and a separate
decision proving that another mandatory test provides exactly the same failure
boundary.

For this change, restore it.

======================================================================
3. REMOVE MAVEN PARALLELISM FROM BUILT-IMAGE RUNTIME SMOKE
   ======================================================================

In:

    .drone.star

change the built-image runtime validation command back from:

    mvn -T 1C -pl cmd-adaptor-sns-integration-tests -am verify ...

to:

    mvn -pl cmd-adaptor-sns-integration-tests -am verify ...

for:

    -Pci-built-image-runtime-smoke

The runtime smoke executes one specialised validation whose dominant cost is
container/application startup and readiness.

Do NOT add Maven reactor parallelism there without independent measured
evidence.

Keep BuiltImageRuntimeIntegrationTest unchanged otherwise.

======================================================================
4. EVALUATE MAVEN PARALLELISM ONLY FOR THE MAIN TEST STEP
   ======================================================================

The current main CI command has been changed from:

    mvn clean verify -Pci-testcontainers-snapshot

to:

    mvn -T 1C clean verify -Pci-testcontainers-snapshot

Do NOT automatically keep -T 1C.

Compare the two commands using the same repository state:

A.

    mvn clean verify -Pci-testcontainers-snapshot

B.

    mvn -T 1C clean verify -Pci-testcontainers-snapshot

Run comparable executions.

Use at least two comparable successful runs for each form if practical.

Compare wall-clock only; do not create benchmark files.

Also verify for every run:

- complete Maven reactor succeeds
- real Cucumber business runner executes
- expected scenario count is unchanged
- TestcontainersSuiteCoverageTest succeeds
- failures = 0
- errors = 0
- no unexpected skips
- Docker/Testcontainers execution really occurred
- no zero-test false green

Decision:

KEEP -T 1C only if it provides a clear, repeatable wall-clock improvement
without instability/resource problems.

If improvement is negligible, inconsistent, or causes contention:

    revert -T 1C

Do not try increasingly aggressive thread counts.

If -T 1C is rejected, return to the normal Maven command.

======================================================================
5. REMOVE UNUSED IMPORT
   ======================================================================

In:

    cmd-adaptor-sns/src/test/java/uk/gov/ho/dacc/fdp/integration/steps/IntegrationTestSteps.java

the current patch adds:

    import java.io.UncheckedIOException;

If there is no actual use of UncheckedIOException in the final source:

    remove the import.

Search the file before deciding.

Do not add code just to justify the import.

======================================================================
6. CHECK FOR PARTIALLY IMPLEMENTED EXPERIMENTS
   ======================================================================

Review ONLY the files touched by this test-speed optimisation patch.

Search for:

- new unused imports
- unused constants
- temporary timing code
- temporary benchmark variables
- commented experiments
- duplicate HTTP clients
- duplicate Duration constants
- alternative Maven commands
- test-only logging added during investigation

Remove anything that is not part of the retained final solution.

Do NOT perform unrelated code cleanup.

======================================================================
7. DO NOT REMOVE TEST CONFIDENCE FOR SPEED
   ======================================================================

Do NOT optimise by removing or weakening:

- validateSchemaRegistryRoundTrip
- TestcontainersSuiteCoverageTest
- EXPECTED_SCENARIOS / COMPLETED_SCENARIOS protection
- Docker availability protection
- testId correlation
- Cucumber business assertions
- BuiltImageRuntimeIntegrationTest
- TestcontainersFailureDiagnostics
- built-image readiness validation
- JaCoCo/coverage
- Trivy
- scenario execution

A speed improvement caused by doing less validation is not acceptable.

======================================================================
8. LOOK FOR ONLY VERY LOW-RISK COMPLETION OPPORTUNITIES
   ======================================================================

While touching these exact areas, inspect for obvious low-risk omissions.

Allowed examples:

- constructing the same immutable Duration repeatedly
- constructing the same HttpClient repeatedly
- unused getter calls
- INFO logging inside high-frequency successful polling loops
- continuing a poll loop after its success condition has already been met

Implement such changes only if behaviour is obviously equivalent.

Do NOT introduce:

- Cucumber parallelism
- JUnit migration
- Surefire fork redesign
- Testcontainers container-startup redesign
- aggregate parallel startup
- new Maven profiles
- CI matrix
- production code refactoring

Those require separate measured work.

Keep this optimisation patch small.

======================================================================
9. VALIDATE THE FINAL RESULT
   ======================================================================

After cleanup, run the final selected main command.

If -T 1C proved beneficial:

    mvn -T 1C clean verify -Pci-testcontainers-snapshot

Otherwise:

    mvn clean verify -Pci-testcontainers-snapshot

Confirm:

- BUILD SUCCESS
- real IntegrationTest executed
- complete source-derived business scenario count executed
- failures = 0
- errors = 0
- no unintended skips
- TestcontainersSuiteCoverageTest passes
- Schema Registry functional round-trip remains active
- Docker unavailable cannot silently produce green

Then validate the built-image runtime path using the NON-parallel command:

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
10. FINAL DIFF
    ======================================================================

Review:

    git diff
    git status

The final test-speed diff should ideally contain only changes such as:

- remove Cucumber pretty console output
- remove unused Kafka assignment() call
- reuse correctly defined Duration constants
- reduce repetitive successful poll logs to DEBUG
- reuse built-image readiness HttpClient
- use 500ms readiness polling with unchanged 120s deadline
- main Maven -T 1C ONLY if measurement proves worthwhile

It should NOT contain:

- removal of Schema Registry functional validation
- -T 1C on built-image runtime smoke
- unused UncheckedIOException import
- benchmark files
- temporary scripts
- reports
- documentation changes
- unrelated refactors

======================================================================
FINAL RESPONSE
======================================================================

Do not create a report file.

Reply only with a short terminal/chat summary:

- restored Schema Registry round-trip: YES/NO
- runtime-smoke -T 1C removed: YES/NO
- unused code/import removed
- main -T 1C result: KEPT or REVERTED
- main test command duration(s)
- scenario/test parity
- built-image runtime result
- files changed
- blocker: none / exact blocker

Maximum 15-20 lines.