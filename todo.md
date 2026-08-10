Evet. Test-count parity temiz çıktı: **14 eski gerçek senaryo → 14 yeni gerçek senaryo, 0 skipped**. Şimdi kalan asıl soru artık test sayısı değil:

> **Eski pipeline’daki her teknik sorumluluk yeni pipeline’da gerçekten karşılanıyor mu, yoksa bazı stage’ler sadece kaldırılmış mı?**

Aşağıdaki prompt tam bunun için. Bu aşamada **kod değiştirmesin**; önce eksik fonksiyonu net bulsun. Özellikle `Aggregators`, `Pre-Integration Tests`, eski `Command Adaptor`, Compose infrastructure ve yeni Testcontainers uygulama startup yoluna odaklanıyor.

```text
Perform a FINAL CI FUNCTIONAL PARITY AUDIT between the original develop
pipeline and the current Testcontainers-based feature-branch pipeline.

IMPORTANT:

The test discovery / scenario parity audit has already been completed.

Known result:

- develop real cmd-adaptor-sns integration scenarios: 14
- current Testcontainers real cmd-adaptor-sns integration scenarios: 14
- failures: 0
- errors: 0
- skipped: 0

Do NOT repeat the full test-count audit.

This audit has a different purpose:

Determine whether every IMPORTANT FUNCTIONAL RESPONSIBILITY of the old CI
pipeline is still performed by the new pipeline, even though the old stages no
longer exist separately.

Do not modify any files yet.
Do not create documentation.
Do not create markdown reports.
Do not create another TODO.

Use actual repository code, pipeline definitions, Maven configuration and
develop-vs-feature-branch comparison.

Do not infer equivalence from stage names.

============================================================
1. ESTABLISH THE TWO PIPELINE MODELS
============================================================

Inspect the pipeline definition on:

A. origin/develop
B. current feature branch

Determine the exact old develop pipeline sequence and the exact current pipeline
sequence.

The old pipeline previously contained responsibilities/stages similar to:

- RepoSync Version
- Retrieve Artifactory Secrets
- Wait for Docker
- Extract Adaptor Information
- Kafka & Redis
- Aggregators
- mvn clean install
- Command Adaptor
- Pre-Integration Tests
- Testcontainers Smoke Tests
- Integration Tests
- Trivy

The current pipeline visibly contains approximately:

- RepoSync Version
- Retrieve Artifactory Secrets
- Wait for Docker
- Extract Adaptor Information
- Build and Test with Testcontainers
- Build Command Adaptor Image
- Scan with Trivy

Do not rely on this list alone.

Read the actual pipeline source and determine exact commands.

============================================================
2. BUILD A FUNCTIONAL RESPONSIBILITY MAP
============================================================

For every OLD stage, determine what technical responsibility it performed.

Do not simply say:

"removed"
or
"replaced by Testcontainers".

Trace what the old stage actually did.

For every old stage classify it as exactly one:

- UNCHANGED
- MERGED INTO CURRENT STEP
- REPLACED BY TESTCONTAINERS
- REPLACED BY MAVEN/TEST FIXTURE
- NO LONGER REQUIRED — PROVEN
- STILL REQUIRED BUT MISSING
- UNKNOWN

For MERGED / REPLACED classifications, identify the exact current code or command
that now performs the responsibility.

============================================================
3. KAFKA & REDIS OLD STAGE
============================================================

Inspect the original "Kafka & Redis" stage.

Determine exactly what it started/configured.

Check:

- Kafka image/version
- Redis image/version
- listeners
- ports
- topics
- readiness
- volumes
- environment variables
- Schema Registry relationship, if any
- any initialization scripts

Then inspect the current Testcontainers implementation.

Verify that every Kafka/Redis capability required by the 14 application
scenarios is now supplied through Testcontainers.

Prove that the current integration tests do NOT depend on the old Compose
Kafka/Redis instances.

Check effective runtime configuration of cmd-adaptor-sns.

Specifically verify that during the Testcontainers CI path the application uses:

- dynamically resolved Kafka bootstrap servers
- dynamically resolved Redis host/port
- Testcontainers-provided Schema Registry URL where applicable

Look for hidden fallbacks to:

- localhost fixed ports
- docker-compose hostnames
- kafka:9092
- redis:6379
- environment-specific defaults

If such fallback exists, classify as a regression.

============================================================
4. AGGREGATORS OLD STAGE — HIGH PRIORITY
============================================================

This is one of the most important checks.

Inspect exactly what the old "Aggregators" stage did.

Determine:

- which services/processes it started
- which image/JAR/module it used
- what Kafka topics it consumed
- what Kafka topics it produced
- whether it transformed/aggregated data needed by IntegrationTest
- whether the 14 existing scenarios depended on its outputs
- whether it populated Redis or any other state
- whether it was just infrastructure or actual business-flow processing

Then trace the current Testcontainers tests.

For each old Aggregator responsibility, determine whether it is now:

A. executed in-process by the test/application
B. represented by an existing repository stub/test double
C. no longer required because the tested boundary changed
D. still required but missing

Do NOT accept:

"Tests pass without it"

as proof that Aggregators are no longer required.

Prove WHY they are no longer required or WHERE their responsibility moved.

Check whether assertions were changed in a way that simply avoids needing
Aggregator output.

Compare relevant integration assertions against develop.

If Aggregators previously represented a real part of the 14 scenarios and that
behaviour is now missing rather than replaced, classify:

    STILL REQUIRED BUT MISSING

============================================================
5. OLD MAVEN CLEAN INSTALL STAGE
============================================================

Inspect the old:

    mvn clean install

command and reactor scope.

Compare with the current:

    mvn clean verify -Pci-testcontainers-snapshot

or actual current command.

Determine:

- modules built before
- modules built now
- test phases executed before
- test phases executed now
- install vs verify implications
- whether downstream stages previously relied on artifacts installed into the
  local Maven repository
- whether the new image build still receives the required application JAR
- whether generated artifacts are equivalent

Verify that removal of `install` does not accidentally omit something needed by:

- image build
- integration test module
- generated schemas/classes
- downstream modules

If `verify` is sufficient, prove why from the reactor and artifact usage.

============================================================
6. OLD COMMAND ADAPTOR STAGE
============================================================

Inspect exactly what the old "Command Adaptor" stage did.

Important:

Do not use the displayed duration as Docker build duration.

Determine separately whether the old stage:

- built the image
- started cmd-adaptor-sns as a Docker container
- supplied configuration
- mounted files
- waited for readiness
- kept the application running during Integration Tests
- performed health checks
- exposed ports
- depended on Compose infrastructure

Then inspect the new Testcontainers integration path.

Determine how real cmd-adaptor-sns application behaviour is now executed.

Possible legitimate replacements include:

- Spring application context started directly by Maven tests
- application component instantiated inside the integration-test JVM
- another repository-standard test bootstrap

Verify that the new tests are exercising REAL application processing and not only:

- test helper logic
- a mocked service
- Kafka produce/consume smoke behaviour

Trace at least one representative real scenario end to end:

    test input
        ->
    Kafka input
        ->
    real cmd-adaptor-sns processing
        ->
    output/state
        ->
    existing business assertion

Identify the exact production classes participating.

If the old containerized Command Adaptor has been removed from the integration
path, prove that the real application is now executed through an equivalent
test bootstrap.

============================================================
7. PRE-INTEGRATION TESTS OLD STAGE — HIGH PRIORITY
============================================================

Inspect the exact old "Pre-Integration Tests" implementation.

Determine what it did before the integration suite.

Look for responsibilities such as:

- topic creation
- schema creation
- schema registration
- Kafka configuration
- Redis initialization
- test-data initialization
- configuration generation
- environment validation
- readiness waiting
- application health checking
- artifact copying
- certificate setup
- template/resource preparation

For every responsibility, find the equivalent current Testcontainers
implementation.

Classify every old responsibility as:

- handled by shared Testcontainers fixture
- handled by Maven/test setup
- unnecessary with concrete technical reason
- MISSING

Do not assume container startup replaces all initialization.

============================================================
8. OLD TESTCONTAINERS SMOKE TESTS
============================================================

The old pipeline previously had a narrow:

    Testcontainers Smoke Tests

stage.

The current parity analysis showed:

- MinimalRedisTest is present but filtered
- KafkaSchemaRegistrySmokeTest is present but filtered
- smoke test count in current CI = 0
- real SNS application scenarios = 14

Determine whether excluding the standalone smoke tests is correct.

Check whether the 14 real integration scenarios already exercise:

- Redis startup/use
- Kafka startup/use
- Schema Registry startup/use
- actual schema serialization/deserialization

If the same infrastructure failure would cause the real integration suite to
fail, then standalone smoke tests may legitimately be redundant in CI.

If important infrastructure behaviour is ONLY covered by the filtered smoke
tests and not the real suite, flag it.

Do not require duplicate smoke tests merely for test-count symmetry.

============================================================
9. OLD INTEGRATION TESTS STAGE
============================================================

Inspect the old exact Integration Tests Maven command.

Compare it with the current Testcontainers Maven command.

Confirm that:

- the same 14 relevant Cucumber/application scenarios are executed
- feature files are still the same where applicable
- step definitions remain meaningful
- test data is equivalent
- tags have not narrowed business coverage
- failure scenarios still execute
- assertions have not been weakened

The previous parity audit already found 14 vs 14.

This step should focus on BEHAVIOURAL equivalence, not recounting tests.

============================================================
10. TOPIC TEMPLATE / RESOURCE PREPARATION
============================================================

Inspect any topic-template/resource restoration or preparation that historically
happened before integration execution.

The current branch appears to have had changes around topic-template resources.

Verify:

- required topic templates still exist
- required resources are copied/generated
- current Testcontainers fixture uses the same semantically required topic
  definitions
- no resource was accidentally deleted during pilot cleanup
- no required file is now being silently replaced with a simplified hard-coded
  equivalent

If templates are no longer required, prove which code replaced their behaviour.

============================================================
11. SCHEMA REGISTRY FUNCTIONAL PARITY
============================================================

Compare old and new Schema Registry behaviour.

Determine:

- how Schema Registry was supplied previously
- what subjects/schemas were used
- how schemas were registered
- how application serializers/deserializers resolved them
- whether compatibility settings mattered

Verify the new Testcontainers path provides equivalent functionality.

Do not count a successful standalone register/retrieve smoke operation as enough.

The real application scenarios must use the Testcontainers Schema Registry where
schema-backed messages are involved.

============================================================
12. APPLICATION CONFIGURATION PARITY
============================================================

Compare effective configuration between old Compose integration execution and
new Testcontainers integration execution.

Focus only on configuration relevant to tested behaviour.

Check:

- Kafka endpoints
- Redis endpoints
- Schema Registry
- topic names
- application ID
- consumer group
- serialization
- retry configuration
- polling
- command/output topics
- required feature flags

Identify any branch change that changes BUSINESS behaviour rather than merely
redirecting infrastructure endpoints.

Infrastructure migration should not silently alter application semantics.

============================================================
13. EXTERNAL SERVICES / MOCKS / STUBS
============================================================

Determine whether any old integration scenario depended on services other than:

- Redis
- Kafka
- Schema Registry
- cmd-adaptor-sns

If yes:

- identify each service
- determine how it was provided on develop
- determine how it is provided now

Look especially for old Compose services such as Aggregators or other helper
services.

If replaced by mocks/stubs:

- check whether those mocks/stubs already existed on develop
- check whether the replacement changes the integration boundary

Flag newly introduced mocks that substantially reduce real integration coverage.

============================================================
14. PIPELINE ORDERING / DEPENDENCY PARITY
============================================================

Verify the new ordering is technically valid.

Current shape appears approximately:

    Build and Test with Testcontainers
        ->
    Build Command Adaptor Image
        ->
    Trivy

Check whether any test previously validated the BUILT Docker image itself.

If the old integration tests actually executed the Docker image produced by the
pipeline, but the new tests execute application classes BEFORE the image is
built, explicitly state this architectural difference.

Determine whether this matters for acceptance.

Distinguish:

A. application integration correctness
B. container image runtime correctness

Verify that Story 1 image smoke/runtime validation still provides coverage for B.

Do not conflate Maven application tests with Docker image validation.

============================================================
15. BUILD COMMAND ADAPTOR IMAGE STAGE
============================================================

Inspect the current image-build stage.

Verify it still produces the expected:

    docker-compose-command-adaptor:latest

or actual required image.

Check:

- JAR source
- required OTel JAR
- runtime user
- command
- envconsul
- expected image configuration

Verify the Testcontainers pipeline restructuring did not accidentally stop
building the production-equivalent command-adaptor image.

============================================================
16. BUILD CACHE IS NOT HIDING MISSING WORK
============================================================

Because the current image build is around ~20 seconds, verify from BuildKit
output that the speed is from valid cache reuse.

Look for evidence such as:

- setup layers CACHED
- application JAR layer rebuilt when appropriate
- image export completed
- image inspect succeeded

Do not interpret a skipped Docker build or stale pre-existing image as cache
success.

Verify the resulting image was actually produced by the current pipeline run.

============================================================
17. TRIVY PARITY
============================================================

Compare old and new Trivy execution.

Verify:

- the same intended image/artifact is scanned
- vulnerability scanning is not now scanning an older cached image
- scan failure behaviour remains equivalent
- no required scan was removed during pipeline simplification

Do not perform vulnerability analysis; only check pipeline responsibility parity.

============================================================
18. FAILURE BEHAVIOUR
============================================================

Compare failure semantics.

Old pipeline should fail when important infrastructure/application checks fail.

Verify current pipeline fails when:

- Testcontainers cannot start
- Kafka unavailable
- Redis unavailable
- Schema Registry unavailable
- application cannot start
- real integration scenario fails
- Maven build fails
- image build fails
- Trivy gate fails where configured

Look for:

    || true
    set +e
    swallowed exit codes
    continue-on-error equivalents
    shell constructs masking failure

Flag any newly weakened failure gate.

============================================================
19. TESTCONTAINERS DEPENDENCE ON EARLIER PIPELINE SERVICES
============================================================

This is a critical check.

Verify the Testcontainers step is self-contained with respect to:

- Redis
- Kafka
- Schema Registry

It must not succeed only because some earlier pipeline stage has already started
those services.

Given the new pipeline no longer visibly has separate Kafka & Redis stages, this
should be easier to prove.

Search for static connection defaults and environment leakage.

============================================================
20. CLEAN ENVIRONMENT ASSUMPTION
============================================================

Reason from pipeline configuration whether the Testcontainers stage would pass on
a fresh CI worker with:

- Docker available
- repository cloned
- required credentials available
- NO pre-existing Kafka
- NO pre-existing Redis
- NO pre-existing Schema Registry
- NO pre-existing command-adaptor container

If not, identify the hidden dependency.

Do not actually destroy infrastructure on the current machine to test this.

============================================================
21. EXPLAIN THE PERFORMANCE DIFFERENCE
============================================================

Based on actual old/new responsibilities, explain where the ~23 minute -> ~3
minute change comes from.

Break it down qualitatively.

For example:

- removed Compose environment startup
- Aggregator containers no longer needed / replaced
- application runs inside Maven test context rather than long-lived Docker flow
- Testcontainers starts only required dependencies
- BuildKit registry cache reduces image-build cost
- old integration waiting/readiness path removed
- reduced orchestration overhead

Do NOT invent exact savings unless directly measurable from pipeline evidence.

Most importantly:

State whether any meaningful old responsibility was lost to achieve the speedup.

============================================================
22. FINAL RESPONSIBILITY TABLE
============================================================

Return a table in CHAT ONLY.

Do not create a file.

Use columns:

OLD STAGE
OLD RESPONSIBILITY
CURRENT REPLACEMENT
STATUS
EVIDENCE

Required rows include at minimum:

- Kafka & Redis
- Aggregators
- mvn clean install
- Command Adaptor
- Pre-Integration Tests
- Testcontainers Smoke Tests
- Integration Tests
- Trivy

STATUS must be exactly one of:

- PRESERVED
- REPLACED EQUIVALENTLY
- LEGITIMATELY REMOVED
- MISSING
- UNCERTAIN

============================================================
FINAL RESPONSE
============================================================

Return only:

## Overall Verdict

Choose exactly one:

- FULL FUNCTIONAL PARITY
- FUNCTIONAL PARITY WITH EXPLAINED ARCHITECTURAL CHANGES
- FUNCTIONAL GAP FOUND

## Old-to-New Responsibility Map

Provide the requested table.

## High-Risk Checks

State PASS / FAIL / UNCERTAIN for:

- Aggregator responsibility preserved
- Pre-Integration responsibility preserved
- real cmd-adaptor-sns processing exercised
- real 14 business scenarios preserved
- application uses Testcontainers endpoints
- no hidden Compose dependency
- Schema Registry/Avro behaviour preserved
- Docker image still built and runtime-valid
- Trivy still scans the intended image
- failure gates are not weakened

## Architectural Differences

List only meaningful differences between old and new execution models.

## Missing Functionality

List only functionality that existed on develop and has no valid replacement.

Write:

    None

if none exists.

## Performance Conclusion

In no more than 5 sentences:

Explain whether the approximately 23-minute to 3-minute improvement is
technically credible based on the responsibility comparison.

Explicitly state whether the speedup appears to come from orchestration
simplification/optimisation or from lost functional coverage.

DO NOT MODIFY ANY FILE.
DO NOT CREATE DOCUMENTATION.
DO NOT CREATE A TODO.
```

Bu kontrol temiz çıkarsa artık üç ayrı şeyi kanıtlamış olacağız:

1. **Scenario parity:** `14 → 14`, skip yok.
2. **Functional responsibility parity:** eski stage’lerin yaptığı gerekli işler yeni yapıda karşılanıyor.
3. **Pipeline integrity:** Docker image build + Trivy + gerçek application processing hâlâ var.

Özellikle `Aggregators`, `Pre-Integration Tests` ve **“eski testler Docker container içindeki uygulamayı çalıştırıyordu, yeniler JVM içindeki application context’i mi çalıştırıyor?”** kısmını atlamamak lazım. Sonuncusu önemli; test coverage aynı olsa bile execution boundary değişmiş olabilir. Bu değişiklik yanlış olmak zorunda değil, ama bilinçli ve yeterli coverage ile desteklenmiş olması gerekiyor.
