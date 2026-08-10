Evet, bunu **sadece test discovery/parity kontrolü** için hedefli bir promptla kontrol ettirelim. Kod değiştirmesin; önce hangi testlerin gerçekten çalıştığını ve develop’a göre neyin kaybolduğunu net çıkarsın.

```text
Perform a TEST DISCOVERY AND PARITY AUDIT for the current cmd-adaptor-sns branch.

Do not modify any files.
Do not create documentation.
Do not create reports in the repository.
Do not create another TODO.

The purpose of this check is to determine whether the new Testcontainers CI path
is fast because it is genuinely more efficient, or because some existing tests
are no longer being discovered/executed.

Use develop as the baseline.

============================================================
1. ESTABLISH THE BASELINE
============================================================

Determine:

- current branch
- current HEAD
- origin/develop or verified develop reference
- merge base

Use the correct merge-base comparison.

Do not assume that file count alone represents test coverage.

============================================================
2. IDENTIFY THE COMPLETE EXISTING TEST SUITE ON DEVELOP
============================================================

Inspect the develop version of the SNS integration-test module and determine the
complete set of tests that are intended to execute.

Check all relevant:

- test classes
- test methods
- base classes
- inherited tests
- JUnit tags
- @Disabled / @Ignore
- Maven profiles
- Surefire configuration
- Failsafe configuration
- include/exclude patterns
- test naming conventions
- integration-test naming conventions
- profile activation
- CI Maven commands

Determine the effective DEVELOP baseline:

- total relevant test classes
- total relevant test methods/scenarios
- tests intentionally disabled on develop
- tests excluded by design on develop

Do not count unrelated unit tests.

============================================================
3. IDENTIFY WHAT THE CURRENT TESTCONTAINERS CI PATH ACTUALLY RUNS
============================================================

Inspect the current branch pipeline configuration.

Find the exact stage corresponding to:

    Build and Test with Testcontainers

Determine the exact Maven command executed by that stage.

Then determine the exact tests discovered by that command.

Report:

- test classes discovered
- test methods/scenarios discovered
- tests executed
- tests skipped
- tests disabled
- tests excluded
- tests filtered out by tag/profile/include/exclude rules

Do not infer from the stage name.

Use the actual Maven/JUnit configuration.

============================================================
4. COMPARE DEVELOP VS CURRENT BRANCH
============================================================

Create an in-memory comparison of:

A. tests executed on develop/default integration path
B. tests executed on the current Testcontainers path

Classify every relevant develop test as exactly one of:

- EXECUTED IN TESTCONTAINERS
- INTENTIONALLY NOT APPLICABLE
- STILL COMPOSE-ONLY WITH CONCRETE TECHNICAL REASON
- ACCIDENTALLY SKIPPED
- ACCIDENTALLY EXCLUDED
- DISABLED ON CURRENT BRANCH
- NOT DISCOVERED
- TEST REMOVED
- UNKNOWN

The main goal is to identify any test that existed in the develop integration
coverage but is no longer exercised in the new Testcontainers CI path.

============================================================
5. LOOK FOR SILENT COVERAGE REDUCTION
============================================================

Specifically inspect branch changes for:

- @Disabled
- @Ignore
- disabledWithoutDocker
- changed @Tag values
- removed @Tag values
- changed Maven groups/excludedGroups
- Surefire includes/excludes
- Failsafe includes/excludes
- -Dtest
- -Dit.test
- -Dgroups
- -DexcludedGroups
- test class renames
- test method renames
- deleted test files
- deleted test methods
- inherited tests no longer discovered
- changed profile activation
- skipped modules
- `-pl` scope changes
- missing `-am`
- changed test source directories
- changed plugin execution phases

Also inspect CI shell conditions that may cause tests to be skipped.

============================================================
6. CHECK MAVEN OUTPUT
============================================================

Run or inspect the exact Testcontainers Maven command.

Capture the effective Maven test summary.

For every module involved, identify:

    Tests run:
    Failures:
    Errors:
    Skipped:

Do not rely only on the final reactor BUILD SUCCESS.

A green Maven build is not sufficient if intended tests were skipped.

If Maven output is split across Surefire and Failsafe, combine them correctly.

============================================================
7. CHECK TEST REPORT FILES
============================================================

Inspect generated Surefire/Failsafe reports from the current run where available.

Use them to determine the exact executed test classes and test methods.

Do not create or commit report files.

Use existing generated reports only for analysis.

Check for:

- skipped="true"
- disabled tests
- zero-test modules
- classes with zero executed methods
- tests filtered before execution

============================================================
8. CHECK DOCKER-SKIP BEHAVIOUR
============================================================

Pay special attention to Testcontainers patterns such as:

    @Testcontainers(disabledWithoutDocker = true)

Determine whether any intended CI tests can silently become skipped when Docker
is unavailable or incorrectly detected.

In the current CI run, verify Docker is actually available and intended
Testcontainers tests are NOT skipped because of this option.

============================================================
9. CHECK APPLICATION TESTS VS SMOKE TESTS
============================================================

Separate:

- Redis infrastructure smoke tests
- Kafka infrastructure smoke tests
- Schema Registry infrastructure smoke tests
- real cmd-adaptor-sns application integration tests

Report the count for each category.

The CI path is NOT complete if only infrastructure smoke tests execute.

The important number is how many real cmd-adaptor-sns integration scenarios are
actually being exercised through Testcontainers.

============================================================
10. CHECK COMPOSE-ONLY REMAINDERS
============================================================

Identify tests still only executed through the old Compose/full-E2E path.

For each one state the exact technical reason.

If a test is technically suitable for the Testcontainers path but is missing
from it, classify it as:

    ACCIDENTALLY NOT MIGRATED

Do not call it intentionally Compose-only without concrete evidence.

============================================================
11. VERIFY TEST COUNT DIFFERENCE IS EXPLAINABLE
============================================================

If the counts differ between develop and current Testcontainers paths, explain
every difference.

For example:

    Develop relevant scenarios: 42
    Testcontainers scenarios:    39

The remaining 3 must each have a concrete classification and reason.

No unexplained test-count reduction is acceptable.

============================================================
12. DO NOT FIX ANYTHING YET
============================================================

This pass is diagnostic only.

Do not edit:

- Java code
- Maven files
- pipeline files
- Docker files
- test configuration

We first need to know whether anything has been skipped.

============================================================
FINAL RESPONSE
============================================================

Return only this concise chat output:

## Verdict

Choose exactly one:

- FULL PARITY
- PARTIAL PARITY — EXPLAINED
- TEST COVERAGE LOST

## Develop Baseline

- relevant test classes:
- relevant test methods/scenarios:
- intentionally disabled/excluded:

## Current Testcontainers CI

- exact Maven command:
- test classes discovered:
- test methods/scenarios executed:
- failures:
- errors:
- skipped:

## Coverage Difference

For every develop test not executed through Testcontainers, list:

- class
- method/scenario where relevant
- classification
- exact reason

## Smoke vs Application Coverage

- Redis smoke tests:
- Kafka smoke tests:
- Schema Registry smoke tests:
- real cmd-adaptor-sns integration scenarios:

## Suspicious Findings

List only concrete evidence of accidental skipping/exclusion.

If none:

    None

## Conclusion

One sentence only:
state whether the ~3 minute pipeline result appears to preserve test coverage or
whether the speedup is partly caused by tests no longer running.
```

Bu promptun amacı çok net: **“hangi testler gerçekten çalıştı?”** sorusuna cevap vermek. Özellikle `Tests run / Skipped / class-method parity` tarafını çıkarırsa, 3 dakikalık sürenin gerçek optimizasyon mu yoksa coverage kaybı mı olduğunu hemen anlarsın.
