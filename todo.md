Evet, bunu geri almak doğru. `topic-templates.txt` ile birlikte `pre-integration-test/app.py` içindeki mevcut topic yönetimini refactor etmişiz; bu, Testcontainers migration için zorunlu değil ve scope’u gereksiz büyütüyor. Üstelik eski pilot kararlarında `pre-integration-test/app.py`’nin değiştirilmemesi özellikle sınır olarak belirtilmişti.  Son patch’te README’lerde silinmiş smoke testlere referanslar ve pilot döneminden kalan dependency/property izleri de hâlâ bulunuyor.

Ben Codex’e aşağıdaki gibi **çok kontrollü bir final cleanup prompt** verirdim. Özellikle “çalışan 6:41 pipeline’a dokunma, sadece scope pollution temizle” mantığında hazırladım:

```text
Perform a FINAL SCOPE-CORRECTION AND CLEANUP of the current branch.

This is a CODE CLEANUP task.

The current implementation is functionally working and the CI pipeline is green.
Do NOT redesign the Testcontainers solution.
Do NOT optimise anything further.
Do NOT introduce new abstractions.
Do NOT create documentation/reports/TODO files.

The goal is to make the final diff minimal, reviewable and strictly aligned
with the original Container / CI optimisation scope.

======================================================================
CRITICAL RULE
======================================================================

PRESERVE the currently working behaviour:

- Build and Test with Testcontainers
- the real SNS business integration suite
- the 14-scenario coverage protection
- Testcontainers Redis/Kafka/Schema Registry infrastructure
- downstream aggregate Testcontainers support
- Docker failure must fail CI
- Build Command Adaptor Image
- BuildKit / registry cache behaviour
- Validate Built Image Runtime
- BuiltImageRuntimeIntegrationTest
- TestcontainersFailureDiagnostics required by that runtime test
- Trivy stage
- legacy Compose path remaining available

The latest green pipeline is the functional baseline.

Do not make unrelated changes.

======================================================================
1. REVERT THE OUT-OF-SCOPE TOPIC-TEMPLATE REFACTOR
======================================================================

During the Testcontainers work, the existing hard-coded Kafka topic list from:

    cmd-adaptor-sns-integration-tests/
      src/test/resources/docker-compose/pre-integration-test/app.py

was extracted into:

    cmd-adaptor-sns-integration-tests/
      src/test/resources/docker-compose/pre-integration-test/topic-templates.txt

This refactor was NOT required by the Testcontainers migration and is outside
the scope of this task.

Restore the legacy pre-integration implementation to its original behaviour.

Use origin/develop as the source of truth for the pre-existing implementation.

Specifically inspect:

    git diff origin/develop -- \
      cmd-adaptor-sns-integration-tests/src/test/resources/docker-compose/pre-integration-test/app.py \
      cmd-adaptor-sns-integration-tests/src/test/resources/docker-compose/pre-integration-test/Dockerfile

Restore the original topic management in app.py:

- topic_names must again be defined in app.py as in origin/develop
- restore the original SNS-specific topic additions
- remove TOPIC_TEMPLATE_PATH
- remove pathlib/Path if no longer needed
- remove load_shared_topic_templates(...)
- remove the external topic-template loading behaviour

Restore the pre-integration-test Dockerfile:

- remove the branch-added:

      COPY topic-templates.txt /usr/local/bin

- otherwise preserve the origin/develop behaviour

Delete:

    cmd-adaptor-sns-integration-tests/
      src/test/resources/docker-compose/pre-integration-test/topic-templates.txt

IMPORTANT:

Do NOT casually reset whole files if they contain some other legitimate
post-develop change.

First compare against origin/develop.

Revert ONLY the topic-template extraction/refactor and any code introduced
solely to support it.

The legacy Compose/pre-integration path should behave exactly as it did before
this Testcontainers work.

======================================================================
2. KEEP TESTCONTAINERS TOPIC PROVISIONING SELF-CONTAINED
======================================================================

Removing topic-templates.txt must NOT break the Testcontainers suite.

Currently SnsTestcontainersEnvironment may depend on:

    SHARED_TOPIC_TEMPLATE_RESOURCE
    loadSharedTopicTemplates(...)

Remove that dependency on the legacy pre-integration resource.

Testcontainers must provision the topics it requires independently.

Do NOT refactor the legacy app.py again to achieve this.

Instead:

- inspect all current SNS feature files
- inspect SnsSteps.java
- inspect command/snapshot/runlog topic usage
- inspect application startup requirements
- inspect aggregate requirements
- determine the actual Kafka topics required by the Testcontainers SNS suite

Keep Testcontainers-specific topic provisioning inside the Testcontainers test
infrastructure.

Use the smallest clear implementation.

It is acceptable for SnsTestcontainersEnvironment to maintain the SNS test
topics required by the Testcontainers environment.

Do NOT create another shared TXT/YAML/JSON/config abstraction.

Do NOT move legacy production/Compose configuration for architectural purity.

The objective is:

    legacy Compose path
        -> retains its original topic management

    Testcontainers path
        -> owns only the topic provisioning required for Testcontainers

The two paths do NOT need to share a new configuration abstraction as part of
this task.

======================================================================
3. PRESERVE TOPIC PARITY
======================================================================

Do not accidentally remove topics required by the 14 existing SNS scenarios.

Before modifying SnsTestcontainersEnvironment, derive the required topics from
the actual current code and tests.

Verify at minimum the requirements around:

- SNS input
- CDLZ input / lookup topics
- party command/snapshot topics
- object command/snapshot topics
- location command/snapshot topics
- event command/snapshot topics
- service command/snapshot topics
- runlog
- error/suspense topics where actually required
- any topics required by the aggregate services

Do not invent topics that the suite does not need.

Do not remove a topic merely because its name is not directly referenced by a
Cucumber feature if application/Kafka Streams startup requires it.

The final authority is successful execution of the real suite.

======================================================================
4. CLEAN THE ROOT README
======================================================================

Review:

    README.md

There are references to standalone Testcontainers smoke tests such as commands
matching:

    *RedisTest
    *SmokeTest

Those standalone pilot tests have now intentionally been removed:

    MinimalRedisTest
    KafkaSchemaRegistrySmokeTest

Therefore remove stale documentation referring to them.

Keep documentation for the real supported Testcontainers paths.

The README should describe only commands/classes that actually exist.

Keep useful commands such as the real Testcontainers integration profiles where
they are still valid, for example:

    mvn -pl cmd-adaptor-sns-integration-tests -am \
      clean verify -Plocal-testcontainers

and:

    mvn -pl cmd-adaptor-sns-integration-tests -am \
      clean verify -Plocal-testcontainers-snapshot

Do NOT expand the README.

This is cleanup only.

======================================================================
5. CLEAN THE INTEGRATION-TEST README
======================================================================

Review:

    cmd-adaptor-sns-integration-tests/README.md

Remove the same stale standalone smoke-test instructions.

Do not refer to:

    MinimalRedisTest
    KafkaSchemaRegistrySmokeTest
    *RedisTest
    *SmokeTest

unless such tests actually still exist after cleanup.

Keep concise instructions for:

- Testcontainers command-path profile if still supported
- Testcontainers snapshot/full integration profile
- legacy Compose path where intentionally retained

Do not rewrite unrelated documentation.

======================================================================
6. REMOVE UNUSED PILOT DEPENDENCIES / PROPERTIES
======================================================================

Review:

    cmd-adaptor-sns-integration-tests/pom.xml

The original Redis pilot introduced items including:

    jedis.version
    redis.clients:jedis

MinimalRedisTest has now been removed.

Search the COMPLETE current repository before changing the POM.

If there is no remaining production/test usage of Jedis:

- remove jedis.version
- remove redis.clients:jedis

Do not assume.
Prove usage/non-usage with repository search.

Also audit other configuration introduced only for the deleted standalone
smoke tests, including where applicable:

- stale comments mentioning Redis smoke/wiring pilot
- surefire.excludedGroups
- testcontainers group/tag configuration
- properties used only by deleted tests
- junit-jupiter Testcontainers integration dependency
- any Maven configuration whose only consumer was:
      MinimalRedisTest
      KafkaSchemaRegistrySmokeTest

Remove something ONLY if it is genuinely unused.

IMPORTANT:

Do NOT remove dependencies required by:

- SnsTestcontainersEnvironment
- TestcontainersSuiteCoverageTest
- BuiltImageRuntimeIntegrationTest
- TestcontainersFailureDiagnostics
- current Cucumber integration execution

In particular, preserve the Testcontainers core/Kafka dependencies required by
the final implementation.

======================================================================
7. DO NOT REMOVE THESE FINAL TESTS
======================================================================

These are NOT prototypes and must remain:

    BuiltImageRuntimeIntegrationTest.java
    TestcontainersFailureDiagnostics.java
    TestcontainersSuiteCoverageTest.java

BuiltImageRuntimeIntegrationTest protects the Docker packaging/runtime boundary.

TestcontainersSuiteCoverageTest protects against the previous false-green /
zero-scenario condition.

Do not remove or weaken them.

======================================================================
8. CHECK FOR OTHER PILOT REMNANTS
======================================================================

Search the final branch for references to:

    MinimalRedisTest
    KafkaSchemaRegistrySmokeTest
    topic-templates.txt
    load_shared_topic_templates
    SHARED_TOPIC_TEMPLATE_RESOURCE
    jedis.version
    redis.clients.jedis
    Redis smoke
    smoke/wiring pilot
    *RedisTest
    *SmokeTest

For each match:

- determine whether it belongs to the final architecture
- remove it if it only refers to deleted pilot/prototype behaviour
- preserve it if there is a concrete final runtime requirement

Do not perform general refactoring outside these remnants.

======================================================================
9. SCOPE DIFF REVIEW
======================================================================

After cleanup, review:

    git diff origin/develop --stat
    git diff origin/develop

Pay special attention to files that were modified during experimentation.

The final diff should explain itself as:

1. Docker/image build optimisation
2. Testcontainers integration migration
3. CI pipeline simplification
4. business-suite coverage protection
5. fresh built-image runtime validation

It should NOT contain unrelated:

- topic configuration refactoring
- generic test infrastructure redesign
- pilot scripts/tests
- experimental documentation
- unused dependencies

======================================================================
10. VALIDATE LEGACY PRE-INTEGRATION PATH STRUCTURALLY
======================================================================

Confirm that after the revert:

    pre-integration-test/app.py

again contains the original topic behaviour from origin/develop.

Confirm:

- no dependency on topic-templates.txt
- Dockerfile does not copy topic-templates.txt
- deleted topic-templates.txt has no references
- original SNS topic creation semantics are preserved

Do not redesign or improve the legacy path.

======================================================================
11. VALIDATE THE TESTCONTAINERS BUSINESS SUITE
======================================================================

Run the same effective command used by:

    Build and Test with Testcontainers

currently expected to be equivalent to:

    mvn clean verify -Pci-testcontainers-snapshot

Use the actual repository command if it differs.

Acceptance:

- Docker/Testcontainers connects successfully
- Redis starts
- Kafka starts
- Schema Registry starts
- required aggregators start
- cmd-adaptor application starts
- real SNS Cucumber scenarios execute
- expected scenario coverage guard passes
- 14 current business scenarios execute, unless source inventory legitimately
  changed
- failures = 0
- errors = 0
- intended skipped scenarios = 0
- no Tests run: 0 false-green
- BUILD SUCCESS

======================================================================
12. VALIDATE BUILT IMAGE RUNTIME
======================================================================

Preserve and execute the existing:

    ci-built-image-runtime-smoke

path / BuiltImageRuntimeIntegrationTest.

Expected:

    Tests run: 1
    Failures: 0
    Errors: 0
    Skipped: 0

The freshly built:

    docker-compose-command-adaptor:latest

must start and reach readiness.

Do not replace this with a generic smoke test.

======================================================================
13. DEFAULT / LEGACY REGRESSION CHECK
======================================================================

Run the cheapest appropriate default Maven regression check to ensure the
cleanup did not damage the existing non-Testcontainers build behaviour.

Do not restore the old slow CI pipeline.

Do not run unnecessary experimental scripts.

======================================================================
14. FINAL CLEANLINESS CHECK
======================================================================

Before finishing, confirm all of the following:

- topic-templates.txt deleted
- no reference to topic-templates.txt remains
- app.py topic management restored to pre-branch/origin-develop behaviour
- pre-integration-test Dockerfile restored regarding topic template handling
- Testcontainers creates its own required SNS topics
- real business suite still passes
- stale smoke-test README instructions removed
- deleted test classes are not referenced
- unused Jedis dependency/property removed if confirmed unused
- no required Testcontainers dependency removed
- BuiltImageRuntimeIntegrationTest remains
- TestcontainersFailureDiagnostics remains
- TestcontainersSuiteCoverageTest remains
- Story 1 Docker/BuildKit optimisation remains untouched
- .drone.star pipeline architecture remains unchanged unless a cleanup is
  strictly required for a removed reference
- no generated logs/reports/artifacts added to git
- no unrelated formatting/refactoring

======================================================================
FINAL RESPONSE
======================================================================

Do not create a report file.

Return only:

1. Out-of-scope changes reverted
2. Files changed
3. Legacy app.py topic handling restored: YES/NO
4. topic-templates.txt removed and all references removed: YES/NO
5. Testcontainers topic provisioning approach after cleanup
6. README stale references removed
7. Unused dependencies/properties removed, with exact names
8. Main Testcontainers suite result:
      scenario count / failures / errors / skipped
9. BuiltImageRuntimeIntegrationTest result
10. Default regression result
11. Final git diff/status summary
12. Remaining blocker: none / exact blocker

Do not propose additional architecture work.
Do not add another abstraction.
Do not optimise anything else.
Keep the final branch minimal and merge-review friendly.
```

Burada kritik nokta şu: **`app.py`’yi eski haline döndürürken Testcontainers’ı bozmasına izin vermiyoruz.** Testcontainers kendi ihtiyacı olan SNS topic’lerini kendi test infrastructure’ında yaratacak; ama bunun uğruna mevcut legacy topic yönetimini ortak TXT dosyasına taşıyıp production/Compose tarafında gereksiz refactor yapmayacağız.

Bu şekilde final diff’in hikâyesi de çok temiz kalır: **Docker build optimisation + Testcontainers migration + CI simplification + coverage guard + built-image validation.** Bunun dışında “topic configuration redesign” gibi review’da neden yaptığımızı açıklamak zorunda kalacağımız bir değişiklik kalmaz. 
