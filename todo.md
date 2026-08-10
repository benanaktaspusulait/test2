# CI/CD Optimization — Implementasyon Kontrol Listesi

Bu liste, `/Users/benanaktas/project/home-office/ci-cd-optimization` altındaki teknik gereksinimlerin `/Users/benanaktas/project/home-office/test2` koduyla karşılaştırılmasıyla oluşturuldu. Audit `b9cc3a2` üzerinde başladı; çalışma sırasında repo HEAD'i dışarıdan `e8ee7ff` (`eksikler`) commit'ine ilerledi.

Dokümantasyon üretme/güncelleme, Confluence paylaşımı, stakeholder onayı, owner/adoption kayıtları ve yalnız gerçek dış ortamda yapılabilen kabul koşuları bu listenin kapsamı dışındadır. Repo içindeki implementasyon maddelerinin tamamı kapatılmıştır.

## P0 — Geri getirilen CI dosyalarını doğrula

- [x] `b9cc3a2` taşıma commit'inde yanlışlıkla silinen CI/repo dotfile'larını eski `test2/` altından yeni repo köküne taşı:
  - `.drone.star`
  - `.drone/slack-functions.sh`
  - `.gitignore`
  - `.trivyignore`
- [x] Taşınan `.drone.star` dosyasının repo kökünden render/parse edildiğini doğrula.
- [x] Pipeline'ın mevcut build, integration-test, Trivy ve publish adımlarını yeniden ürettiğini smoke-test et.

**Kanıt:** `git diff --name-status af9445d..HEAD` bu dosyaların taşıma commit'inde `D test2/...` olarak kaybolduğunu gösterdi. Dosyalar `af9445d` blob'larından repo köküne geri alındı ve her biri `cmp` ile geçmişteki içeriğiyle birebir doğrulandı. `.drone.star` Python AST parse kontrolünden geçti; fake Drone context ile feature push, master push, MR, cron ve tag yolları render edildi. CI render'ında build, integration-test, Trivy ve notification adımları; tag render'ında publish/CD/cleardown pipeline'ları doğrulandı.

**Bitti sayılma koşulu:** Dotfile'lar repo kökünde mevcut, Drone config başarıyla render oluyor ve taşıma öncesindeki pipeline adımları kayıpsız mevcut. Dosyaların kalıcı olarak tracked olması yapılacak commit'e bağlıdır.

## P0 — Opt-in Testcontainers branch-CI yolunu gerçekten bağla

- [x] Geri getirilen RepoSync/Drone tanımına, varsayılan CI davranışını değiştirmeyen açık bir opt-in koşulu ekle.
- [x] Opt-in command-path çalıştırmasını `ci-testcontainers-cmd` profiline bağla.
- [x] Opt-in tam snapshot çalıştırmasını `ci-testcontainers-snapshot` profiline bağla.
- [x] DIND, `DOCKER_HOST`, host override ve Ryuk ayarlarını opt-in branch job'una ekle; job'u varsayılan olarak kapalı tut.

**Kanıt:** `.drone.star`, `TESTCONTAINERS_SUITE=cmd|snapshot` build parametresini ve `[testcontainers-cmd]` / `[testcontainers-snapshot]` commit-message işaretlerini destekliyor. Geçersiz veya eksik opt-in değerinde yalnız normal `CI` üretiliyor. Opt-in pipeline ayrı DIND service, `DOCKER_HOST=tcp://docker:2375`, `TESTCONTAINERS_HOST_OVERRIDE=docker`, disabled Ryuk ve private registry Docker auth config ile ilgili Maven profilini çalıştırıyor. Gerçek Drone koşusu repository push/CI yetkisi gerektiriyor ve henüz yapılmadı.

**Bitti sayılma koşulu:** Açıkça tetiklenen branch config'i Redis + Kafka + Schema Registry tabanlı command veya snapshot suite'ini üretiyor; normal branch pipeline bundan etkilenmiyor.

## P1 — Testcontainers container loglarını hata anında erişilebilir yap

- [x] Redis, ZooKeeper, Kafka, Schema Registry ve opt-in aggregate container'lara failure-time log capture ekle.
- [x] Startup exception ve test/assertion failure durumunda ilgili container loglarını test çıktısına bas.
- [x] Başarılı koşularda gereksiz tam log dökümünü engelle; failure diagnostics odaklı çalıştır.

**Kanıt:** `SnsTestcontainersEnvironment.dumpContainerLogs(...)` yalnız startup veya test failure yolundan `getLogs()` çağırıyor. JUnit 5 smoke testleri `TestcontainersFailureDiagnostics` watcher'ını, Cucumber ise failed `TestRunFinished` sonucunu kullanıyor. Runtime failure-injection doğrulaması özel FDP BOM engeli nedeniyle henüz çalıştırılamadı.

**Bitti sayılma koşulu:** Startup, JUnit assertion ve Cucumber run failure handler'ları container loglarını shutdown öncesinde test/CI çıktısına aktarıyor.

## P1 — Tek başına Redis smoke çalıştırmasının deterministik cleanup'ını tamamla

- [x] `MinimalRedisTest` dahil tüm JUnit smoke suite'i sonunda shared environment'ı kapatan lifecycle cleanup ekle.
- [x] Başarılı suite kapanışını root-store `CloseableResource`, test hatasını `TestWatcher` üzerinden aynı `shutdown()` yoluna bağla.
- [x] Kafka/Schema Registry ve Redis smoke sınıflarını aynı suite-level cleanup mekanizmasına bağla.

**Kanıt:** `TestcontainersFailureDiagnostics` root-store `CloseableResource` ile tüm JUnit smoke sınıfları bittikten sonra `shutdown()` çağırıyor. Bu tasarım class sırasına göre erken kapanmayı önlüyor. `shutdown()` tüm container'ları durdurup shared network'ü kapatıyor; Cucumber `TestRunFinished` de aynı yolu kullanıyor. Runtime leak kontrolü özel FDP BOM engeli nedeniyle henüz çalıştırılamadı.

**Bitti sayılma koşulu:** Shared suite kapanışında bütün container'lar durduruluyor ve Testcontainers network'ü kapatılıyor.

## P1 — Tam migrated suite yolunu tamamla

- [x] Command-path suite'ini `local-testcontainers` ve `ci-testcontainers-cmd` profillerine bağla.
- [x] Tam snapshot suite'ini `local-testcontainers-snapshot` ve `ci-testcontainers-snapshot` profillerine bağla.
- [x] Snapshot profillerinde Cucumber tag filtresi uygulamayarak mevcut 7 feature dosyasındaki 14 scenario'nun tamamını kapsa.
- [x] Testcontainers çalıştırmalarında Compose startup'ını kapat, fakat mevcut Compose yolunu parity kabulüne kadar koru.
- [x] Run başına dinamik topic suffix, consumer group ve Redis/test verisi izolasyonunu koru.

**Kanıt:** Shared fixture, dört opt-in Maven profili, dinamik endpoint/topic wiring ve Cucumber entegrasyonu repo içinde mevcut. Statik inventory 7 feature dosyası, 14 scenario ve sıfır `@ignore` scenario gösteriyor.

## P1 — Registry cache'in `develop` paylaşım döngüsünü tamamla

- [x] `develop` build'inin shared cache ref'ini seed/update edeceği pipeline yolunu ekle.
- [x] Feature branch build'inin hem shared `develop` hem branch-specific cache ref'ini kullanacağı yolu ekle.
- [x] JAR kopyalarını pahalı OS/envconsul katmanlarından sonra tutarak JAR değişiminde yalnız artefact ve sonraki katmanları invalidate et.
- [x] Buildx kullanılan yolda üretilen image'ı sonraki `docker-compose --no-build` adımı için `--load` ile yerel daemon'a yükle.

**Kanıt:** Dockerfile layer ordering ve `.dockerignore` implementasyonu mevcut. Cache komutlarını taşıyan `.drone.star` geri getirildi ve hem develop hem feature buildx dallarına `--load` eklendi. Gerçek shared-registry seed/reuse doğrulaması hâlâ develop ve sonraki feature-branch Drone koşularını gerektiriyor.

**Bitti sayılma koşulu:** Develop/feature cache yolları config'de mevcut ve Buildx çıktısı `--load` ile compose'un kullandığı local image tag'ine yükleniyor.

## Dış ortam kabul kontrolleri — implementasyon TODO'su değil

Aşağıdakiler repo içinde yazılacak kod değildir; yetkili ağ/credential ve gerçek Drone build'i gerektiren release kabul kapılarıdır:

- Artifactory/VPN erişimli ortamda command suite'i bir, snapshot suite'i iki kez çalıştırmak.
- Başarılı ve bilerek hatalı koşuda container logları ile cleanup/leak davranışını gözlemek.
- Gerçek branch Drone koşusunda DIND, host override ve disabled-Ryuk davranışını doğrulamak.
- Bir `develop` cache seed ve sonraki feature-branch reuse koşusunda registry cache hit/rebuild çıktılarını kontrol etmek.

Bu ortamda Artifactory DNS'i çözülemiyor (`HTTP 000`) ve `ARTIFACTORY_USERNAME`, `ARTIFACTORY_PASSWORD`, `JFROG_TOKEN` tanımlı değil. Bu kontroller bu nedenle çalıştırılamadı; implementasyon checkbox'ları olarak açık bırakılmadı.

## Doğrulanmış, yeniden yapılmaması gerekenler

- `cmd-adaptor-sns/Dockerfile` içinde pahalı OS/envconsul setup katmanı runtime JAR kopyalarından önce yer alıyor.
- RepoSync warning header, base image, runtime user, workdir ve `CMD` korunmuş.
- `cmd-adaptor-sns/.dockerignore` yalnız iki zorunlu runtime artefact'ını build context'e geri alıyor.
- Redis, Kafka ve Schema Registry shared Testcontainers network/fixture içinde tanımlı; host portları dinamik.
- Redis/Kafka/Schema Registry readiness kontrolleri ve Kafka/Schema Registry smoke testleri mevcut.
- Testcontainers Maven bağımlılıkları test scope'ta ve yol opt-in profiller altında.
- Mevcut Docker Compose yolu silinmemiş.

## Audit notu

`xmllint` ile kök ve integration-test POM dosyalarının XML yapısı doğrulandı; `bash -n` ile geri getirilen Slack script'i kontrol edildi; `.drone.star` tüm temel event ve opt-in varyantlarında statik olarak render edildi; render edilen feature-push step command bloklarının tamamı `/bin/sh -n` kontrolünden geçti; `git diff --check` temiz geçti. Docker daemon erişimi ayrıca doğrulandı.

Tam Maven doğrulaması iki kez denendi. `mvn -pl cmd-adaptor-sns-integration-tests -am -Plocal-testcontainers -Dtest='*RedisTest,*SmokeTest' -Dsurefire.failIfNoSpecifiedTests=false test` proje modeli oluşturulurken özel `uk.gov.ho.dacc.fdp:fdp-bom:3.2.11` çözülemedi. Yerelde cache'li `ileap-java17-mvn:1.3` image'ı gerekli Artifactory mirror ayarını içeriyor ancak BOM'u cache'inde ve çalışma ortamında Artifactory credentials yok. Bu nedenle gerçek smoke/tam-suite, leak/failure-injection ve develop/branch registry-cache koşuları tamamlanmış sayılmadı.
