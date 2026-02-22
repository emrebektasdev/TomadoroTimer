import 'package:flutter/material.dart';

/// Tomadoro Renk Paleti - "Domates Tarlası" Konsepti
///
/// KONSEPT: Sıcak bir yaz gününde, verimli toprakta yetişen domatesler.
/// - Toprak sıcaklığı ve doğallık
/// - Canlı ama bağırmayan kırmızı tonlar
/// - Yeşilin huzuru ve büyüme hissi
/// - Gün ışığının yumuşak dokunuşu
class AppColors {
  AppColors._();

  // ═══════════════════════════════════════════════════════════════
  // ANA DOMATES RENKLERİ - Tarlanın Yıldızı
  // ═══════════════════════════════════════════════════════════════

  /// Ana domates kırmızısı - Olgun, canlı, dikkat çekici
  static const Color tomatoRed = Color(0xFFD84315);

  /// Koyu kırmızı - Gölgeler ve derinlik
  static const Color tomatoRedDark = Color(0xFFBF360C);

  /// Açık kırmızı - Vurgular ve parlama
  static const Color tomatoRedLight = Color(0xFFFF6E40);

  // ═══════════════════════════════════════════════════════════════
  // DOMATES OLGUNLAŞMA DURUMLARI
  // ═══════════════════════════════════════════════════════════════

  /// Yeşil domates - Taze, genç, umut vaat eden
  static const Color tomatoUnripe = Color(0xFF7CB342);
  static const Color tomatoUnripeLight = Color(0xFF9CCC65);

  /// Yarı olgun - Geçiş, ilerleme, sabır
  static const Color tomatoHalfRipe = Color(0xFFFF8F00);
  static const Color tomatoHalfRipeLight = Color(0xFFFFB300);

  /// Olgun domates - Başarı, ödül, tatmin
  static const Color tomatoRipe = Color(0xFFD84315);
  static const Color tomatoRipeGloss = Color(0xFFFF5722);

  // ═══════════════════════════════════════════════════════════════
  // YAPRAK VE TOPRAK - Tarlanın Ruhu
  // ═══════════════════════════════════════════════════════════════

  /// Yaprak yeşili - Canlı, taze
  static const Color leafGreen = Color(0xFF558B2F);
  static const Color leafGreenDark = Color(0xFF33691E);

  /// Toprak tonları - Sıcak, güvenilir, doğal
  static const Color earthBrown = Color(0xFF5D4037);
  static const Color earthLight = Color(0xFF8D6E63);

  // ═══════════════════════════════════════════════════════════════
  // ARKA PLAN RENKLERİ - Tarla Atmosferi
  // ═══════════════════════════════════════════════════════════════

  /// Ana arka plan - Sıcak krem, gün ışığı hissi
  static const Color backgroundLight = Color(0xFFFFF8E1);

  /// Kremsi arka plan - Yumuşak, davetkar
  static const Color backgroundCream = Color(0xFFFFECB3);

  /// Kart arka planı - Temiz ama sıcak
  static const Color backgroundCard = Color(0xFFFFFDF7);

  /// Yüzey rengi - Hafif toprak dokunuşu
  static const Color surface = Color(0xFFFFF3E0);

  // ═══════════════════════════════════════════════════════════════
  // METİN RENKLERİ - Okunabilir ve Sıcak
  // ═══════════════════════════════════════════════════════════════

  /// Ana metin - Koyu kahve, göz yormayan
  static const Color textPrimary = Color(0xFF3E2723);

  /// İkincil metin - Yumuşak kahve
  static const Color textSecondary = Color(0xFF6D4C41);

  /// Soluk metin - İpucu ve placeholder
  static const Color textLight = Color(0xFFA1887F);

  // ═══════════════════════════════════════════════════════════════
  // VURGU RENKLERİ
  // ═══════════════════════════════════════════════════════════════

  /// Altın - Ödül, başarı, değerli
  static const Color accentGold = Color(0xFFFFC107);

  /// Turuncu - Enerji, motivasyon
  static const Color accentOrange = Color(0xFFFF9800);

  // ═══════════════════════════════════════════════════════════════
  // NAVİGASYON ÇUBUĞU
  // ═══════════════════════════════════════════════════════════════

  static const Color navBarBackground = Color(0xFFFFFDF7);
  static const Color navBarShadow = Color(0x1A5D4037);
  static const Color navBarIconInactive = Color(0xFFBCAAA4);
  static const Color navBarIconActive = Color(0xFFD84315);

  // ═══════════════════════════════════════════════════════════════
  // MAĞAZA KATEGORİLERİ
  // ═══════════════════════════════════════════════════════════════

  static const Color shopSounds = Color(0xFF7E57C2);
  static const Color shopBackgrounds = Color(0xFFFF7043);
  static const Color shopAccessories = Color(0xFF26A69A);

  // ═══════════════════════════════════════════════════════════════
  // DURUM RENKLERİ
  // ═══════════════════════════════════════════════════════════════

  static const Color success = Color(0xFF558B2F);
  static const Color warning = Color(0xFFFF8F00);
  static const Color error = Color(0xFFD84315);

  // ═══════════════════════════════════════════════════════════════
  // GRAFİK RENKLERİ
  // ═══════════════════════════════════════════════════════════════

  static const Color chartPrimary = Color(0xFFD84315);
  static const Color chartSecondary = Color(0xFFFF8F00);
  static const Color chartTertiary = Color(0xFF558B2F);
  static const Color chartBackground = Color(0xFFFFF8E1);

  // ═══════════════════════════════════════════════════════════════
  // GRADİENTLER
  // ═══════════════════════════════════════════════════════════════

  static const LinearGradient tomatoGradientUnripe = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF9CCC65), Color(0xFF7CB342)],
  );

  static const LinearGradient tomatoGradientHalfRipe = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFB300), Color(0xFFFF8F00)],
  );

  static const LinearGradient tomatoGradientRipe = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF5722), Color(0xFFD84315)],
  );

  static const LinearGradient sunsetGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFF9A8B), Color(0xFFFF6A88), Color(0xFFFF99AC)],
  );

  static const LinearGradient nightGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF1A1A2E), Color(0xFF16213E), Color(0xFF0F3460)],
  );
}
