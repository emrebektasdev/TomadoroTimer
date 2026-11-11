Tomadoro karakter animasyonu kontrolü — 11 Kasım 2026

İşlevsel kontrol Android 16 / API 36 x64 emülatörde (emulator-5556), performans kontrolü gerçek Samsung SM-S721B üzerinde Android 17 / API 37, 1080×2340, 120 Hz, Flutter profile ve Impeller/Vulkan ile yapıldı. Sonunda iki cihaza da normal uygulama giriş noktasından üretilen debug APK yüklendi. Beş bekleme hareketi, 10 saniyelik odak, dondurma ve aksesuar debug kontrolleri kaldırılmadı.

İki somut sorun düzeltildi:

- Odak gizlendiğinde oturma denetleyicisi sessiz fakat çalışır durumda kalıyordu. Geri dönüşte gizliyken geçen süreyi atlayıp başka klibe sıçrayabiliyordu. Yeni test bu durumu önce başarısız olarak yeniden üretti. Şimdi görsel oynatma görünmezken duruyor; görünür olduğunda aynı konumdan devam ediyor. Gerçek zamanlayıcı çalışmayı sürdürüyor. Tamamlanmış oturum son pozunda kalıyor.
- 1.431 PNG ayrı tam tuval dokuları olarak çözülüyordu. Şeffaf alanlar kırpılıp mevcut çözünürlükler korunarak iki ortak atlas sayfası üretildi. Orijinal Blender JSON/PNG dışa aktarımları değiştirilmedi. Parça adları, TRS, aksesuar soketleri, baked örtüşmeler ve çizim sırası mevcut JSON'lardan okunuyor. Atlas bölgesinin tuval konumu geri uygulanıyor. Her sayfa bir kez çözülüp bütün kliplerde paylaşılıyor ve sahibi ekran kapatıldığında bir kez serbest bırakılıyor.

Emülatörde son debug APK ile görüntü kaydından doğrulananlar:

| Kontrol | Sonuç |
| --- | --- |
| think → Başlat | Çene yanındaki el mevcut pozdan iniyor; sit_down ve focus_breathe izliyor. |
| fix_leaf → Başlat | El yaprakta önde; indirirken kolun konumunda katman kaynaklı sıçrama gözlenmedi. |
| fidget → Başlat | Kaldırılan ayak iniyor, ardından oturuyor. Basan ayağın sabitliği piksel testiyle de doğrulandı. |
| stretch → Başlat | Açık kollar kapanıp oturmaya geçiyor. |
| rebalance → Başlat | Havada olan ayak inip oturmaya geçiyor. |
| Sayaç | Başlat hareketin bitmesini beklemiyor. Anlık başlangıç widget testlerinde de doğrulandı. |
| Duraklat/devam | Oturmada ve nefes döngüsünde görüntü bekliyor, devamında aynı pozdan sürüyor. |
| Sıfırlama/yeni oturum | Ayakta başlangıca dönüyor; yeni başlangıçta yeniden oturuyor. |
| Tema/aksesuar | 24:59'da duraklatılmış bağdaş pozunda Kış Kulübesi → Güneşli Sera ve atkı → gözlük değiştirildi. Sayaç ve karakter pozu korundu. Özgün seçimler kontrol sonunda geri yüklendi. |
| Kısa oturum | 00:00, %100 çember, kısa parıltı ve Oturum tamamlandı mesajı görüldü. focus_complete bir kez oynayıp son bağdaş pozunda kaldı. |
| Bitiş sonrası gezinme | Sekmeden dönüşte maskot bölgesinin pikselleri birebir aynıydı. Uygulama yeniden açıldığında da tamamlanmış durum korundu. |
| Ödül | Bakiye 6 → 7 oldu; sekme değişimi ve yeniden açılıştan sonra 7'de kaldı. |

Telefon ölçümleri:

| Ölçüm | Önce | Atlas sonrası |
| --- | ---: | ---: |
| Çözülen karakter PNG sayısı | 1.431 | 2 |
| Açılmış karakter piksel alanı, RGBA hesabı | 316,4 MiB | 24,0 MiB |
| Android Graphics bellek kalemi | 502,7 MiB | 204,5 MiB |
| Odak sırasında toplam Android PSS | 652,7 MiB (ilk profile örneği) | 372,1 MiB |
| İlk varlık isteğinden ilk animasyon widget karesine | Karşılaştırma için kullanılmadı | 427,3 ms |
| Dart başlangıcından ilk animasyon widget karesine | Karşılaştırma için kullanılmadı | 600,6 ms |

Önceki ilk-yükleme denemesinde ekran uykuya geçtiği için o zaman değeri karşılaştırmaya alınmadı. Son yükleme ölçümü ekran açıkken yapıldı. Grafik bellek Android meminfo Graphics, PSS Android'in paylaştırılmış süreç belleğidir; 24 MiB atlas hesabı uygulamanın toplam belleği değildir. Gardırop ilk kez ziyaret edildikten ve üç ek gidip gelmeden sonra PSS 401,3 MiB oldu; diğer ekranların görselleri de bu süreç belleğine dahildir.

FrameTiming kayıtlarında sıcak ölçüm için pencerenin ilk 1,5 ve son 1 saniyesi dışarıda tutuldu. 120 Hz kare bütçesi yaklaşık 8,33 ms; UI ve raster aşamaları ayrı değerlendirildi.

| Atlas sonrası örnek | Kare | UI p95 | Raster p95 | 8,33 ms üzeri UI veya raster | 16,67 ms üzeri |
| --- | ---: | ---: | ---: | ---: | ---: |
| Bekleme ve birkaç bekleme hareketi | 9.489 | 1,038 ms | 2,926 ms | 29 | 1 |
| Oturma sonrası odak döngüsü | 2.362 | 1,104 ms | 3,025 ms | 0 | 0 |

Telefon bekleme örneklerinde think, fix_leaf, fidget ve rebalance gözlendi; atlas sonrası tekrarda think, fix_leaf ve rebalance birden fazla oynadı. Gizli Odak ekranında denetleyici animating=false, visible=false idi ve altı saniye boyunca poz değeri değişmedi. Zamanlayıcının saniye güncellemeleri devam etti. Bekleme, odak ve tekrarlanan gezinme sonunda PNG istek sayısı hep 2, yinelenen varlık isteği sayısı 0 kaldı.

Açık kalan performans sınırı: ilk açılış kaydında en yavaş raster karesi 138,118 ms idi. Bekleme örneğindeki tek 16,67 ms aşımı 17,347 ms idi. Dolayısıyla ilk açılış/ilk kullanım takılmalarının bütünüyle giderildiği iddia edilmiyor. Sıcak odak döngüsünde ölçülen 2.362 karede 120 Hz bütçesi aşılmadı. İşlevsel kontrol sırasında açık kalan bir akış hatası gözlenmedi; son görsel değerlendirme kullanıcıya bırakıldı.

Doğrulama: 17 Flutter testinin tamamı geçti; değiştirilen Dart dosyalarının analizinde hata bulunmadı. Görünürlük regresyonu ve tam tuval başına PNG çözme sorunu testlerde önce başarısız, düzeltmeden sonra başarılı olarak görüldü.

Yeni Blender JSON/PNG dışa aktarımları eklendiğinde Pillow bulunan Python ile `python tool/build_focus_atlas.py` çalıştırılmalıdır. Üretilen `assets/animations/focus/atlas.json` ile iki PNG sayfası uygulama varlıklarıdır; kaynak PNG'ler pakete tekrar eklenmemelidir. Ham profil kayıtları ve emülatör videoları yerel `build/animation-audit/` klasöründedir. Ölçüm giriş noktası bu klasörde tutuldu, teslim edilen debug APK'nın giriş noktası `lib/main.dart` olarak bırakıldı.
