<!-- Use this file to provide workspace-specific custom instructions to Copilot. For more details, visit https://code.visualstudio.com/docs/copilot/copilot-customization#_use-a-githubcopilotinstructionsmd-file -->

# Flutter Proje Talimatları

Bu bir Flutter mobil uygulama projesidir. Lütfen aşağıdaki hususları göz önünde bulundurun:

## Genel Talimatlar
- Bu proje Flutter 3.32.6 sürümünü kullanmaktadır
- Dart 3.8.1 dil sürümünü destekler
- Material Design 3 (Material You) kullanın
- State management için Provider veya Riverpod tercih edin
- Responsive design uygulayın

## Kod Stili
- Dart linting kurallarına uygun kod yazın
- Widget'ları küçük ve yeniden kullanılabilir yapın
- Async/await kullanımını tercih edin
- Null safety kurallarına uyun

## Dosya Yapısı
- UI bileşenleri: `lib/widgets/`
- Sayfalar: `lib/pages/` veya `lib/screens/`
- Modeller: `lib/models/`
- Servisler: `lib/services/`
- Utilities: `lib/utils/`
----------------------------------------------------------------------

1. Proje Tanımı ve Temel Amacı
Bu sistem, hastanelerin acil servislerinde yaşanan yığılmayı azaltmak ve başvuruları hızlıca önceliklendirmek için tasarlanmıştır. Hasta, mobil uygulama ile kişisel bilgilerini girip “acil başvuru” yaptığında; sistem ona ardışık şekilde kritik sağlık soruları sorar (ör: “Nefes darlığın var mı?”, “Bilincin açık mı?”). Cevaplar puanlanır ve toplam puan aciliyet derecesini belirler:

Kırmızı alan: Hayati risk, hemen hastaneye gitmeli.

Sarı alan: Orta risk, doktor kontrolüyle çözülmeli.

Yeşil alan: Düşük risk, uzaktan değerlendirme yeterli.

Sistem, doktor, admin ve devlet yetkilisi gibi farklı rollerle çalışır ve tüm işlemler güvenli şekilde kaydedilir.

2. Kullanıcı Rolleri ve Senaryoları
Hasta:
Uygulamaya kayıt olur (Ad, soyad, TC, telefon, şifre).

Giriş yapar ve ana panelde “acil başvuru” seçer.

Hastane seçimini yapar (bulunduğu il/ilçedeki hastaneler listelenir).

Botun sağlık sorularını cevaplar.

Sonuç kırmızı ise: “Lütfen hemen acil servise gidin” uyarısı alır, aynı anda hastane paneline bildirim düşer.

Sonuç sarı/yeşil ise: Nöbetçi doktor listelenir, canlı görüşme veya hastaneye davet akışı başlar.

Geçmiş başvurularını ve yapılan görüşmeleri görebilir.

Doktor:
Uzmanlık, diploma, iletişim bilgileriyle başvuru yapar.

Admin onayı ve hastane nöbetine atanma süreciyle aktifleşir.

Kendi panelinde “bugünkü başvurular”ı ve hastaları görür.

Hastanın durumunu inceler, canlı görüşme/davet başlatır.

Görüşme sonunda reçete, rapor veya not ekler.

Admin:
Tüm kullanıcıları, doktorları ve başvuruları yönetir.

Doktor onayı, nöbet planı, hastane/doktor eşleştirme, bot soruları ve puanlama eşiklerini yönetir.

Raporları ve geçmiş başvuruları topluca dışa aktarır.

Devlet Yetkilisi:
Tüm başvurulara ve istatistiklere (gizli bilgiler olmadan) ulaşır.

Sistem üzerinden anlık veya geçmiş veri raporlarını indirir.


3. Hasta Puanlama Sistemi ve Triyaj Algoritması
Amaç:
Her hastanın aciliyet derecesini, verilen cevaplara göre otomatik ve şeffaf şekilde belirlemek.

Nasıl Çalışır?
Bot, acil başvuru yapan hastaya sağlıkla ilgili kritik sorular sorar.

Her cevaba bir puan atanır (örnek tablo aşağıda).

Tüm cevapların toplamı, hastanın aciliyet seviyesini belirler.

Örnek Soru ve Puan Tablosu:
Soru	Evet	Hayır
Bilinciniz açık mı?	0	100
Nefes darlığı çekiyor musunuz?	80	0
Göğüs ağrınız var mı?	50	0
Kanama var mı?	60	0
Ateşiniz 38°C üzerinde mi?	30	0
Mide bulantısı/baş dönmesi var mı?	10	0

Kırmızı Alan (100 ve üzeri): Hayati risk. Hastaya acil servise gitmesi önerilir, doktor ve admin paneline acil vaka bildirimi gider.

Sarı Alan (40-99): Orta risk. Doktora yönlendirilir, canlı görüşme veya hastaneye davet edilir.

Yeşil Alan (0-39): Düşük risk. Uzaktan hızlı danışmanlık veya yönlendirme yeterli olur.

Not: Bu puanlar ve eşikler admin panelinden güncellenebilir, hastanelerin ihtiyaçlarına göre özelleştirilebilir.

4. Bot Akışı ve Örnek Soru Mantığı
Bot Akışı:

Hasta "Acil Başvuru" başlatır.

Bot ilk sorudan başlar (ör: Bilinciniz açık mı?).

Her cevaptan sonra, eğer çok yüksek riskli bir yanıt varsa, doğrudan "Kırmızı" alan tetiklenebilir (örn: Bilinç kapalıysa başka soru sormadan direkt acile yönlendirme).

Tüm cevaplar toplandıktan sonra toplam puan hesaplanır.

Sonuç ekranında hem hastaya, hem nöbetçi doktora bildirim yapılır.

ÖRNEK BOT TRIYAJ AKIŞI:
Bot Soruları ve Akış Mantığı (Her adımda)
Soru: Bilinciniz açık mı?

Hayır → Acil! (Kırmızı Alan)
Sistem “Lütfen hemen en yakın acil servise başvurun!” mesajını gösterir ve bot burada sonlanır. Aynı anda doktor ve admin paneline acil vaka bildirimi düşer.

Evet → Devam

Soru: Nefes darlığınız var mı?

Evet → +80 puan eklenir

Hayır → +0 puan
(Cevaba göre bir sonraki soruya geçilir.)

Soru: Göğüs ağrınız var mı?

Evet → +50 puan

Hayır → +0 puan

Soru: Vücudunuzda kontrolsüz kanama var mı?

Evet → +60 puan

Hayır → +0 puan

Soru: 38°C ve üzerinde ateşiniz var mı?

Evet → +30 puan

Hayır → +0 puan

Soru: Şiddetli baş dönmesi veya baygınlık hissi var mı?

Evet → +10 puan

Hayır → +0 puan

Soru: Yakın zamanda büyük bir travma/geçirdiğiniz ciddi kaza var mı?

Evet → +70 puan

Hayır → +0 puan

Soru: Gebe misiniz ve acil bir şikayetiniz var mı?

Evet → +30 puan

Hayır → +0 puan

Soru: Şu anda konuşmada zorluk veya felç hissediyor musunuz?

Evet → +80 puan

Hayır → +0 puan

Soru: Son 12 saatte işeme veya dışkılamada büyük bir değişiklik yaşadınız mı?

Evet → +10 puan

Hayır → +0 puan

Toplam puan hesaplanır:

100 ve üzeri: Kırmızı Alan (Acil! Hemen acil servise gitmesi gerekir.)

40 - 99: Sarı Alan (Orta risk, doktor ile görüşmeli, gerekirse hastaneye davet.)

0 - 39: Yeşil Alan (Düşük risk, uzaktan görüşme veya hızlı tavsiye yeterli.)

Bot Akışında Spesifik Kontroller:
Eğer herhangi bir soru "Hayır" yanıtında Kırmızı alan tetikleniyorsa, diğer sorular atlanabilir ve hasta anında acile yönlendirilir.

Aksi halde tüm sorular cevaplandıktan sonra puanlama yapılır ve uygun risk kategorisine göre yönlendirme yapılır.


5. Akış Diyagramı ve Ekran Akışları (Yazılı Şema)
Hasta Senaryosu:

[Kayıt/Giriş] → [Hastane Seçimi] → [Acil Başvuru] → [Bot Soruları] → [Puan Hesabı]
    ↓
[Kırmızı] → [Acil Servise Git Bildirimi] → [Doktor/Admin Acil Bildirim]
[Sarı/Yeşil] → [Nöbetçi Doktor Eşleşmesi] → [Görüşme veya Hastaneye Davet]
    ↓
[Görüşme/Değerlendirme] → [Doktor Notu/Reçetesi] → [Başvuru Sonlandı]

Doktor Senaryosu:

[Giriş] → [Nöbet Paneli] → [Başvuru Listesi] → [Başvuruyu İncele] → [Görüşme veya Davet Kararı]
    ↓
[Görüşme Başlatılır] → [Görüşme Sonrası Not Ekler] → [Başvuru Tamamlanır]

Admin Senaryosu:

[Giriş] → [Kullanıcı/Doktor Yönetimi] → [Nöbet Planlama] → [Rapor ve Bot Ayarları] → [Dışa Aktarım]

Devlet Yetkilisi:

[Giriş] → [İstatistik ve Rapor Erişimi] → [Toplu İndirme/Dışa Aktarım]

6. Flutter ile Kurulum ve Adım Adım Geliştirme Sırası
Hiç bilmeyen birine göre açıklamalı:

Flutter ve Dart Kurulumu:

flutter.dev adresinden Flutter SDK’yı indir.

Bilgisayarına kur (Windows/Mac/Linux farkı yok, yönergeleri takip et).

Geliştirme Ortamı:

VS Code veya Android Studio’yu indir ve kur.

Flutter & Dart eklentilerini (extensions) yükle (VS Code’da sol menüden Extensions bölümüne “Flutter” ve “Dart” yazıp yükle).

Yeni Proje Oluşturma:

Terminali aç, flutter create hastane_acil yaz, Enter’a bas.

Projeyi aç: cd hastane_acil

VS Code ile klasörü açabilirsin.

Emülatör veya Gerçek Cihazda Çalıştırma:

Android Studio’daki AVD Manager’dan sanal cihaz ekle, başlat.

Ya da telefonuna geliştirici modunu açıp USB ile bağla.

Firebase Projesi ve Entegrasyon:

Firebase Console’da yeni bir proje oluştur.

Android/iOS uygulamasını ekle, google-services.json ve/veya GoogleService-Info.plist dosyalarını indirip projenin ilgili klasörüne koy.

Gerekli Paketlerin Kurulumu (pubspec.yaml’a ekle):

dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^x.x.x
  cloud_firestore: ^x.x.x
  firebase_auth: ^x.x.x
  firebase_storage: ^x.x.x
  provider: ^x.x.x
  intl: ^x.x.x
  image_picker: ^x.x.x
  agora_rtc_engine: ^x.x.x
  flutter_local_notifications: ^x.x.x
  firebase_messaging: ^x.x.x
  pdf: ^x.x.x
  printing: ^x.x.x
  google_fonts: ^x.x.x
  http: ^x.x.x
Terminalde flutter pub get komutunu çalıştır.

Firestore Koleksiyonlarını Kur:

Firebase Console’dan Database > Firestore’da yeni koleksiyonlar ekle (patients, doctors, hospitals, applications, admins, reports).

Güvenlik kurallarını ayarla: Sadece kendi verisine erişim, admin/doktor yetkileri.

Ekranları ve Akışları Kodla:

Giriş/Kayıt ekranı, Hasta paneli, Doktor paneli, Admin paneli, Devlet paneli.

Acil başvuru ve bot soru akışı, risk puanlama algoritması.

Görüntülü görüşme entegrasyonu, bildirim sistemleri.

Test Et:

Uygulamanın her özelliğini cihazda dene, hataları düzelt.

Firebase Test Lab veya manuel cihaz testleri yap.

Beta ve Yayınlama:

TestFlight (iOS) ve Google Play Beta ile deneme yayını yap.

Geri bildirimleri topla, düzeltmeleri yap, final sürümü yayınla.


7. Firestore Veri Modeli ve Güvenlik Kuralları
Koleksiyonlar:
patients:

id, ad, soyad, TC, telefon, e-posta, şifre (hashli), başvuru geçmişi

doctors:

id, ad, uzmanlık, iletişim, onay durumu, nöbet saatleri, belge bağlantıları

hospitals:

id, isim, konum, admin, nöbetçi doktor listesi

applications:

id, patientId, doctorId, hospitalId, başvuru zamanı, triageResult (kırmızı/sarı/yeşil), doctorDecision, görüşme logları, notlar

admins:

id, ad, yetki seviyesi

reports:

id, rapor tipi, tarih, dışa aktarım bağlantısı

Güvenlik Kuralları:
Her kullanıcı yalnızca kendi kaydını ve başvurusunu görebilir.

Adminler tüm verilere erişebilir ve yönetebilir.

Doktorlar, sadece kendi nöbet günlerindeki başvuruları görebilir.

Devlet yetkilileri yalnızca rapor ve toplu veriye (anonimleştirilmiş) erişebilir.

Şifreler asla açık tutulmaz, hash’lenir.

Kişisel veri silme ve anonimleştirme mümkün olmalı.


8. Test ve Yayınlama Süreci
Test Adımları:
Unit Test:
Her fonksiyonun doğru çalıştığını kontrol et (ör: bot puanlama fonksiyonu doğru mu hesaplıyor?).

Widget Test:
Flutter’da ekranların ve arayüz bileşenlerinin doğru tepki verip vermediğini test et.

Integration Test:
Birden fazla ekranın, kullanıcı senaryosunda doğru çalıştığını test et (örn: kayıt → başvuru → bot → sonuç → doktor görüşme).

Manuel Cihaz Testi:
Farklı ekran boyutlarında ve cihazlarda dene. Hem Android, hem iOS’ta canlı olarak her özelliği kontrol et.

Firebase Test Lab:
Farklı cihazlarda ve işletim sistemi sürümlerinde otomatik testler çalıştır.

Beta ve Geri Bildirim:
TestFlight (iOS) ve Google Play Beta ile küçük bir kullanıcı grubuna yayını aç.

Geri bildirimleri topla, hataları düzelt.

Yayınlama:
Play Store:

Uygulamayı derle (flutter build apk veya flutter build appbundle)

Gerekli görseller, açıklamalar, gizlilik politikası ve KVKK metni ekle.

Store politikalarına uygunluk kontrolü yap.

App Store:

flutter build ipa ile iOS için derle.

TestFlight’tan final yayına geçir.

App Store gerekliliklerini (gizlilik, erişilebilirlik vs.) kontrol et.

Yayın sonrası güncellemeleri ve hata düzeltmelerini planla.

Otomatik Yedekleme & Loglama:
Firestore ve dosya depolamanın periyodik olarak yedeğini al.

Hataları, uyarıları ve önemli olayları ayrı bir “logs” koleksiyonunda tut.

Firebase Crashlytics veya Sentry ile uygulama çökme raporlarını takip et.


9. KVKK, GDPR ve Veri Silme & Anonimleştirme
KVKK/GDPR Uyumlu Süreçler:
Her kullanıcı ilk girişte gizlilik ve açık rıza metnini onaylamalı.

Kullanıcı, uygulamada “verilerimi sil” seçeneğine erişebilmeli.

Silme talebinde:

Firestore’dan ilgili hasta, başvuru, geçmiş görüşme ve yan hesap kayıtları silinir.

Geriye kalan log ve istatistiklerde kişisel bilgiler anonimleştirilir.

Kişisel veri saklama süresi, yasal düzenlemelere göre ayarlanmalı.

Yedeklenen veriler de silme/anonimleştirme ile uyumlu olmalı.

10. Ek Tavsiyeler & Sık Sorulanlar
Kullanıcı Deneyimi (UX):
Tüm adımlar kullanıcı için kolay anlaşılır ve rehberli olmalı. Hata mesajları basit, açıklayıcı ve dil seçenekli sunulmalı.

Kullanıcıdan Geri Bildirim Al:
Beta sürecinde mutlaka gerçek kullanıcıya test ettir, onların önerilerini ciddiye al.

Kod Kalitesi ve Yorumlar:
Kodda bolca Türkçe/İngilizce açıklama kullan, modülleri böl ve tekrar kullanılabilir yaz.

Test Planı Hazırla:
Projede her yeni özellik için kısa test listesi tut, tüm ekrana ve veri akışına test yaz.

Performans ve Ölçeklenebilirlik:
Firestore sorgularını optimize et, gereksiz veri çekmekten kaçın.

Erişilebilirlik:
Büyük yazı, sesli okuma (screen reader) ve renk körlüğü uyumluluğu ekle.

Otomatik Bildirimler:
Her önemli işlemde (acil yönlendirme, görüşme daveti, randevu vb.) kullanıcıya bildirim gitmeli.

Sık Sorulanlar (Örnek):
S: Puanlama sistemi nasıl güncellenir?
C: Admin panelinde puan ve eşik değerlerini değiştirebileceğin özel bir alan olur.

S: Canlı görüşme için ek bir uygulama gerekli mi?
C: Hayır, uygulama içinde video call (agora/jitsi/webrtc) ile doğrudan yapılır.

S: Başvuru ve görüşme geçmişi kim tarafından görülebilir?
C: Sadece hasta ve ilgili doktor, adminler ise sistemsel logları topluca görebilir.

S: Uygulamanın veri güvenliği nasıl sağlanır?
C: Şifreler hash’lenir, Firestore kuralları ile yetkisiz erişim engellenir, SSL ile veri transferi yapılır.