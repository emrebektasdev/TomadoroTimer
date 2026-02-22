/// Background gradients for different themes.
///
/// These are purchasable items in the shop and can be equipped by users.
/// This class provides a data-driven way to get gradients by ID.
library;

import 'package:flutter/material.dart';

/// Available background theme IDs.
abstract final class BackgroundIds {
  static const String defaultBg = 'bg_default';
  static const String sunset = 'bg_sunset';
  static const String night = 'bg_night';
  static const String forest = 'bg_forest';
  static const String ocean = 'bg_ocean';
}

/// Background gradient definitions.
///
/// Varsayılan tema "Domates Tarlası" konseptini yansıtır:
/// Üstte sıcak gün ışığı, altta toprak sıcaklığı.
abstract final class AppGradients {
  /// Varsayılan arka plan - Güneşli tarla hissi
  /// Sıcak krem tonları, hafif altın dokunuşu
  static const LinearGradient defaultBackground = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 0.5, 1.0],
    colors: [
      Color(0xFFFFFDE7), // Üst - Yumuşak gün ışığı
      Color(0xFFFFF8E1), // Orta - Sıcak krem
      Color(0xFFFFECB3), // Alt - Hafif toprak/altın
    ],
  );

  /// Sunset theme gradient
  static const LinearGradient sunset = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFF9A8B), Color(0xFFFF6A88), Color(0xFFFF99AC)],
  );

  /// Night theme gradient
  static const LinearGradient night = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF1A1A2E), Color(0xFF16213E), Color(0xFF0F3460)],
  );

  /// Orman teması - Huzurlu yeşillik
  static const LinearGradient forest = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFF1F8E9), // Açık yaprak
      Color(0xFFDCEDC8), // Taze yeşil
      Color(0xFFC5E1A5), // Canlı yeşil
    ],
  );

  /// Ocean theme gradient
  static const LinearGradient ocean = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB), Color(0xFF90CAF9)],
  );

  /// Map of background IDs to gradients for dynamic lookup.
  static const Map<String, LinearGradient> _gradientMap = {
    BackgroundIds.defaultBg: defaultBackground,
    BackgroundIds.sunset: sunset,
    BackgroundIds.night: night,
    BackgroundIds.forest: forest,
    BackgroundIds.ocean: ocean,
  };

  /// Gets a background gradient by its ID.
  ///
  /// Returns [defaultBackground] if the ID is null or not found.
  static LinearGradient forId(String? backgroundId) {
    if (backgroundId == null) return defaultBackground;
    return _gradientMap[backgroundId] ?? defaultBackground;
  }

  /// Checks if a background ID is valid (exists in the map).
  static bool isValidId(String? id) {
    if (id == null) return false;
    return _gradientMap.containsKey(id);
  }

  /// Gets all available background IDs.
  static List<String> get availableIds => _gradientMap.keys.toList();

  /// Determines if text should be light (for dark backgrounds).
  static bool shouldUseLightText(String? backgroundId) {
    return backgroundId == BackgroundIds.night;
  }
}
