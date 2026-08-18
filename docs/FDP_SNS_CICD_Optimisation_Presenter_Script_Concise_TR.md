# FDP CI/CD Optimizasyonu — Kısa Türkçe Sunum Metni

`FDP_SNS_CICD_Optimisation_Reference_Implementation_v2.pptx` için konuşmacı metni

Hedef sunum süresi: yaklaşık 10–12 dakika; duraklamalar ve görsel vurgularla 12–14 dakika.

## Slayt 1 — FDP CI/CD Optimizasyonu

Önerilen süre: 40–50 saniye

### Konuşma metni

Herkese merhaba. Bu sunumda FDP Command Adaptor SNS için gerçekleştirdiğim CI/CD optimizasyon pilotunu anlatacağım.

Başarılı pipeline çalışmalarından oluşan baseline, on çalışmada ortalama 13 dakika 35 saniyeydi. Optimizasyon sonrasında ölçülen iki başarılı çalışma 4 dakika 57 saniye ve 4 dakika 44 saniyede tamamlandı. 
En iyi gözlemlenen karşılaştırma, yaklaşık yüzde 65 daha kısa süre ve 2,87 kat hızlanma anlamına geliyor.

Buradaki temel sonuç yalnızca bir pipeline’ın hızlanması değil. Sistematik kayıpları belirledim, çalışma modelini yeniden tasarladım, 
doğrulama kapsamını korudum ve başka servislerde tekrar değerlendirilebilecek bir yaklaşım ortaya çıkardım.

4 dakika 44 saniye gözlemlenmiş bir sonuçtur; gelecekteki her çalışmanın garantisi değildir. Önce problemi ve baseline ölçümlerini, ardından mimariyi, kanıtları ve sonraki adımları açıklayacağım.

### Görsel yönlendirme

Önce 13:35’e, ardından 4:44’e ve son olarak yaklaşık yüzde 65 kartına işaret et.

## Slayt 2 — Bu çalışma neden gerekliydi?

Önerilen süre: 50–60 saniye

### Konuşma metni

Problem yalnızca yavaş bir build değildi. Başarılı bir pipeline ortalama on üç dakikadan uzun sürüyor ve her kod değişikliğindeki geri bildirim süresini uzatıyordu.

Yaşam döngüsü sahipliği CI adımları, Compose ve yardımcı container’lar arasında dağılmıştı. Kafka, Redis, aggregate servisleri, 
command adaptor ve testler için farklı başlatma, hazır olma ve hata akışları bulunuyordu. Bu yapı pipeline’ın anlaşılmasını ve sorunların teşhis edilmesini zorlaştırıyordu.

Zamanla bu süre normal kabul edilmeye başlanmıştı. Bu nedenle optimizasyonun değiştirilemez bir koşulu vardı: pipeline’ı zayıflatmadan hızlandırmak. 
İş senaryoları, oluşturulan gerçek imajın doğrulanması, güvenlik taraması ve faydalı hata çıktıları korunmalıydı.

İlk adım, sezgiyle optimizasyon yapmak yerine güvenilir bir baseline oluşturmaktı.

### Görsel yönlendirme

Soldaki dört problemi sırayla göster, ardından sağdaki temel hedefi vurgula.

## Slayt 3 — Baseline kanıtları

Önerilen süre: 65–75 saniye

### Konuşma metni

Baseline, on başarılı CI çalışmasından oluşuyor. Ortalama 13 dakika 35 saniye, medyan 13 dakika 31 saniye; gözlemlenen aralık ise 13 dakika 20 saniye ile 13 dakika 57 saniye arasındaydı. Aralığın dar olması, uzun sürenin tek bir istisnadan değil tekrarlanabilir bir yapıdan kaynaklandığını gösteriyor.

Grafik, görünen CI adımlarının ortalama sürelerini gösteriyor. Command Adaptor 11 dakika 1 saniye, Integration Tests 9 dakika 43 saniye, Kafka ve Redis 2 dakika 18 saniye, Maven build 1 dakika 24 saniye, Trivy 44 saniye, Aggregators 29 saniye ve Pre-Integration 6 saniyeydi.

Bazı Drone adımları eş zamanlı çalıştığı için bu değerler toplanmamalıdır. Bu ölçümleri uzun süren işleri bulmak ve çalışma modelini anlamak için kullandım. Ana baseline, başarılı pipeline’ın uçtan uca toplam süresidir.

Bu analiz doğrudan önceki yaşam döngüsü tasarımına odaklanmamı sağladı.

### Görsel yönlendirme

Dört özet ölçümü göster, en uzun iki bara işaret et ve “steps overlap — do not sum” uyarısını özellikle vurgula.

## Slayt 4 — Önceki yapı: dağıtılmış yaşam döngüsü sahipliği

Önerilen süre: 55–65 saniye

### Konuşma metni

Bu şema kavramsal bir modeldir; Drone dependency graph’ının birebir gösterimi değildir. Gerçek pipeline’da bazı işler eş zamanlı yürüyordu.

Altyapı hazırlığı, uygulamanın başlatılması ve testler farklı adımlara bölünmüştü. Secrets ve Docker hazırlığı Kafka, Redis ve aggregate servislerini etkinleştiriyordu. Maven uygulamayı build ediyor, başka bir adım command adaptor container’ını başlatıyor, pre-integration hazır olma kontrolünü yapıyor ve daha sonraki bir adım integration testleri çalıştırıyordu. Trivy ise final aşamasında devreye giriyordu.

Bu yapı CI ve Compose arasında orkestrasyon yükü oluşturuyor, hata kanıtlarını farklı bileşenlere dağıtıyor ve Trivy veritabanı hazırlığı gibi işleri final kritik yolunda tutuyordu.

Temel sorun tek bir yavaş kutu değil, yaşam döngüsü sahipliğinin çok fazla sınırdan geçmesiydi. Bu sınırları tek bir koordineli tasarım değişikliği olarak ele aldım.

### Görsel yönlendirme

Ana akışı takip et, ayrı aggregator kolunu göster ve alttaki üç sonucu özetle.

## Slayt 5 — Neler değişti?

Önerilen süre: 75–85 saniye

### Konuşma metni

Yeniden tasarım birbiriyle bağlantılı altı alanı kapsadı.

Docker context daraltıldı ve stabil katmanlar, sık değişen uygulama artefaktlarından önce konumlandırıldı. Böylece değişmeyen işler sıcak yeniden build sırasında tekrar kullanılabilir hâle geldi.

Integration ortamı Testcontainers’a taşındı. Redis, Kafka, Schema Registry ve aggregate servisleri test yaşam döngüsünün parçası oldu. İş senaryoları çalışırken uygulama test JVM’i içinde çalıştı.

False-green sonuçları önlemek için minimum senaryo sayıları, Docker zorunluluğunda kesin hata davranışı ve sıfır test koruması ekledim. Oluşturulan gerçek Docker imajının ayrı olarak başlatılması ve doğrulanması korunmaya devam etti.

Doğrulanmış Maven çıktıları tekrar kullanıldı ve yinelenen hazırlık kaldırıldı. Trivy veritabanı hazırlığı daha erken bir aşamaya taşındı; final güvenlik taraması korundu.

Tasarım prensibi şuydu: doğrulamaları koru, yinelenen işi kaldır, bağımsız hazırlıkları paralel çalıştır ve fayda sağlamayan denemeleri geri al.

### Görsel yönlendirme

Docker, test sahipliği, korumalar, runtime doğrulaması, Maven reuse ve Trivy başlıklarını sırayla göster; tasarım prensibiyle bitir.

## Slayt 6 — Sonraki yapı: test tarafından yönetilen yaşam döngüsü

Önerilen süre: 65–75 saniye

### Konuşma metni

Secrets alındıktan sonra üç bağımsız işlem paralel başlıyor: Docker’ın hazır olmasını beklemek, adaptor bilgisini çıkarmak ve Trivy veritabanını hazırlamak.

Docker hazırlığı ve adaptor bilgisi build-and-test adımını besliyor. Ardından Redis, Kafka, Schema Registry ve aggregate servislerinin yaşam döngüsünü Testcontainers yönetiyor. İş senaryoları test JVM’i içindeki uygulamaya karşı çalışıyor. Böylece bu test paketi sırasında ayrıca orkestre edilen bir uygulama container’ına ihtiyaç kalmıyor.

Pipeline daha sonra gerçek Docker imajını oluşturuyor, bu imajı runtime seviyesinde doğruluyor ve final Trivy taramasını gerçekleştiriyor. Her adım bir önceki çıktıyı doğruladığı için bu kapılar sıralı kalıyor.

Güvenlik taraması kaldırılmadı ve Trivy’nin kendisinin hızlandığı iddia edilmiyor. Yalnızca veritabanı hazırlığı final kritik yolundan çıkarıldı.

### Görsel yönlendirme

Üçlü paralel ayrımı göster, ortadaki doğrulama yolunu takip et ve kırmızı Trivy çizgisini final taramasına kadar izle.

## Slayt 7 — Ölçülen sonuç

Önerilen süre: 60–70 saniye

### Konuşma metni

Baseline ortalaması 13 dakika 35 saniye, yani 815 saniyeydi. Ölçülen iki başarılı optimizasyon çalışması 4 dakika 57 saniye ve 4 dakika 44 saniyede tamamlandı.

En iyi gözlemlenen çalışma kullanıldığında süre 815 saniyeden 284 saniyeye düştü. Bu, 531 saniye veya 8 dakika 51 saniye tasarruf; yaklaşık yüzde 65,2 azalma ve 2,87 kat hızlanma anlamına geliyor.

Bu değer uçtan uca gözlemlenen sonuçtur; ayrı optimizasyon ölçümlerinin toplanmasıyla elde edilmemiştir. Optimizasyon sonrası örneklem şu anda iki başarılı çalışmadan oluştuğu için 4 dakika 44 saniye kalıcı bir garanti olarak sunulmamalıdır.

Buna rağmen kanıtlar, yeniden tasarlanan modelin gerekli kontrolleri korurken geri bildirim süresini önemli ölçüde kısaltabildiğini gösteriyor.

### Görsel yönlendirme

Üç barı karşılaştır, tasarruf, yüzde ve hızlanma kartlarını göster; ardından uyarıyı vurgula.

## Slayt 8 — Bileşen seviyesinde karşılaştırma

Önerilen süre: 90–105 saniye

### Konuşma metni

Bu satırlar destekleyici önce-sonra kanıtlarını gösteriyor. Ancak ölçüm sınırları birbirinden farklıdır ve değerler toplanamaz.

Kontrollü sıcak Docker rebuild süresi yaklaşık 76–78 saniyeden yaklaşık 5 saniyeye düştü. Bu ölçüm, her CI çalışmasında aynı miktarda tasarruf garantisi değildir.

Oluşturulan imajın runtime doğrulaması, Maven artefaktlarının tekrar kullanılması sayesinde yaklaşık 66 saniyeden 30–34 saniyeye düştü; gerçek imaj kontrolü kaldırılmadı. Adaptor bilgisi ise gözlemlenen 15–21 saniyeden yaklaşık 11 saniyeye indi.

Final Trivy yolu, veritabanı hazırlığının daha erken yapılmasıyla yaklaşık 40–49 saniyeden 14–15 saniyeye düştü. Scanner korundu ve Trivy’nin kendisinin daha hızlı çalıştığı iddia edilmedi.

Yaklaşık 30 saniyelik Kafka Streams kapanış kuyruğu, düzeltme sonrası temsilî çalışmalarda artık gözlemlenmedi. Bu da evrensel bir garanti değil, ölçülmüş bir gözlemdir.

Testcontainers geçişi, aggregate servislerinin eş zamanlı başlaması ve false-green korumaları da önemlidir. Ancak savunulabilir birebir ölçüm bulunmayan alanlara ayrı süre kazancı atamıyorum.

### Görsel yönlendirme

Önce “How to read this” alanında dur, turuncu ve turkuaz barları karşılaştır, yapısal değişiklikler kutusuyla bitir.

## Slayt 9 — Bilinçli olarak korunan doğrulamalar

Önerilen süre: 60–70 saniye

### Konuşma metni

On dört iş senaryosunun tamamı korundu. Minimum feature ve senaryo limitleri, test paketinin yanlışlıkla küçülerek daha hızlı ama hatalı biçimde yeşil sonuç üretmesini engelliyor.

CI ortamında Docker zorunludur. Docker kullanılamadığında container tabanlı testler sessizce atlanmak yerine integration akışı hata verir. Maven Failsafe, sıfır testle başarılı görünen bir integration aşamasını da engeller. Ayrı JUnit coverage kontrolü, iş senaryolarından bağımsız olarak korunur.

Pipeline’ın oluşturduğu gerçek Docker imajı iş senaryolarından sonra hâlâ başlatılıyor ve doğrulanıyor. Böylece JVM içindeki iş testlerinden bağımsız olarak paketlenmiş runtime artefaktının doğru başlayabildiği kanıtlanıyor.

Trivy vulnerability ve secret taraması, mevcut raporlama politikası ve hata teşhis çıktıları da korunuyor.

Temel prensip şu: daha az doğrulama çalışıyorsa veya hatalar daha az görünür hâle geliyorsa daha hızlı CI bir iyileştirme değildir.

### Görsel yönlendirme

Korunan doğrulama listesini sırayla göster ve büyük yeşil prensip cümlesinde dur.

## Slayt 10 — Korumadığım denemeler

Önerilen süre: 55–65 saniye

### Konuşma metni

Her olası optimizasyon sonucu iyileştirmedi.

Maven paralelliği, uçtan uca tekrarlanabilir bir fayda sağlamadı. Bu nedenle ek ayarları korumadım. Arka planda imaj indirme bazı gözlemlerde daha yavaştı ve tutarlı fayda üretmedi; ek koordinasyon yolu kaldırıldı.

Log miktarını azaltmak da tekrarlanabilir bir performans iyileştirmesi sağlamadı. Bu nedenle faydalı teşhis çıktıları korundu. Readiness sonucunu cache’lemek tekrarlanan kontrolleri azaltabilirdi; ancak önceki bir sonucu güncel hazır olma kontrolünün yerine koyarak doğrulama anlamını değiştiriyordu. Bu ödünleşimi reddettim.

Bu denemeler yine de değerliydi. Ölçmek ve geri almak, kanıtlanmamış varsayımların kalıcı karmaşıklığa dönüşmesini engelledi ve final implementasyonu kanıt ile doğruluk üzerinde tuttu.

### Görsel yönlendirme

Her satırı deney, gözlem ve karar olarak anlat; alttaki yeşil öğrenim mesajıyla bitir.

## Slayt 11 — Sonuç ve sonraki adım

Önerilen süre: 65–75 saniye

### Konuşma metni

Final karşılaştırma, başarılı pipeline baseline ortalaması olan 13 dakika 35 saniyeye karşılık 4 dakika 57 saniye ve 4 dakika 44 saniyelik gözlemlenmiş optimizasyon çalışmalarıdır. En iyi gözlemlenen sonuç yaklaşık yüzde 65,2 daha kısa ve 2,87 kat daha hızlıdır.

Sonraki adım, çözümü doğrudan bütün servislere kopyalamak değil, kontrollü biçimde doğrulamaktır. Önce SNS referans uygulama olarak doğrulanmalı ve yaklaşımın hangi koşullarda uygulanabilir olduğu belgelenmelidir.

Ardından model, farklı build ve test özelliklerine sahip iki veya üç temsilî repository üzerinde denenmelidir. Böylece tekrar kullanılabilir standartlarla servise özel tercihler ayrılabilir.

Sonrasında Docker cache, Testcontainers sahipliği, gerçek imaj doğrulaması, false-green koruması ve güvenlik taraması için standart desenler ve koruma kuralları tanımlanabilir. Daha geniş bir yayılım değerlendirilmeden önce teknik bir oturumla kanıtlar ve uygulama kontrol listesi paylaşılabilir.

Tekrarlanabilir model şu şekilde özetlenebilir: ölç, yeniden tasarla, doğruluğu koru, doğrula ve standartlaştır. Teşekkür ederim; soruları alabilirim.

### Görsel yönlendirme

Süre karşılaştırmasıyla başla, dört sonraki adımı soldan sağa takip et ve kapanış mesajıyla bitir.

## Sunum sırasında korunması gereken ifadeler

- 4:44 değerini garantili süre değil, gözlemlenen en iyi başarılı çalışma olarak tanımla.
- Eş zamanlı Drone adımlarını veya bileşen seviyesindeki kazanımları toplama.
- Güvenlik taramasının kaldırıldığını ya da Trivy’nin kendisinin hızlandığını söyleme.
- On dört iş senaryosunun, ayrı runtime doğrulamasının ve güvenlik kontrollerinin korunduğunu belirt.
- Docker warm-rebuild sürelerini evrensel CI tasarrufu değil, kontrollü gözlem olarak tanımla.
