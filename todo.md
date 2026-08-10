Evet, **şimdi gerçek eksik ortaya çıkmış**. Bu audit bence tam ihtiyacımız olan şeyi yakalamış.

İyi tarafı şu: esas integration davranışı korunmuş görünüyor:

* Kafka + Redis + Schema Registry → Testcontainers ile karşılanıyor ✅
* Aggregators → gerçek aggregate container'larıyla karşılanıyor ✅
* Pre-integration hazırlıkları → shared fixture içine taşınmış ✅
* 14 gerçek SNS scenario → 14'ü de çalışıyor ✅
* `skipped = 0` ✅
* gerçek `cmd-adaptor-sns` processing → çalışıyor ✅
* dynamic Testcontainers endpoints → kullanılıyor ✅
* Avro / Schema Registry → korunuyor ✅
* Trivy → aynı image'ı scan ediyor ✅
* failure gates → zayıflatılmamış ✅

**Tek FAIL şu:**

> Freshly built `docker-compose-command-adaptor:latest` image artık CI'da gerçekten çalıştırılmıyor ve readiness kontrolü yapılmıyor.

Eski CI:

```text
build Docker image
      ↓
docker-compose up command-adaptor
      ↓
gerçek container çalışıyor
      ↓
readiness
      ↓
integration tests
```

Yeni CI:

```text
Maven JVM içinde gerçek CmdAdaptorApplication
      ↓
14 integration scenario
      ↓
PASS

sonra

Docker image build
      ↓
docker inspect
      ↓
Trivy
```

Yani şu anda test ettiğimiz:

```text
application code works       ✅
integration behaviour works  ✅
Docker image builds          ✅
Docker image scans           ✅

Docker image actually boots  ❌
```

Bu küçük ama **gerçek bir coverage gap**.

### Bence çözüm

Eski 20 dakikalık Compose yolunu geri getirmemeliyiz.

Sadece image build'den sonra çok dar bir:

```text
Validate Built Image Runtime
```

step'i eklenmeli.

Akış:

```text
Build and Test with Testcontainers       ~1:12
             ↓
Build Command Adaptor Image              ~0:20
             ↓
Validate Built Image Runtime             ~?? 20-60 sec
             ↓
Trivy                                    ~0:44
```

Bu step:

1. **az önce build edilen local image'ı** kullanmalı,
2. gerekli minimum Kafka/Redis/Schema Registry altyapısını Testcontainers ile açmalı,
3. `cmd-adaptor-sns`'i bu kez **Docker image olarak** başlatmalı,
4. production entrypoint ile boot ettiğini doğrulamalı,
5. readiness/health kontrolü yapmalı,
6. sonra container'ları kapatmalı.

**14 scenario'yu tekrar Docker image üzerinde çalıştırmaya gerek yok.** Onları zaten JVM/Testcontainers path doğruluyor. Buradaki amaç sadece packaging/runtime boundary:

```text
JAR
 + Dockerfile
 + image
 + envconsul
 + runtime user
 + command
 + configuration
 = gerçekten boot ediyor mu?
```

Böylece duplicate 14-test execution yapmadan eski CI'ın kaybolan son sorumluluğunu geri kazanırsın.

Copilot'a bunu ver:

```text
Fix the single remaining CI functional-parity gap identified by the completed
audit.

This is a CODE/PIPELINE FIX task.

Do not create documentation.
Do not create reports.
Do not create another TODO.
Do not redesign the existing Testcontainers migration.
Do not restore the old Docker Compose integration pipeline.

The audit established that:

- all 14 real SNS integration scenarios are preserved
- skipped = 0
- Kafka/Redis/Schema Registry responsibilities are preserved
- Aggregator responsibilities are preserved
- pre-integration responsibilities are preserved
- real cmd-adaptor-sns processing is exercised
- Testcontainers dynamic endpoints are used
- Schema Registry/Avro behaviour is preserved
- Trivy still scans the intended image
- failure gates remain intact

The ONLY identified functional gap is:

The freshly built:

    docker-compose-command-adaptor:latest

image is built and inspected, but is no longer actually started and
readiness-validated in CI.

Old develop CI exercised the freshly built command-adaptor Docker container.
The new pipeline currently exercises CmdAdaptorApplication in-process during
the Testcontainers suite and builds the Docker image afterwards.

Close ONLY this gap.

============================================================
TARGET PIPELINE
============================================================

Keep the current efficient structure:

    Build and Test with Testcontainers
                |
                v
    Build Command Adaptor Image
                |
                v
    Validate Built Image Runtime
                |
                v
    Scan with Trivy

Do NOT restore:

- old Kafka & Redis Compose stage
- old Aggregators Compose stage
- old Command Adaptor Compose execution
- old Pre-Integration Tests stage
- old Integration Tests Compose stage

The 14 business scenarios must continue to execute only once through the
existing Testcontainers integration path.

============================================================
1. REUSE THE FRESHLY BUILT IMAGE
============================================================

The runtime validation MUST exercise the exact local Docker image produced by
the immediately preceding image-build step.

Expected image name is currently:

    docker-compose-command-adaptor:latest

Verify the actual pipeline value before changing anything.

Do not rebuild the image during runtime validation.

Do not substitute a registry image.

Do not validate an image left over from another build.

Ensure the image exists locally before starting it.

============================================================
2. START THE IMAGE AS A REAL CONTAINER
============================================================

The validation must start cmd-adaptor-sns from the Docker image itself.

It must NOT start:

    CmdAdaptorApplication

directly inside the Maven/JUnit JVM as the SUT for this check.

The purpose is specifically to validate the Docker packaging/runtime boundary.

Use the production-equivalent image:

- Dockerfile
- ENTRYPOINT/CMD
- runtime user
- envconsul behaviour where applicable
- Java runtime
- required application JAR
- OpenTelemetry JAR/configuration where applicable

Do not override the production command with an artificial test command unless
absolutely required for safe configuration.

============================================================
3. PROVIDE ONLY THE MINIMUM REQUIRED DEPENDENCIES
============================================================

Determine exactly which dependencies cmd-adaptor-sns requires in order to boot
and become ready.

Reuse the existing maintained Testcontainers infrastructure where practical.

Likely dependencies include:

- Redis
- Kafka
- Schema Registry

Do not bring back the full Docker Compose environment.

Do not start unrelated services.

Do not start Aggregators unless the command-adaptor process genuinely requires
them simply to become ready.

This is a runtime smoke validation, not another full business-suite execution.

============================================================
4. NETWORKING
============================================================

The image container and required dependency containers must communicate through
an isolated Docker/Testcontainers network.

Because cmd-adaptor-sns itself is now a container, configure it with the
container-to-container endpoints.

Do not pass test-JVM mapped localhost ports to the SUT container where internal
Docker aliases should be used.

Use stable network aliases for:

- Kafka
- Redis
- Schema Registry

as appropriate.

Use the repository's actual configuration property/environment names.

Do not invent new production configuration names.

============================================================
5. READINESS
============================================================

Wait for actual cmd-adaptor-sns readiness.

Reuse an existing readiness mechanism where available.

Prefer:

- existing health/readiness endpoint
- existing startup log indicator
- existing application-level readiness mechanism

Use a bounded timeout.

Do not use a large arbitrary:

    sleep 60

or similar.

A successful `docker start` alone is NOT sufficient.

The application must remain running and reach its expected ready state.

============================================================
6. FAIL CORRECTLY
============================================================

The CI step must fail when:

- the image is missing
- the image cannot start
- the production command fails
- required runtime artifacts are missing
- Kafka/Redis/Schema Registry configuration is invalid
- the application exits unexpectedly
- readiness is not reached within the bounded timeout

Do not use:

    || true

or otherwise swallow the failure.

============================================================
7. FAILURE DIAGNOSTICS
============================================================

On failure, print useful runtime diagnostics to the CI console:

- command-adaptor container logs
- relevant dependency container logs where useful
- container exit status

Do not create or commit log files.

Do not dump secrets.

============================================================
8. CLEANUP
============================================================

After success or failure:

- stop/remove the runtime validation container
- clean Testcontainers dependencies/network
- do not leave CI Docker resources behind

Do not enable Testcontainers reuse.

============================================================
9. DO NOT DUPLICATE THE BUSINESS SUITE
============================================================

This runtime check must NOT rerun all 14 Cucumber scenarios.

The existing:

    Build and Test with Testcontainers

step already validates application/integration behaviour.

This new validation only needs to prove:

    freshly built Docker image
           +
    production runtime configuration
           +
    real process startup
           +
    readiness
           =
    valid runnable image

A narrow runtime smoke test is sufficient.

============================================================
10. PRESERVE PERFORMANCE
============================================================

The implementation should remain lightweight.

Do not recreate the old ~20-minute Compose orchestration.

The expected additional cost should be limited to the time required to start the
minimal dependency stack and command-adaptor image and verify readiness.

Do not sacrifice correctness for a timing target, but avoid unnecessary services
and duplicate test execution.

============================================================
11. DO NOT TOUCH STORY 1 IMPLEMENTATION
============================================================

Preserve the existing approved image-build optimisation:

- Dockerfile layer ordering
- .dockerignore
- default BuildKit builder
- registry cache
- feature-branch cache
- develop shared-cache policy

The runtime validation consumes the image produced by that implementation.

Do not redesign the image build.

============================================================
12. TRIVY ORDER
============================================================

The preferred order is:

    build image
        ->
    runtime validation
        ->
    Trivy

This ensures the same freshly built image is:

1. successfully built
2. successfully executed
3. readiness validated
4. scanned

Do not scan a different image reference.

============================================================
13. VALIDATE THE FIX
============================================================

Run the repository-owned validation possible locally.

Then ensure the CI pipeline invokes the new runtime validation step.

After implementation verify:

- 14 existing Testcontainers business scenarios still execute
- no scenario is newly skipped
- image build succeeds
- freshly built image starts
- readiness succeeds
- runtime smoke exits successfully
- Trivy still scans the same image
- no old Compose integration stages were restored

============================================================
14. KEEP THE DIFF MINIMAL
============================================================

Prefer reusing existing:

- SnsTestcontainersEnvironment
- network setup
- configuration values
- readiness mechanisms
- test utility code

But do not introduce awkward coupling merely to reuse code.

A small dedicated built-image runtime smoke test/helper is acceptable.

Do not build a generic Docker testing framework.

Remove any temporary implementation created while solving this.

============================================================
FINAL EXPECTED RESULT
============================================================

The functional responsibility map should become:

Kafka & Redis             REPLACED EQUIVALENTLY
Aggregators               REPLACED EQUIVALENTLY
mvn clean install         REPLACED EQUIVALENTLY
Command Adaptor app tests REPLACED EQUIVALENTLY
Pre-Integration Tests     REPLACED EQUIVALENTLY
Smoke Tests               LEGITIMATELY REMOVED
Integration Tests         REPLACED EQUIVALENTLY
Built Docker image runtime PRESERVED
Trivy                     PRESERVED

There must be no remaining functional gap caused by the pipeline migration.

============================================================
FINAL RESPONSE
============================================================

Do not create a file.

Return only:

- files changed
- runtime-validation mechanism used
- exact image validated
- readiness mechanism used
- local validation result
- CI pipeline step added/changed
- whether the 14 business scenarios remain unchanged
- remaining functional gap: YES/NO
```

Bu düzeltmeden sonra ben **23 → 3 dakika kıyasını çok daha güvenilir** görürüm.

Çünkü o zaman:

> “Testleri azaltmadık, eski fonksiyonları kaybetmedik, gerçek Docker image'ı da hâlâ çalıştırıyoruz; sadece Compose orchestration'ı ortadan kaldırdık.”

diyebilirsin.

Pipeline muhtemelen tam 2:56 kalmaz; örneğin 3:20–4:00 civarına çıkması şaşırtıcı olmaz. Ama bu hâlâ eski ~23 dakikaya göre çok büyük ve çok daha savunulabilir bir iyileşme.
