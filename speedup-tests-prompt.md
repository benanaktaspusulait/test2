Optimise test execution and CI feedback time across the ENTIRE
fdp-cmd-adaptor-sns repository.

This is an IMPLEMENTATION task.

Do not produce analysis documents.
Do not create reports.
Do not create TODO files.
Do not create proposal Markdown files.
Do not create measurement scripts unless absolutely required temporarily.
Do not create permanent benchmark infrastructure.
Do not add documentation just to describe what you did.

WORK DIRECTLY ON THE CODE, Maven configuration and CI configuration.

The repository is currently GREEN.

Preserve the current working implementation and improve it.

======================================================================
PRIMARY GOAL
======================================================================

Reduce the execution time of the SNS Maven/test/CI path as much as reasonably
possible WITHOUT reducing test confidence.

Apply the existing test-speedup ideas, but also inspect the repository for
additional safe optimisation opportunities.

Do not blindly implement every optimisation.

Use the repository itself as the source of truth.

For every candidate:

    inspect
    implement if technically sound
    run
    measure
    keep if useful
    otherwise revert

Do this internally.

Do NOT generate a report for every experiment.

======================================================================
CURRENT PROTECTED STATE
======================================================================

The current branch is green.

Current observed pipeline is approximately:

    Overall pipeline                     ~6m41s
    Build and Test with Testcontainers   ~3m44s
    Build Command Adaptor Image          ~21s
    Validate Built Image Runtime         ~1m16s
    Trivy                                ~42s

Treat this as the current implementation baseline.

Do not attribute the previous 23m05s -> 6m41s improvement to this task.

That optimisation phase is already complete.

======================================================================
DO NOT BREAK THESE
======================================================================

Preserve:

- current real SNS Cucumber business scenarios
- current scenario count
- TestcontainersSuiteCoverageTest
- zero-test / false-green protection
- Redis Testcontainers support
- Kafka Testcontainers support
- Schema Registry Testcontainers support
- aggregate Testcontainers support
- BuiltImageRuntimeIntegrationTest
- TestcontainersFailureDiagnostics
- built-image runtime validation
- BuildKit / registry cache
- Trivy
- legacy docker-compose path
- current Dockerfile optimisation
- current .dockerignore
- current topic provisioning
- current Maven coverage behaviour
- CI failure when Docker/Testcontainers cannot run

A faster pipeline caused by fewer tests is NOT acceptable.

Do not reintroduce:

- topic-templates.txt
- MinimalRedisTest
- KafkaSchemaRegistrySmokeTest
- Jedis
- prototype Dockerfiles
- benchmark scripts
- experimental files
- removed pilot code

======================================================================
WORK ACROSS THE WHOLE REPOSITORY
======================================================================

Inspect and optimise all relevant modules:

    pom.xml
    cmd-adaptor-sns/
    cmd-adaptor-sns-avro/
    cmd-adaptor-sns-common/
    cmd-adaptor-sns-test-common/
    cmd-adaptor-sns-integration-tests/
    .drone.star

Inspect all:

- Maven profiles
- Surefire configuration
- Failsafe configuration
- JUnit tests
- Cucumber tests
- TopologyTestDriver tests
- Spring tests
- Testcontainers infrastructure
- Kafka polling
- readiness checks
- retry loops
- fixed sleeps
- fixture loading
- config loading
- test logging
- static test state
- module dependencies
- reactor execution
- JaCoCo interaction

======================================================================
1. FIX TIMING / WAITING PROBLEMS
   ======================================================================

Search repository-wide for:

    Thread.sleep
    sleep(
    Duration.ofSeconds
    Duration.ofMillis
    poll(
    timeout
    retry
    attempts
    readiness
    interval
    MAX_RETRIES
    maxAttempts

Find incorrect or unnecessarily expensive waiting.

We already found one example where a value representing milliseconds was used
with Duration.ofSeconds(...).

Look for equivalent problems.

Fix unit mistakes.

Replace unnecessary fixed sleeps with bounded condition-based waiting where
safe.

Stop polling immediately once the expected result has been found.

Do NOT arbitrarily reduce legitimate timeout budgets.

Do NOT weaken failure detection.

======================================================================
2. OPTIMISE KAFKA TEST POLLING
   ======================================================================

Review every Kafka consumer loop used by tests.

Optimise where safe:

- poll duration
- number of retries
- unnecessary repeated polls
- processing after expected records already arrived
- repeated consumer construction
- repeated subscription
- repeated group setup
- max.poll.records where useful
- unnecessary commits
- unnecessary sleeps between polls

Preserve:

- testId/correlation correctness
- expected record counts
- business assertions
- isolation

Do not accept unrelated Kafka records simply to make the test faster.

======================================================================
3. OPTIMISE READINESS CHECKS
   ======================================================================

Review application and aggregate readiness handling.

Avoid repeated readiness work when the same application/container has already
been proven ready and its lifecycle has not changed.

If readiness is checked repeatedly by scenarios while infrastructure remains
alive for the entire suite, cache the successful readiness state safely.

Do not cache readiness across lifecycle restart.

Avoid checking multiple readiness URLs repeatedly after a valid endpoint has
already succeeded.

Keep bounded failure timeout and useful error messages.

======================================================================
4. OPTIMISE TESTCONTAINERS STARTUP
   ======================================================================

The current Testcontainers implementation starts several services.

Inspect whether independent containers are currently being started
sequentially.

Safely parallelise independent startup where possible.

Examples to investigate:

Redis and ZooKeeper may be independent.

Kafka depends on ZooKeeper.

Schema Registry depends on Kafka.

Aggregate services depend on the shared Kafka/Redis/Schema Registry
infrastructure but may be able to start concurrently with each other.

IMPORTANT:

The aggregate containers are currently a likely optimisation candidate if they
are started and waited for one-by-one.

If their startup dependencies allow it:

    start all required aggregate containers first

then:

    wait for readiness concurrently or efficiently

instead of:

    start party
    wait party
    start object
    wait object
    start location
    wait location
    ...

Use Testcontainers-supported mechanisms such as Startables/deepStart where
appropriate.

Do not introduce concurrency unless dependency ordering remains correct.

Do not change images or versions just for speed.

======================================================================
5. REMOVE REDUNDANT TESTCONTAINERS WORK
   ======================================================================

Inspect whether the suite performs infrastructure checks that duplicate work
already proven by the real business suite.

Examples:

- repeated Schema Registry validation
- repeated health checks
- repeated topic validation
- repeated environment bootstrap
- duplicate startInfrastructure calls
- duplicate application readiness
- unnecessary startup validation after infrastructure is already known healthy

Remove redundancy ONLY when the same failure boundary remains protected
elsewhere.

Do not remove meaningful validation merely because it consumes time.

======================================================================
6. KEEP ONE TESTCONTAINERS ENVIRONMENT PER SUITE
   ======================================================================

Ensure expensive infrastructure is not recreated unnecessarily between
scenarios/tests.

Reuse the existing suite-level infrastructure where safe.

Do not use CI-persistent Testcontainers reuse.

Do not share mutable scenario data.

Infrastructure reuse is allowed.

Business test state must remain isolated.

======================================================================
7. OPTIMISE CUCUMBER EXECUTION
   ======================================================================

Inspect the real SNS Cucumber suite.

Check:

- feature count
- scenario count
- slow scenarios
- repeated setup
- repeated readiness
- repeated fixture parsing
- repeated Kafka initialisation
- repeated schema/config loading
- excessive plugins/log output

If the Cucumber `pretty` plugin produces significant CI output without useful
CI value, consider removing it from CI while preserving useful summary/report
output.

Do not remove business reporting required by the project.

======================================================================
8. OPTIMISE TEST FIXTURE / CONFIG LOADING
   ======================================================================

Search for repeated:

    getResourceAsStream
    Files.read*
    ObjectMapper creation
    properties loading
    JSON parsing
    Avro schema loading
    immutable template loading

Cache immutable reusable resources where safe.

Do NOT cache mutable scenario records.

Do not introduce global mutable state.

======================================================================
9. OPTIMISE TEST LOGGING
   ======================================================================

Reduce clearly excessive successful-run logging where it creates substantial
output or execution overhead.

Candidates include:

- Kafka client INFO noise
- repeated polling messages
- repeated readiness messages
- repeated Testcontainers startup chatter
- per-record successful logging

Keep:

- errors
- failure diagnostics
- container log dumping on failure
- useful summary output

Do not make debugging significantly worse.

======================================================================
10. MAVEN REACTOR OPTIMISATION
    ======================================================================

Inspect the complete Maven dependency graph.

Determine whether modules can safely build/test in parallel.

Evaluate Maven reactor parallelism.

Do not blindly use:

    -T 1C

Test a sensible conservative value.

If Maven parallel execution provides a real improvement without instability,
keep it in the appropriate CI command.

If benefit is negligible or unsafe, revert it.

======================================================================
11. SUREFIRE / FAILSAFE OPTIMISATION
    ======================================================================

Inspect current Surefire/Failsafe execution.

Where tests are independent and execution time is meaningful, evaluate:

- forkCount
- reuseForks
- JVM startup overhead
- Spring context duplication
- JaCoCo argLine compatibility

Prefer conservative parallelism first.

Do not enable large fork counts.

Do not keep parallel forks unless they produce useful wall-clock improvement.

Preserve JaCoCo.

Preserve test discovery.

Preserve failure behaviour.

======================================================================
12. CHECK FOR DUPLICATE TEST EXECUTION
    ======================================================================

Inspect Surefire/Failsafe includes/excludes and Maven profiles.

Ensure the same tests or Cucumber scenarios are not accidentally executed more
than once during the current CI command.

Remove genuine duplicate execution if found.

Do NOT remove intentional separate validation boundaries such as:

    TestcontainersSuiteCoverageTest
    BuiltImageRuntimeIntegrationTest

======================================================================
13. CUCUMBER PARALLELISM — ONLY IF SAFE
    ======================================================================

If real Cucumber scenario execution remains a significant bottleneck after the
low-risk improvements, evaluate parallel execution.

Do NOT immediately rewrite the suite.

First inspect:

- static SnsSteps state
- Kafka producers/consumers
- topic suffix
- run ID
- testId
- aggregate state
- Testcontainers environment
- application lifecycle

If the existing architecture makes parallel scenarios unsafe, do NOT force it.

If JVM-level isolation through multiple runners/forks can safely provide
parallelism, implement it only if:

- all scenarios still run exactly once
- no duplicates
- no missing scenarios
- no shared-state failures
- measurable speed-up exists

The original all-features runner must not execute in addition to split runners.

======================================================================
14. JUNIT 5 PARALLEL EXECUTION
    ======================================================================

Do NOT migrate Cucumber/JUnit simply because JUnit 5 supports parallelism.

Use JUnit 5 scenario-level parallelism only if:

- lower-risk optimisations are insufficient
- test execution remains a real bottleneck
- shared state has been made safe
- measured improvement justifies the change

Otherwise leave it alone.

======================================================================
15. SPRING TEST OPTIMISATION
    ======================================================================

Inspect Spring-based tests for:

- unnecessary context recreation
- excessive @DirtiesContext
- different profiles/properties causing separate contexts
- repeated application startup

Use Spring's context caching effectively where safe.

Do not merge tests that require genuinely different contexts.

======================================================================
16. TOPOLOGY TESTS
    ======================================================================

Inspect TopologyTestDriver tests.

Look for:

- repeated expensive topology creation
- repeated schema/config loading
- unnecessary sleeps/polling
- repeated immutable setup
- unnecessary Spring context usage

Optimise only if these tests contribute materially to total test execution.

Do not over-engineer an 18-second test area to save 1 second if a much larger
bottleneck exists elsewhere.

======================================================================
17. JACOCO
    ======================================================================

Keep CI coverage enabled.

Do not disable JaCoCo to make CI faster.

You may optimise JaCoCo configuration if there is genuine duplicate
instrumentation or execution.

Do not lower coverage thresholds.

======================================================================
18. CI EXECUTION
    ======================================================================

Inspect .drone.star after test/Maven optimisation.

Preserve the current high-level flow:

    Build and Test with Testcontainers
        ->
    Build Command Adaptor Image
        ->
    Validate Built Image Runtime
        ->
    Scan with Trivy

Optimise inside those boundaries where useful.

Do not redesign the whole pipeline unless there is a clear measured reason.

If independent safe work can overlap without breaking artefact dependencies,
it may be parallelised.

Do not duplicate builds.

Do not rebuild the same Maven artefact unnecessarily.

======================================================================
19. LOOK FOR ADDITIONAL OPPORTUNITIES
    ======================================================================

Do not limit the work to the suggestions above.

Inspect the repository yourself for other safe performance problems.

Examples:

- repeated Maven executions
- duplicate compilation
- duplicate dependency resolution
- unnecessary clean/install boundaries
- repeated Spring startup
- repeated Docker checks
- duplicate resource generation
- redundant Cucumber setup
- serial operations that are truly independent
- unnecessary test plugins
- expensive logging
- avoidable filesystem work
- inefficient retry loops

Implement additional improvements if:

1. they are inside test/build/CI execution scope
2. behaviour remains equivalent
3. the change is maintainable
4. the improvement is real

Do NOT refactor unrelated production code.

======================================================================
20. EXPERIMENTS MUST DISAPPEAR
    ======================================================================

You may temporarily test different approaches.

But the final branch must NOT contain:

- benchmark scripts
- test reports
- generated logs
- experiment files
- alternative POM profiles
- commented experiments
- rejected implementations
- temporary classes
- TODO optimisation notes

If an experiment is rejected, fully revert it.

The final diff must contain only retained production-quality changes.

======================================================================
21. DO NOT CREATE DOCUMENTATION
    ======================================================================

Do NOT create:

- analysis.md
- report.md
- findings.md
- benchmark.md
- TODO.md
- proposal.md
- plan.md
- performance-results.md
- architecture documentation
- evidence files

Do not update README unless an existing developer command genuinely changes and
would otherwise become incorrect.

If README does not need changing, leave it untouched.

======================================================================
22. VALIDATE AFTER FINAL IMPLEMENTATION
    ======================================================================

After all retained changes:

Run the complete normal Maven test/build path.

Run the real Testcontainers business suite.

Confirm the real Cucumber runner executes all current source scenarios.

Confirm:

- same scenario count
- zero failures
- zero errors
- no unexpected skips
- coverage still passes
- TestcontainersSuiteCoverageTest passes
- Docker failure cannot silently produce green
- BuiltImageRuntimeIntegrationTest still passes
- fresh image runtime validation still passes
- final CI-equivalent path succeeds

Then compare final wall-clock with the current implementation.

======================================================================
23. CLEAN FINAL DIFF
    ======================================================================

Run:

    git status
    git diff --stat
    git diff

Remove anything unrelated.

The final diff should contain ONLY real test/build/CI performance improvements.

No reports.
No experiments.
No documentation noise.
No prototype files.

======================================================================
FINAL RESPONSE
======================================================================

Do NOT write a report.

Do NOT create a file.

Reply in the terminal/chat only with a SHORT summary:

- optimisations implemented
- files changed
- anything tested and reverted because it did not help
- test/scenario parity result
- previous runtime
- final runtime
- overall improvement
- remaining biggest bottleneck
- blocker: none / exact blocker

Maximum approximately 30 lines.

Focus on implementation, not documentation.