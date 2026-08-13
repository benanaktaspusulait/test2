Optimise SNS CI integration-test successful-path logging by removing large
payload dumps from INFO while preserving all useful failure diagnostics.

This is a VERY FOCUSED implementation + A/B measurement task.

Do NOT:
- change Testcontainers lifecycle
- change Kafka polling
- change Maven execution
- change test assertions
- change scenario semantics
- change production logging
- create markdown/report/benchmark files
- suppress WARN/ERROR
- suppress stack traces
- add shell output filters
- add sleeps/timeouts
- change unrelated code

======================================================================
CURRENT STATE
======================================================================

Current stable pipeline is approximately:

    Overall CI                            ~5:09–5:10
    Build/Test with Testcontainers       ~3:12–3:13
    Runtime validation                   ~0:30–0:31
    Trivy                                ~0:40

The previous framework/config logger optimisation did not produce a meaningful
wall-clock improvement.

However the integration-test logs still contain very large successful-path INFO
messages, including examples such as:

    IntegrationTestSteps:
        full input SNS JSON payload

    "And executing step [...] with { ... hundreds of expected attributes ... }"

    "Value: { ... complete output record ... }"

These are repeated across many scenarios and records.

The goal of this experiment is:

    keep concise scenario/test progress at INFO
    move only large successful payload dumps to DEBUG

while preserving complete diagnostics when a test actually fails.

======================================================================
1. INSPECT CURRENT SOURCE FIRST
   ======================================================================

Inspect the CURRENT implementation of:

    IntegrationTestSteps

and any related assertion classes such as:

    BaseAssertions
    PartyAssertions
    ObjectAssertions
    LocationAssertions
    EventAssertions
    ServiceAssertions

Find the exact logging statements responsible for:

- full input payload JSON
- full output record / "Value:"
- giant expected attribute maps
- complete successful assertion objects

Do not guess.

Do not broadly lower the logger level for the entire test package.

======================================================================
2. KEEP USEFUL INFO LOGS
   ======================================================================

The following concise information should remain at INFO:

- scenario/step identity
- Given / When / Then progression where useful
- testId
- topic name
- expected record count
- actual record count
- mapping name/type
- concise readiness/startup milestones
- test completion/failure summaries

Examples of useful INFO:

    When: SNS templated source data is presented,
          testId=abc123,
          inputTopic=fdp-sns-input_0

    Then: expected 2 Party records for SNS-C-CONSIGNEE

    Records count: expected=2 actual=2

Do NOT remove all IntegrationTestSteps INFO logging.

======================================================================
3. MOVE LARGE SUCCESSFUL PAYLOADS TO DEBUG
   ======================================================================

Move ONLY large successful-path payload dumps from INFO to DEBUG.

Candidates include statements equivalent to:

    log.info("{}", fullInputPayload)

    log.info("Value: {}", fullOutputRecord)

    log.info("And executing step [{} with {} following attributes]",
             ..., fullExpectedAttributes)

and similarly large successful assertion object dumps.

Prefer:

    concise INFO
    detailed DEBUG

Example concept:

    log.info("Validating Party record for mapping {}, testId={}",
             mappingName, testId);

    log.debug("Expected attributes: {}", expectedAttributes);
    log.debug("Actual value: {}", actualValue);

Do not blindly apply these exact lines.

Use existing logging style.

======================================================================
4. PRESERVE FAILURE-TIME DETAIL
   ======================================================================

This is critical.

If an assertion fails, the developer must still be able to see enough data to
understand:

- which scenario failed
- testId
- mapping name
- expected value
- actual value
- assertion failure
- stack trace

If existing assertion exceptions already contain expected/actual values,
verify this explicitly.

If moving a successful payload log to DEBUG would remove the ONLY copy of
expected/actual information on failure, preserve that information in the
failure path.

Preferred pattern:

    success:
        concise INFO only

    failure:
        ERROR/assertion exception contains expected vs actual
        plus stack trace

Do NOT duplicate giant payloads at ERROR on every successful run.

======================================================================
5. DO NOT BROADLY SUPPRESS APPLICATION/TEST LOGGERS
   ======================================================================

Do NOT set:

    uk.gov.ho.dacc.fdp.integration = WARN

or similar broad package suppression.

This experiment should be source-level and surgical.

Do not hide useful lifecycle/test progress.

======================================================================
6. CLEAN UP PREVIOUS LOGGER EXPERIMENT IF NECESSARY
   ======================================================================

Review the existing framework-logging change from the previous experiment.

If it currently uses broad logger namespaces such as:

    org.apache.kafka.clients
    org.apache.kafka.common.config

replace them with narrow exact config logger classes if needed.

Avoid redundant configuration.

Use ONE source of truth for the CI/test Kafka-config log level where practical.

Do not expand scope beyond simplifying the existing logging change.

Do NOT change production logging.

======================================================================
7. CONTROLLED FAILURE VALIDATION
   ======================================================================

Before keeping this change, prove failure diagnostics remain useful.

Temporarily create ONE safe reversible local assertion failure.

Verify console output still contains:

- failed scenario/test
- testId
- expected result
- actual result
- assertion message
- stack trace
- Maven/Surefire/Failsafe failure summary

Then revert the temporary failure completely.

Do NOT commit failure injection.

======================================================================
8. GREEN VALIDATION
   ======================================================================

Run:

    mvn clean verify -Pci-testcontainers-snapshot

Required:

    BUILD SUCCESS
    14 scenarios executed
    0 failures
    0 errors
    no unexpected skips

Do not alter test counts.

======================================================================
9. MEASURE FULL CI TWICE
   ======================================================================

Current reference:

    Overall CI              ~5:09–5:10
    Build/Test              ~3:12–3:13

Run Drone twice after ONLY this change.

Record:

    Build/Test run 1
    Build/Test run 2
    Overall run 1
    Overall run 2

Also confirm that the console no longer contains repeated giant successful
payload dumps such as:

    full source JSON
    full "Value:" records
    giant expected-attribute maps

======================================================================
10. KEEP / REVERT RULE
    ======================================================================

Keep this performance change ONLY if:

- all tests remain identical
- failure diagnostics remain complete
- log volume is materially reduced
- there is a reproducible wall-clock improvement

Target:

    get overall CI below 5:00 if possible

BUT:

Do NOT fake the result by weakening tests or diagnostics.

If both CI runs remain around:

    5:08–5:12

and Build/Test remains:

    ~3:12–3:14

then conclude logging is NOT a meaningful remaining performance bottleneck.

In that case:

    revert payload-log performance changes

unless a tiny change is independently worth retaining purely for log hygiene.

======================================================================
11. FINAL DIFF
    ======================================================================

Run:

    git diff
    git status

Expected likely source changes:

    IntegrationTestSteps.java

and only assertion classes where large successful INFO payload dumps are
confirmed.

Do not touch unrelated business code.

Do not leave:
- temporary failures
- timing instrumentation
- debug scripts
- reports
- benchmark files

======================================================================
FINAL RESPONSE
======================================================================

Reply only in terminal/chat, maximum 15 lines:

- large INFO logs changed
- concise INFO retained: YES/NO
- failure expected/actual retained: YES/NO
- ERROR preserved: YES/NO
- stack traces preserved: YES/NO
- production logging changed: YES/NO
- 14 scenarios executed: YES/NO
- failures/errors/skips
- Build/Test before
- Build/Test run 1 after
- Build/Test run 2 after
- Overall before
- Overall run 1/run 2 after
- files changed
- experiment kept/reverted + reason