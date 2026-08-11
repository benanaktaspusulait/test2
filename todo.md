Perform a STRICT SCOPE CLEANUP of the current CST-2328 branch.

This is NOT a refactoring task.
This is NOT a performance optimisation task.
This is NOT a general cleanup task.

The objective is:

    FINAL DIFF = ONLY CHANGES REQUIRED FOR CST-2328

CST-2328 scope:

    Migrate the SNS real integration/E2E execution path to Testcontainers,
    simplify the CI integration path accordingly,
    preserve all existing business scenario coverage,
    prevent false-green/zero-test execution,
    and preserve the historical built-Docker-image runtime validation boundary.

Anything not required to achieve that objective must NOT remain in this task.

======================================================================
CRITICAL: ESTABLISH THE CORRECT BASELINE FIRST
======================================================================

Do NOT judge scope from commit history alone.

The patch history contains work from multiple tasks and contributors.

First determine the actual baseline from which CST-2328 started.

Use the actual MR target branch if known.

If the MR target is develop:

    git fetch origin
    BASE=$(git merge-base HEAD origin/develop)

If CST-2328 was intentionally based on a previous Story/feature branch,
use THAT branch/commit as the baseline instead.

This is important:

Previous work that was already part of the intended CST-2328 starting state
must NOT be reverted simply because it has a different CST number.

Review:

    git log --oneline --decorate ${BASE}..HEAD
    git diff --name-status ${BASE}..HEAD
    git diff ${BASE}..HEAD

The final diff against the correct CST-2328 baseline is what matters.

======================================================================
SCOPE RULE
======================================================================

For EVERY changed hunk ask:

    "Would CST-2328 fail to meet its acceptance goal without this change?"

If NO:

    revert the hunk.

Do not keep something because:

- it is a good improvement
- it fixes another bug
- it makes code cleaner
- it may improve performance
- it modernises configuration
- it is useful for future work
- tests happen to pass with it

Those belong in separate tasks.

======================================================================
KEEP — CST-2328 CORE
======================================================================

Keep changes genuinely required for the final Testcontainers architecture,
including where applicable:

- SnsTestcontainersEnvironment
- Redis Testcontainers infrastructure
- Kafka Testcontainers infrastructure
- ZooKeeper where required by the chosen Kafka image
- Schema Registry Testcontainers infrastructure
- aggregate Testcontainers required by existing snapshot scenarios
- unique Testcontainers topic suffix/run identity
- required Testcontainers-owned Kafka topic provisioning
- starting the SNS application against the Testcontainers infrastructure
- Maven profiles required for:
  local-testcontainers
  local-testcontainers-snapshot
  ci-testcontainers-cmd
  ci-testcontainers-snapshot
- Testcontainers dependencies genuinely used by the final implementation
- Testcontainers version required for the CI Docker API compatibility
- Docker/Testcontainers CI configuration required for the actual environment
- DOCKER_HOST / DOCKER_API_VERSION configuration proven necessary
- TestcontainersSuiteCoverageTest
- zero-test / false-green protection
- failIfNoTests / failIfNoSpecifiedTests protection where required
- real business runner execution
- exclusion of BuiltImageRuntimeIntegrationTest from the business-suite profile
- ci-built-image-runtime-smoke profile
- BuiltImageRuntimeIntegrationTest
- TestcontainersFailureDiagnostics where required by retained tests
- Validate Built Image Runtime CI step
- minimum README changes needed to document the new supported Testcontainers commands
- removal of obsolete standalone pilot smoke tests and dependencies
- final self-contained Testcontainers topic setup
- preservation of legacy Compose behaviour

Do not remove something simply because it looks large if it is genuinely needed
for CST-2328.

======================================================================
DO NOT REINTRODUCE REMOVED PROTOTYPES
======================================================================

The final branch must NOT contain:

- MinimalRedisTest
- KafkaSchemaRegistrySmokeTest
- redis-only-compose-script.sh
- topic-templates.txt
- Jedis dependency/property
- Dockerfile.layer-order-prototype
- T3.3 measurement scripts
- generated benchmark artefacts
- prototype-only profiles/configuration

unless one of these already exists in the correct CST-2328 baseline.

======================================================================
CHECK 1 — UNRELATED TASK / CONTRIBUTOR CHANGES
======================================================================

The patch history includes commits unrelated to CST-2328.

Specifically inspect whether the FINAL DIFF still contains changes originating
from items such as:

- "Update versions for release"
- "update changelog"
- CST-2301-related changelog content
- CST-2326 TracePoleV2IdRecordTransformerTest changes
- IntegrationTestStepsStringTypeTest
- unrelated release version transitions
- unrelated production/domain test changes

Examples of suspicious files include:

    CHANGELOG.md
    cmd-adaptor-sns/src/test/java/.../IntegrationTestStepsStringTypeTest.java
    cmd-adaptor-sns/src/test/java/.../TracePoleV2IdRecordTransformerTest.java
    root/module version-only POM changes

IMPORTANT:

If these changes are already present in the target/baseline branch, leave them
alone.

If they appear only in ${BASE}..HEAD and are unrelated to CST-2328, remove them
from this task.

Do not revert entire files if they also contain valid CST-2328 changes.
Restore only unrelated hunks.

======================================================================
CHECK 2 — PREVIOUS STORY CHANGES
======================================================================

The history also contains previous optimisation tasks such as:

    CST-2177
    CST-2189
    CST-2263
    CST-2320

These may include:

- .dockerignore
- Dockerfile layering
- BuildKit registry cache
- earlier Testcontainers pilots
- measurement scripts

Do NOT automatically keep or remove them based on task number.

Determine whether they belong to the intended CST-2328 baseline.

If CST-2328 was intentionally started AFTER those changes, they are baseline
and must remain untouched.

If they are accidentally part of the CST-2328 diff, remove them or rebase
CST-2328 onto the correct prerequisite branch rather than mixing task scopes.

Do not duplicate Story 1 work inside CST-2328.

======================================================================
CHECK 3 — BUSINESS FEATURE FILES
======================================================================

Review every modification under:

    cmd-adaptor-sns-integration-tests/src/test/resources/features/

CST-2328 is infrastructure/test-execution migration.

Existing business scenarios should remain semantically unchanged unless a
change is absolutely necessary to reproduce the SAME historical test setup.

Specifically inspect:

    E2E_Service.feature

which currently received additional EORI/readiness steps during the
Testcontainers work.

Compare it with the CST-2328 baseline.

Prefer:

    Testcontainers infrastructure/setup provides prerequisites

over:

    changing the existing business scenario

If the Testcontainers environment can reproduce the required setup without
changing the feature, restore the feature to baseline.

Keep a feature change ONLY if it is technically necessary to preserve the
pre-existing scenario behaviour and cannot correctly be supplied by the test
infrastructure.

Do not use CST-2328 to improve or rewrite business scenarios.

======================================================================
CHECK 4 — TEST ASSERTION / CORRELATION SEMANTICS
======================================================================

Inspect:

    SnsSteps.haveTestIdHeader(...)

The branch introduced behaviour equivalent to:

    if testId header is missing:
        return TESTCONTAINERS_ENABLED

This weakens the original test correlation rule.

That is NOT an acceptable Testcontainers migration shortcut.

Restore the original strict semantic requirement:

    record must contain the expected testId
    and the value must match

If Testcontainers execution loses the header, fix the Testcontainers setup or
the test-data propagation required to preserve the original assertion.

Do NOT solve Testcontainers compatibility by weakening business/test
assertions.

CST-2328 must preserve or strengthen test confidence.

======================================================================
CHECK 5 — GENERIC BUG FIXES FOUND DURING CST-2328
======================================================================

Review changes such as polling-unit corrections, retry tuning, readiness
changes, logging improvements and generic test fixes.

Example:

    Duration.ofSeconds(POLL_DURATION_MS)
        ->
    Duration.ofMillis(POLL_DURATION_MS)

This may be a valid bug fix.

But the question for THIS cleanup is not whether it is correct.

The question is:

    Is this change REQUIRED for CST-2328 parity?

If it fixes a pre-existing problem that also exists on the legacy path and
CST-2328 does not require it:

    revert it from this branch.

It can be raised as a separate small task later.

If Testcontainers cannot reproduce the legacy business suite correctly without
the fix, keep it only if that dependency is demonstrable.

Use the same rule for:

- generic polling improvements
- logging cleanups
- retry tuning
- unrelated test refactors
- generic readiness improvements

No opportunistic bug fixing in this MR.

======================================================================
CHECK 6 — PERFORMANCE GATES
======================================================================

Inspect CI additions such as:

    TESTCONTAINERS_MAX_SECONDS
    hard failure when test duration exceeds a threshold
    hard failure when entire branch pipeline exceeds a fixed number of seconds

CST-2328 is intended to improve the pipeline, but arbitrary performance
thresholds are not automatically part of Testcontainers migration.

Unless the CST-2328 acceptance criteria explicitly require a hard duration
gate:

    remove the hard performance-failure threshold.

A slow but functionally correct build must not fail merely because a CI worker,
registry or network is temporarily slower.

Keep simple timing output only if it is useful and minimal.

If timing output itself has no runtime purpose and is only experiment evidence,
remove it as well.

======================================================================
CHECK 7 — README
======================================================================

README changes are allowed ONLY where required because supported commands
changed.

Keep concise documentation for actual final commands such as:

    local-testcontainers
    local-testcontainers-snapshot

Do not add:

- historical pilot explanation
- benchmark discussion
- architecture write-ups
- deleted smoke test commands
- performance claims
- experimental instructions

The README should describe the final supported behaviour only.

======================================================================
CHECK 8 — LEGACY COMPOSE
======================================================================

CST-2328 must not redesign the legacy Compose path.

Compare these with the baseline carefully:

    pre-integration-test/app.py
    pre-integration-test/Dockerfile
    docker-compose.yml

The topic-template extraction has already been identified as out of scope.

Ensure:

- app.py retains baseline topic behaviour
- no topic-templates.txt dependency remains
- Dockerfile does not copy topic-templates.txt
- no unrelated Compose refactor remains

Only keep Compose changes strictly required to preserve legacy compatibility
with the final CST-2328 implementation.

======================================================================
CHECK 9 — PRODUCTION CODE
======================================================================

CST-2328 should not change production business logic.

Review all changes under:

    cmd-adaptor-sns/src/main/
    cmd-adaptor-sns-common/
    cmd-adaptor-sns-avro/

There should be no production-domain behaviour change unless absolutely
required for Testcontainers execution.

Version updates, mappings, POLE IDs, business transforms, schemas, logging
semantics and production Kafka behaviour are outside CST-2328.

Remove unrelated branch-only changes.

======================================================================
CHECK 10 — FINAL TESTCONTAINERS CLASSES
======================================================================

Review every class under:

    cmd-adaptor-sns-integration-tests/src/test/java/.../testcontainers/

Each retained class must have a concrete role in the final solution.

Expected legitimate roles include:

    SnsTestcontainersEnvironment
        -> final integration environment

    TestcontainersSuiteCoverageTest
        -> prevents missing/zero business suite execution

    BuiltImageRuntimeIntegrationTest
        -> preserves the historical built-image runtime boundary

    TestcontainersFailureDiagnostics
        -> diagnostics/lifecycle support required by retained tests

No prototype-only class should remain.

======================================================================
CHECK 11 — POM CLEANUP
======================================================================

Review every CST-2328-added property, profile and dependency.

For each one, locate a live consumer.

Remove:

- unused properties
- pilot-only configuration
- unused dependencies
- duplicate profiles
- obsolete excludedGroups logic
- obsolete smoke-test configuration

Keep only configuration required by the final business Testcontainers suite
and built-image runtime validation.

Do not simplify working Maven configuration merely for style.

======================================================================
CHECK 12 — .drone.star
======================================================================

Final CST-2328 CI architecture should remain focused:

    Build and Test with Testcontainers
        ->
    Build Command Adaptor Image
        ->
    Validate Built Image Runtime
        ->
    Scan with Trivy

Keep only changes required to produce that architecture and make it reliable.

Preserve necessary:

- Docker connection configuration
- Artifactory auth needed by Testcontainers/aggregate images
- Docker API compatibility
- Testcontainers profile execution
- image build dependency
- runtime image validation dependency
- Trivy dependency

Remove experiment-only commands and unrelated pipeline changes.

Do not modify unrelated Drone stages.

======================================================================
DO NOT CONFUSE COMMIT HISTORY WITH FINAL DIFF
======================================================================

Empty commits such as:

    chore: rerun pipeline

do not matter to code scope if the MR is squash-merged.

Do NOT waste time rewriting history unless explicitly requested.

The priority is:

    CLEAN FINAL DIFF

not:

    BEAUTIFUL LOCAL COMMIT HISTORY

======================================================================
VALIDATION
======================================================================

After scope cleanup:

1. Run the normal relevant Maven regression.

2. Run:

       mvn clean verify -Pci-testcontainers-snapshot

   or the actual current CI-equivalent command.

3. Confirm the real:

       uk.gov.ho.dacc.fdp.IntegrationTest

   executes the complete current source-derived business scenario set.

4. Confirm:

       TestcontainersSuiteCoverageTest

   passes.

5. Build:

       docker-compose-command-adaptor:latest

6. Run the existing:

       ci-built-image-runtime-smoke

7. Confirm:

       BuiltImageRuntimeIntegrationTest
       Tests run: 1
       Failures: 0
       Errors: 0
       Skipped: 0

8. Confirm no zero-test false green.

9. Confirm legacy Compose files are structurally unchanged except for genuinely
   required CST-2328 compatibility changes.

======================================================================
FINAL DIFF QUALITY BAR
======================================================================

Run:

    git diff ${BASE}..HEAD --stat
    git diff ${BASE}..HEAD
    git status

Review EVERY remaining changed hunk.

Every hunk must answer YES to:

    "Is this required to deliver CST-2328?"

If the explanation begins with:

    "while we were here..."
    "this is cleaner..."
    "this also fixes..."
    "this might help..."
    "future..."
    "performance improvement unrelated to migration..."

remove it.

======================================================================
NO DOCUMENTATION / REPORT OUTPUT
======================================================================

Do NOT create:

- report files
- audit files
- findings.md
- TODO files
- scope-review documents
- benchmark files
- cleanup notes

Do the cleanup directly.

======================================================================
FINAL RESPONSE
======================================================================

Reply only with a SHORT summary:

1. Correct CST-2328 baseline used
2. Unrelated files/hunks removed
3. Suspicious changes reviewed and kept only if required
4. Final changed-file list
5. Business scenario result
6. Coverage guard result
7. Built-image runtime result
8. Pipeline/test result
9. Remaining unrelated diff: NONE / exact item

Maximum ~20 lines.