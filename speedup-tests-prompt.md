Repo:
/Users/benanaktas/project/home-office/ci-cd-optimization

Amaç:
CI/CD pipeline’ının kritik yolunu ciddi şekilde kısalt. Deploy edilecek command-adaptor Docker image’ı doğrudan Testcontainers E2E süitinde SUT olarak çalıştırılsın. Aynı commit için tekrarlanan Maven build’lerini, Docker build’lerini ve ikinci kez başlatılan Kafka/Redis/Schema Registry altyapısını kaldır.

Önemli çalışma kuralları:
- Önce mevcut implementasyonu incele; bazı maddeler zaten uygulanmış olabilir.
- Var olan ve doğru çalışan optimizasyonları tekrar yazma veya geri alma.
- Sadece kod ve pipeline konfigürasyonu değiştir.
- README, TODO, rapor, analiz dokümanı, prompt dosyası, Markdown veya görsel ekleme/değiştirme.
- slack-functions.sh ekleme, silme veya değiştirme.
- İlgisiz dosyalara dokunma.
- Commit ve push yapma.
- Çalışma ağacında kullanıcıya ait değişiklik varsa koru.
- Test kapsamını sessizce azaltma.
- Başarılı pipeline süresine hard limit koyma. Timing bilgileri non-blocking log olarak kalabilir.
- Test çalışmadıysa başarılı olmuş gibi raporlama.
- Maven private artifact/credential nedeniyle çalışmazsa tam hatayı belirt, fakat statik doğrulamaları tamamla.
- `.drone.star` RepoSync tarafından yönetiliyor olabilir. İstenen implementasyonu bu repoda yap, fakat dosyanın mevcut yapısını ve diğer pipeline türlerini bozma.

Mevcut önemli durum:
1. CI şu anda şu sırayla çalışıyor:
    - Maven `clean verify` ve Testcontainers snapshot süiti
    - Command adaptor Docker image build
    - Built image için ayrı runtime smoke testi
    - Trivy

2. Ana Testcontainers snapshot süiti command adaptor’ı container olarak çalıştırmıyor. Uygulama şu anda `SpringApplicationBuilder` ile Maven test JVM’i içinde başlatılıyor:
   `cmd-adaptor-sns-integration-tests/src/test/java/uk/gov/ho/dacc/fdp/testcontainers/SnsTestcontainersEnvironment.java`

3. Built image runtime testi daha sonra ayrı Maven invocation içinde Kafka, ZooKeeper, Redis ve Schema Registry altyapısını yeniden başlatıyor:
   `BuiltImageRuntimeIntegrationTest.java`

4. Feature branch’lerde de ağır `ci-testcontainers-snapshot` profili kullanılıyor. Halbuki aggregators olmadan tek command-path senaryosu çalıştıran `ci-testcontainers-cmd` profili zaten mevcut.

5. `develop` push sonrasında iki ayrı Artifactory pipeline’ı tekrar `mvn clean install` çalıştırıyor. Command adaptor image, CI’da test edilen image kullanılmak yerine tekrar `docker build` ile üretiliyor.

6. Workspace içindeki `.m2/repository` sadece aynı pipeline’ın adımları arasında paylaşılabiliyor. Pipeline’lar arasında kalıcı Maven cache görünmüyor.

Ana hedef mimari:

Fast Maven tests/package
|
v
Build command-adaptor image once
|
+--------------------+
|                    |
v                    v
E2E against built image   Trivy scan
|
v
Publish/promote the exact tested image

Beklenen pipeline sırası:

1. Secret retrieval ve Docker readiness
2. Maven fast tests + package
3. Command adaptor Docker image build
4. Aynı built image üzerinde Testcontainers E2E
5. Trivy image build’den sonra E2E ile paralel
6. Başarılı develop pipeline sonrasında aynı test edilmiş image’ın immutable tag/digest üzerinden publish edilmesi
7. Ayrı built-image runtime smoke ve tekrarlanan infrastructure startup kaldırılması

Uygulanacak işler:

A. Maven build ve Testcontainers E2E aşamalarını ayır

İlk Maven aşaması:
- Bütün unit testleri çalıştırmalı.
- `cmd-adaptor-sns` içindeki mevcut TopologyTestDriver/Cucumber testlerini korumalı.
- External Testcontainers E2E süitini bu aşamada çalıştırmamalı.
- Command adaptor executable JAR ve Dockerfile’ın ihtiyaç duyduğu dependency dosyalarını üretmeli.
- Reactor artifact’lerini sonraki yalnızca-integration-module Maven çağrısında kullanılabilecek local repository’ye kurmalı.
- Var olan `ci-local-install-artifacts` profilini değerlendirmeli ve gereksiz ikinci reactor build’ini engellemeli.

Örnek hedef davranış:
mvn clean verify \
-Dskip.integration.tests=true \
-Pci-local-install-artifacts \
-Dmaven.repo.local="${WORKSPACE_MAVEN_REPO}"

Ancak property/profile precedence’i kontrol et. Bu komutun Testcontainers E2E’yi gerçekten skip ettiğini doğrula. Eski 162 civarı TopologyTestDriver senaryosunu yanlışlıkla skip etme.

İkinci Maven aşaması:
- Sadece `cmd-adaptor-sns-integration-tests` modülünü çalıştırmalı.
- `-am` ile bütün reactor’ı yeniden build etmemeli.
- İlk Maven aşamasında workspace `.m2` içine kurulmuş reactor artifact’lerini kullanmalı.
- Seçilen branch profiline göre `ci-testcontainers-cmd` veya `ci-testcontainers-snapshot` çalıştırmalı.

B. Ana E2E süitini built image üzerinde çalıştır

`SnsTestcontainersEnvironment` içinde açık bir SUT çalışma modu oluştur:
- Embedded/in-process mod gerekiyorsa local geliştirme için korunabilir.
- CI Testcontainers profilleri image/container modunu kullanmalı.
- Örnek property:
  `sns.testcontainers.sut-mode=image`
- Image adı:
  `sns.runtime.image=docker-compose-command-adaptor:latest`

Image modunda:
- `SpringApplicationBuilder` ile command adaptor başlatma.
- Built command-adaptor image için `GenericContainer` oluştur.
- Container mevcut Testcontainers network’üne bağlansın.
- Kafka, Schema Registry ve Redis adresleri network alias üzerinden environment variable olarak verilsin.
- Mevcut `BuiltImageRuntimeIntegrationTest` içindeki doğru environment ayarlarını yeniden kullan veya ortak bir factory/metoda taşı.
- Şu ayarlar korunmalı:
    - `SPRING_PROFILES_ACTIVE=docker`
    - Kafka internal bootstrap address
    - Schema Registry internal URL
    - Redis internal hostname/port
    - dynamic topic suffix
    - OTEL exporter disable ayarları
- Command adaptor container’ının production Docker image CMD davranışı mümkün olduğunca korunmalı.
- Sadece listening port yeterli kabul edilmemeli.
- `/actuator/health/readiness` gerçekten `200` ve `"status":"UP"` döndürmeli.
- `getApplicationHost()` ve `getApplicationPort()` hem local embedded modda hem container modunda doğru çalışmalı.
- Shutdown sırasında command-adaptor container temizlenmeli.
- Hata halinde command-adaptor logları mevcut diagnostics mekanizmasına dahil edilmeli.

C. Ayrı runtime smoke testini kaldır

Ana 14 senaryolu E2E süiti:
- Built image’ı başlatıyorsa,
- readiness kontrol ediyorsa,
- ve bütün senaryolar aynı image üzerinde geçiyorsa,

aşağıdakiler artık redundant olmalı:
- `.drone.star` içindeki `Validate Built Image Runtime` adımı
- `ci-built-image-runtime-smoke` profili
- `BuiltImageRuntimeIntegrationTest`

Bunları yalnızca aynı doğrulamaların ana E2E süiti tarafından gerçekten kapsandığını doğruladıktan sonra kaldır.

Sonuçta Kafka/Redis/ZooKeeper/Schema Registry altyapısı bir CI pipeline içinde runtime smoke için ikinci kez başlatılmamalı.

D. Branch bazlı test seviyesi uygula

Mevcut profilleri kullan:
- `develop` branch:
  `ci-testcontainers-snapshot`
- Normal feature branch:
  `ci-testcontainers-cmd`

Beklenen davranış:
- Feature branch’te aggregators başlamamalı.
- Feature branch’te mevcut command-path senaryosu çalışmalı.
- Develop’ta 14 senaryolu snapshot süiti ve beş aggregator çalışmalı.
- `master`, tag, promote ve deploy akışlarının mevcut davranışını istemeden değiştirme.
- Pull request event’i mevcut durumda blank pipeline ise bu görev kapsamında yeni davranış uydurma; yalnızca güvenli ve açık şekilde gerekliyse değiştir.

Profil seçimi `.drone.star` içinde tek bir yerde hesaplanmalı. Aynı branch kontrolü farklı command string’lerinde tekrar edilmemeli.

E. Test edilen image ile yayınlanan image aynı olsun

Şu an CI’da oluşturulan image daha sonra Artifactory pipeline’ında yeniden build ediliyor. Bunu kaldır.

Yeni davranış:
1. CI image’ı bir kez oluştursun.
2. E2E ve Trivy aynı local image’ı kullansın.
3. Bütün kontroller başarılı olduktan sonra image immutable bir staging tag ile registry’ye push edilsin.

Örnek immutable tag:
ci-${DRONE_BUILD_NUMBER}-${DRONE_COMMIT_SHA}

4. Artifactory publish aşaması:
    - Bu immutable image’ı pull etsin.
    - Release/deployment tag’ine retag etsin.
    - Push etsin.
    - Command adaptor için tekrar `mvn clean install` çalıştırmasın.
    - Command adaptor Dockerfile’ını tekrar build etmesin.

Mümkünse digest’i doğrula:
- Test edilen local image ID/digest kaydedilsin.
- Push edilen staging image kontrol edilsin.
- Publish aşamasında aynı immutable artifact promote edilsin.

CI başarısız olursa staging image release tag’ine promote edilmemeli.

E2E test-runner image için:
- İkinci Artifactory pipeline’ındaki tekrarlanan Maven build’ini analiz et.
- Dockerfile.smoketest’in gerçekten hangi source/target/artifact dosyalarına ihtiyacı olduğunu belirle.
- Mümkünse aynı Maven çıktısından image’ı bir kez üret ve immutable tag ile publish et.
- Çalışması için gerekli reactor artifact’lerini yanlışlıkla image’dan çıkarma.
- E2E image davranışını değiştirmeden duplicate Maven build’i kaldır.

F. Artifactory pipeline tekrarlarını azalt

`develop` push sonrasında iki Artifactory pipeline’ı ayrı ayrı aynı `mvn clean install` komutunu çalıştırmamalı.

Tercih sırası:
1. Command adaptor image için build-once/promote yaklaşımı.
2. E2E test-runner image için CI çıktısını yeniden kullanma.
3. Bunlar mümkün değilse iki image build’ini tek pipeline ve tek Maven aşaması altında birleştir.

Aynı source commit için aynı Maven test süitini üç kez çalıştırma.

G. Maven cache’i düzelt

Workspace `.m2` kullanımını koru; çünkü Maven adımları arasında reactor artifact’leri paylaşılmalı.

Fakat yeni pipeline başladığında cache tamamen boş olmamalı.

Öncelik:
1. Repo/runner’da desteklenen güvenli persistent Maven cache/PVC mekanizması varsa kullan.
2. Yoksa Maven build image içindeki mevcut local repository ile workspace repository’yi seed et.
3. Seed işlemi sadece eksik artifact’leri tamamlamalı; her adımda büyük repository’yi gereksiz yere tekrar kopyalamamalı.
4. Snapshot artifact kaynaklı stale build riskini kontrol et.
5. `.m2` Docker build context’ine girmemeli.

`Dockerfile.smoketest` için root seviyede `.dockerignore` bulunmadığını kontrol et. Güvenli ise `.dockerignore` ekle ve en az şunları dışarıda bırak:
- `.git`
- `.idea`
- `.vscode`
- `.m2`
- yerel log/temp dosyaları
- pipeline için gereksiz büyük görseller ve patch dosyaları

Ancak E2E image’ın ihtiyaç duyduğu:
- POM dosyaları
- Java source
- test source/resources
- gerekli target artifact’leri

yanlışlıkla exclude edilmemeli.

H. Pipeline paralelliğini artır

Image build tamamlandıktan sonra:
- Testcontainers E2E
- Trivy scan

birbirinden bağımsız çalışabilmeli.

Son success/publish gate her ikisinin de başarılı olmasını beklemeli.

Sonar mevcut branch koşullarıyla korunmalı. Sonar’ın yalnızca `develop` push’unda çalışması diğer branch pipeline dependency graph’ını bozmamalı.

Docker image pull maliyetini azaltmak için:
- Kafka, Schema Registry, Redis ve aggregator image pull işlemlerinin Maven compile/unit test aşamasıyla overlap edilip edilemeyeceğini değerlendir.
- Aynı Docker daemon’a gereksiz duplicate pull yapma.
- Testcontainers’ın private registry prefix/auth davranışını bozma.
- Background pull yarışları oluşturma; deterministik bir “warm images” adımı tercih et.
- Bunun kazancı ölçülmeden gereksiz karmaşıklık ekleme.

I. Kafka test client başlangıcını optimize et

`SnsSteps` şu anda yaklaşık 11 ayrı Kafka consumer oluşturuyor ve her consumer başlangıçta ayrı poll yapıyor.

Bunu analiz edip güvenli şekilde azalt:
- Tercihen bütün ilgili topic partition’larına assign edilen tek bir generic Kafka consumer kullan.
- Tek consumer çok riskliyse command/snapshot veya entity bazında daha az sayıda consumer kullan.
- Record’ları `topic + testId` bazında buffer/cache et.
- Başka scenario’ya ait record’ları discard etme.
- Avro specific record deserialization davranışını koru.
- Runlog record’larını destekle.
- Scenario izolasyonunu koru.
- Consumer sayısını azalttıktan sonra close işlemlerini sadeleştir.
- Parallel scenario desteği eklenmeyecekse bunu gereksiz yere tasarlama.

Polling:
- `500 * 500ms = yaklaşık 250 saniye` failure timeout’unu daha makul bir toplam deadline ile değiştir.
- Başarılı testlerde gereksiz ortalama 500ms beklemeyi azaltmak için daha kısa poll interval değerlendir.
- Flaky sabit sleep ekleme.
- Deadline tabanlı polling kullan.
- Failure mesajında topic, beklenen record sayısı, bulunan record sayısı ve geçen süre olsun.

J. Topic oluşturma maliyetini azalt

`SnsTestcontainersEnvironment.requiredTopicNames()` yaklaşık 127 template ve iki ek topic oluşturuyor.

Şunları yap:
- 14 snapshot senaryosu ve beş aggregator tarafından gerçekten kullanılan topic’leri belirle.
- Gereksiz matching/profiling/delta/wash topic’lerini körlemesine oluşturma.
- Kafka auto-create açılacaksa partition ve replication ayarlarının test beklentileriyle uyumlu olduğunu kanıtla.
- En güvenli yaklaşım minimal explicit topic manifestidir.
- Topic listesini azaltırken aggregator startup veya Kafka Streams internal topic oluşturma davranışını bozma.
- Missing topic hatalarını failure diagnostics içinde görünür tut.

Bu optimizasyonu test etmeden büyük topic bloklarını silme.

K. ZooKeeper ve ağır Kafka startup’ını değerlendir

Daha düşük riskli hedef:
- Test Kafka’sını KRaft modunda çalıştır.
- ZooKeeper container’ını kaldır.
- Internal/external listener ve network alias davranışını koru.
- Schema Registry Kafka’ya container network üzerinden erişebilmeli.
- Host JVM’deki test client mapped port üzerinden erişebilmeli.

Redpanda’ya geçiş bu işin zorunlu parçası değil.
- Ancak Kafka + Schema Registry’yi tek container’a indirmek için ayrı benchmark/uyumluluk alternatifi olarak değerlendirilebilir.
- Avro, Kafka Streams ve Confluent Schema Registry API uyumluluğu kanıtlanmadan Redpanda’ya geçme.

L. Shutdown süresini azalt

Mevcut shutdown kodunu ölç:
- Kafka Streams instance’ları sırayla 30 saniyelik timeout ile kapanıyor.
- Kafka consumer’lar ayrı ayrı 5 saniyelik timeout ile kapanıyor.
- Aggregate container’lar sırayla stop ediliyor.
- Infrastructure container’ları sırayla stop ediliyor.

Güvenli optimizasyon:
- Farklı KafkaStreams instance’larını paralel kapat.
- Farklı Kafka consumer’larını paralel kapat veya consumer sayısını azalt.
- Beş aggregate container’ı paralel durdur.
- Test ortamında makul ve kısa graceful shutdown timeout kullan.
- Kafka/Schema Registry/ZooKeeper dependency sırasını bozma.
- Failure diagnostics alınmadan container’ları yok etme.
- Başarısız testte log toplama davranışını koru.

M. Eski hızlı test süitini koru

`cmd-adaptor-sns/src/test/resources/features` altında yaklaşık 162 TopologyTestDriver/Cucumber senaryosu var.

Bunları topluca Testcontainers’a taşıma:
- Bu senaryolar detaylı mapping ve edge-case kapsamı sağlıyor.
- In-process oldukları için E2E’den daha hızlı olmaları beklenir.
- Unit/fast integration katmanında korunmalı.
- Yalnızca yeni 14 senaryolu E2E süitiyle gerçekten birebir duplicate olan test varsa kapsam karşılaştırması yaparak kaldır.
- Test sayısını azaltarak sahte hızlanma oluşturma.

Ölçüm:
Pipeline’a failure üretmeyen timing logları ekle:
- Maven dependency/cache hazırlığı
- Unit/topology tests
- Package/install
- Docker image build
- Registry cache import/export
- Test infrastructure startup
- Command adaptor readiness
- Aggregator startup/readiness
- Cucumber scenario execution
-