Optimise SNS CI test logging to reduce unnecessary console output during
successful test execution without weakening failure diagnostics.

This is a FOCUSED IMPLEMENTATION + A/B MEASUREMENT task.

Do NOT create:
- markdown reports
- benchmark files
- TODO files
- documentation
- unrelated refactoring
- permanent measurement artefacts

The final branch must retain ONLY a measured winning implementation.

======================================================================
CURRENT STATE
======================================================================

Current stable CI is approximately:

    Overall CI                             ~5:10
    Build and Test with Testcontainers    ~3:13
    Validate Built Image Runtime          ~0:31

The Build/Test logs contain large volumes of repeated INFO output including:

- KafkaAvroSerializerConfig
- KafkaAvroDeserializerConfig
- Kafka client configuration dumps
- Confluent serializer/deserializer configuration
- framework startup/configuration messages
- large JSON payloads from integration tests
- large successful assertion values

The first experiment must NOT modify application/test business logging.

Start only with noisy third-party/framework configuration logging.

Goal:

    reduce successful-build console/log-forwarding overhead

while preserving:

    WARN
    ERROR
    stack traces
    Maven failures
    Surefire/Failsafe failures
    Testcontainers diagnostics
    application failure diagnostics

======================================================================
1. INSPECT CURRENT LOGGING CONFIGURATION
   ======================================================================

Inspect the CURRENT repository for:

    application.yml
    application.yaml
    application.properties
    logback.xml
    logback-spring.xml
    log4j configuration
    test resources
    CI-specific profiles
    ci-testcontainers-snapshot profile
    Spring Boot logging properties

Search specifically for existing logger configuration.

Determine:

- which logging implementation is active
- whether CI/test logging already has a dedicated profile
- how Spring profiles are activated during:
  mvn clean verify -Pci-testcontainers-snapshot
- whether logger levels can be scoped ONLY to this CI test execution

Do not modify production/default logging unless unavoidable.

======================================================================
2. IDENTIFY THE EXACT NOISY LOGGER NAMES
   ======================================================================

Use the current log output and source/dependency packages to identify the exact
logger namespaces responsible for repeated config dumps.

Likely candidates include packages/classes around:

    io.confluent.kafka.serializers
    KafkaAvroSerializerConfig
    KafkaAvroDeserializerConfig
    org.apache.kafka.common.config
    org.apache.kafka.clients

Do NOT blindly suppress broad:

    org.apache.kafka

unless inspection proves it is safe.

Prefer the narrowest logger namespaces possible.

======================================================================
3. FIRST EXPERIMENT: FRAMEWORK CONFIG LOGGING ONLY
   ======================================================================

For the FIRST experiment, reduce only verbose third-party configuration logging.

Target behaviour should be equivalent to:

    successful configuration dumps:
        INFO -> hidden

    WARN:
        still visible

    ERROR:
        still visible

Use WARN as the preferred logger threshold where appropriate.

Example concept only:

    logging.level.io.confluent.kafka.serializers=WARN
    logging.level.org.apache.kafka.common.config=WARN

Do NOT blindly paste these exact properties without confirming the actual
logger names producing the current output.

======================================================================
4. SCOPE TO CI TEST EXECUTION
   ======================================================================

The logging reduction must affect ONLY:

    CI/Testcontainers test execution

or another clearly test-only profile.

Do NOT reduce production logging.

Do NOT modify runtime container production logging.

Do NOT globally change the application's normal logging policy.

Preferred approaches:

- CI/test-specific Spring profile
- Maven profile-scoped system properties
- test resource logging configuration

Use the smallest existing configuration mechanism.

======================================================================
5. PRESERVE FAILURE INFORMATION
   ======================================================================

After the change, the following MUST still be visible:

- ERROR logs
- WARN logs
- exception stack traces
- test assertion failures
- Maven BUILD FAILURE
- Surefire/Failsafe test failure summaries
- Testcontainers startup failures
- Docker unavailable failures
- Kafka connectivity failures
- Schema Registry failures
- aggregate readiness failures
- Kafka Streams shutdown failures
- TestcontainersFailureDiagnostics output

Do NOT suppress stderr.

Do NOT redirect logs to /dev/null.

Do NOT disable Maven error output.

Do NOT add shell filtering such as:

    grep
    sed
    awk
    tail

to hide output after it is produced.

Reduce logging at the logger configuration/source level.

======================================================================
6. DO NOT MODIFY BUSINESS TEST LOGGING YET
   ======================================================================

For the FIRST experiment, do NOT change:

    IntegrationTestSteps
    assertions
    testId logs
    scenario logs
    business payload logs
    application custom INFO logs

Even if they are verbose.

This is deliberate so the A/B experiment has one variable:

    third-party/framework config logging only

If this first experiment produces no meaningful gain, it may be reverted before
considering application/test payload logging separately.

======================================================================
7. DO NOT CHANGE TEST BEHAVIOUR
   ======================================================================

Preserve all existing:

- 14 Cucumber business scenarios
- scenario-count guard
- completed-scenario protection
- strict testId correlation
- Docker hard-fail
- Testcontainers infrastructure
- Schema Registry round-trip
- aggregate readiness
- Kafka polling behaviour
- Kafka Streams lifecycle/shutdown
- TopologyTestDriver tests
- unit tests
- JaCoCo
- BuiltImageRuntimeIntegrationTest
- Trivy

Logging optimisation must not change test timing through altered waits,
timeouts or assertions.

======================================================================
8. VERIFY FAILURE DIAGNOSTICS LOCALLY
   ======================================================================

Where practical, validate not only a green run but one controlled failing case.

Do NOT commit a failing test.

Temporarily cause a safe local failure if possible, for example:

- invalid expected assertion
- temporary invalid readiness target
- another reversible test-only failure

Verify the console still shows:

    failure reason
    relevant ERROR/WARN
    stack trace
    Maven test failure summary

Then revert the temporary failure completely.

Do not leave failure-injection code in the diff.

======================================================================
9. MEASURE GREEN RUN
   ======================================================================

Run:

    mvn clean verify -Pci-testcontainers-snapshot

Confirm:

    BUILD SUCCESS
    14 scenarios executed
    failures = 0
    errors = 0
    no unexpected skips

Capture only in terminal/chat:

    Maven total time
    IntegrationTest time
    integration module time

Do not create files.

======================================================================
10. RUN FULL CI TWICE
    ======================================================================

After the logger-level change, run the full Drone pipeline twice if available.

Current reference:

    Build and Test with Testcontainers ~= 3:13
    Overall CI ~= 5:10

Record:

    Build/Test run 1
    Build/Test run 2
    Overall run 1
    Overall run 2

Also visually confirm the repeated Confluent/Kafka config dumps are gone or
substantially reduced.

======================================================================
11. KEEP/REVERT RULE
    ======================================================================

Keep the change ONLY if:

- both CI runs remain green
- all expected tests still execute
- failure diagnostics remain useful
- production logging is untouched
- console output is materially reduced
- wall-clock improvement is reproducible

Prefer a meaningful reproducible improvement.

Do NOT keep extra logging complexity for a 1-2 second random fluctuation.

If there is no clear benefit:

    REVERT the experiment completely.

======================================================================
12. OPTIONAL SECOND EXPERIMENT
    ======================================================================

ONLY if the framework logger experiment is safe but still leaves substantial
console output, inspect application/test successful-path payload logging.

Possible candidates may include:

    IntegrationTestSteps
    successful full JSON input payloads
    successful full output record values
    verbose successful assertion payloads

Do NOT implement this in the same initial A/B measurement.

If evaluated later:

- retain testId/scenario identification at INFO
- move only large successful payload dumps to DEBUG
- preserve failure-time payload/context
- preserve assertion failure diagnostics

Measure separately.

======================================================================
13. FINAL DIFF HYGIENE
    ======================================================================

Run:

    git diff
    git status

Expected change should be very small.

Likely files:

    test/CI logging configuration
    Maven profile configuration

Avoid Java source changes for the first experiment.

Do NOT leave:

- temporary failures
- temporary diagnostics
- measurement code
- benchmark files
- shell log filters
- unrelated changes

======================================================================
FINAL RESPONSE
======================================================================

Reply only in terminal/chat.

Maximum 15 lines:

- logging backend/config mechanism
- exact logger namespaces changed
- old levels
- new levels
- production logging changed: YES/NO
- WARN preserved: YES/NO
- ERROR preserved: YES/NO
- stack traces preserved: YES/NO
- 14 scenarios executed: YES/NO
- failures/errors/skips
- Build/Test before
- Build/Test run 1 after
- Build/Test run 2 after
- files changed
- experiment kept/reverted + reason