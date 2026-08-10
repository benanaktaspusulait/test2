# Testcontainers Pipeline Optimizasyonu — TODO

Amaç: Entegrasyon testlerini Testcontainers ile çalıştırmak, Docker Compose tabanlı test yolunu kaldırmak ve CI pipeline süresini ölçülebilir şekilde kısaltmak.

## P0 — Test kapsamını Testcontainers'a taşı

- [x] `ci-testcontainers-cmd` profilini gerekli command-path senaryolarının tamamını çalıştıracak şekilde güncelle.
- [x] `ci-testcontainers-snapshot` profilini mevcut integration suite'indeki gerekli senaryoların tamamını çalıştıracak şekilde güncelle.
- [x] Kullanılmayan LocalStack bağımlılığını CI test yolundan kaldır.
- [x] Çıktısı tüketilmeyen `aggregate-matching` bağımlılığını CI test yolundan kaldır.
- [x] Testcontainers profillerinin beklenen feature ve scenario sayısının altına düşmesi halinde CI'ı fail eden otomatik kontrol ekle.

## P0 — Testcontainers'ı Compose yolunun yerine geçir

- [x] Normal CI ile ayrı Testcontainers pipeline'ının birlikte çalışmasını engelle; bir build'de yalnız bir integration-test yolu seçilsin.
- [x] Testcontainers snapshot suite'ini branch CI için varsayılan integration-test yolu yap.
- [x] Compose tabanlı `Kafka & Redis` adımını CI'dan kaldır.
- [x] Compose tabanlı `Aggregators` adımını CI'dan kaldır.
- [x] `Pre-Integration Tests` Compose startup adımını CI'dan kaldır.
- [x] Compose tabanlı `Integration Tests` adımını CI'dan kaldır.
- [x] Command adaptor image build'ini test startup bağımlılığı olmaktan çıkar.
- [x] Docker image build ve Trivy taramasını Compose test altyapısından ayır.
- [x] Publish adımlarının ihtiyaç duyduğu local/registry image tag'lerini yeni akışta üret.

## P0 — Tek Maven build/test akışı oluştur

- [x] Normal pipeline'daki `mvn clean install` ile ayrı Testcontainers pipeline'ındaki `mvn -am clean verify` tekrarını kaldır.
- [x] Compile, unit test ve integration testleri tek `mvn clean verify` reactor akışında çalıştır.
- [x] Testcontainers Maven profilini mevcut reactor üzerinde tek sefer çalıştır.
- [x] Maven workspace ve repository cache kullanımını aynı pipeline içinde koru.

## P1 — Container başlangıç süresini azalt

- [x] `MinimalRedisTest` çalışırken gereksiz ZooKeeper, Kafka ve Schema Registry container'larının başlamasını engelle.
- [x] Shared environment'a Redis-only ve messaging/full-snapshot lazy startup uygula.
- [x] Redis'i Kafka bağımlılık zincirinden bağımsız başlat.
- [x] Redis ve ZooKeeper başlangıcını `Startables.deepStart(...)` ile paralelleştir; Kafka → Schema Registry sırasını koru.
- [x] Birbirinden bağımsız aggregate container'larını ve readiness kontrollerini paralel başlat.
- [x] Command suite'inde aggregate başlatma; snapshot suite'inde yalnız tüketilen beş entity aggregate'ini başlat.
- [x] Ayrı Testcontainers smoke CI adımını kaldır ve full suite'teki ikinci altyapı başlangıcını engelle.

## P1 — DIND ve image çekme maliyetini azalt

- [x] Testcontainers Docker Hub image'larını private registry/mirror üzerinden çekecek image-name substitution ekle.
- [x] DIND image çekimlerini private registry proxy cache üzerinden geçir; adaptor image için registry-backed branch/develop cache'i koru.
- [x] Container image pull/start işlemlerini bağımsız servis gruplarında paralelleştir.
- [x] Disabled Ryuk kullanımında başarılı ve hatalı koşul sonunda container ve network cleanup'ını otomatikleştir.

## P1 — Pipeline süresini otomatik kontrol et

- [x] CI adımlarına makine tarafından okunabilir süre ölçümü ekle.
- [x] Testcontainers verify adımı 720 saniyeyi aşarsa CI'ı fail eden kontrol ekle.
- [x] Toplam branch pipeline'ı 815 saniyelik Compose baseline'ı aşarsa CI'ı fail eden kontrol ekle.
- [x] Opt-in işaretlerini ve geçici çift-pipeline desteğini kaldır.

## Tamamlanma kriteri

- [x] Varsayılan branch CI yalnız Testcontainers tabanlı integration suite'i çalıştırıyor.
- [x] Test kapsamının 7 feature/14 scenario altına düşmesini engelleyen otomatik guard mevcut.
- [x] Aynı build içinde ikinci Maven build'i veya ikinci integration-test pipeline'ı çalışmıyor.
- [x] Docker Compose test altyapısı CI kritik yolundan çıkarılmış durumda.
- [x] Docker image build, Trivy ve publish akışları render edilen pipeline'da mevcut.
