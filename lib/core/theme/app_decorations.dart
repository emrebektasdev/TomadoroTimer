/// Reusable box decorations and shadows.
///
/// Centralized decorations prevent duplication and ensure consistency.
library;

import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_spacing.dart';

/// Common box shadows used throughout the app.
abstract final class AppShadows {
  /// Subtle shadow for cards and elevated elements
  static const List<BoxShadow> subtle = [
    BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 2)),
  ];

  /// Medium shadow for floating elements
  static const List<BoxShadow> medium = [
    BoxShadow(color: Color(0x0F000000), blurRadius: 20, offset: Offset(0, 4)),
  ];

  /// Strong shadow for navigation bar
  static const List<BoxShadow> navBar = [
    BoxShadow(color: Color(0x0F000000), blurRadius: 20, offset: Offset(0, 8)),
  ];

  /// Primary button shadow
  static List<BoxShadow> primaryButton({bool isPressed = false}) => [
    BoxShadow(
      color: AppColors.tomatoRed.withAlpha(isPressed ? 40 : 80),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  /// Gold glow for collectible tomato
  static List<BoxShadow> collectibleGlow(double intensity) => [
    BoxShadow(
      color: AppColors.accentGold.withAlpha((100 * intensity).toInt()),
      blurRadius: 30 + (20 * intensity),
      spreadRadius: 10 * intensity,
    ),
  ];
}

/// Common box decorations.
abstract final class AppDecorations {
  /// White card with subtle shadow
  static BoxDecoration get card => BoxDecoration(
    color: Colors.white,
    borderRadius: AppRadius.card,
    boxShadow: AppShadows.subtle,
  );

  /// Timer display container
  static BoxDecoration get timerCard => BoxDecoration(
    color: Colors.white.withAlpha(220),
    borderRadius: AppRadius.extraLarge,
    boxShadow: AppShadows.medium,
  );

  /// Mode selector chip
  static BoxDecoration get modeChip => BoxDecoration(
    color: Colors.white.withAlpha(200),
    borderRadius: AppRadius.large,
    boxShadow: AppShadows.subtle,
  );

  /// Tomato counter chip
  static BoxDecoration get tomatoCounter => BoxDecoration(
    color: Colors.white,
    borderRadius: AppRadius.chip,
    boxShadow: AppShadows.subtle,
  );

  /// Floating navigation bar
  static BoxDecoration get navBar => BoxDecoration(
    color: Colors.white,
    borderRadius: AppRadius.extraLarge,
    boxShadow: AppShadows.navBar,
  );

  /// Control button (reset, skip)
  static BoxDecoration controlButton({bool enabled = true}) => BoxDecoration(
    color: Colors.white.withAlpha(enabled ? 220 : 100),
    borderRadius: AppRadius.large,
    boxShadow: enabled ? AppShadows.subtle : null,
  );

  /// Primary action button (play/pause)
  static BoxDecoration primaryButton({bool isCollectible = false}) =>
      BoxDecoration(
        gradient: isCollectible
            ? const LinearGradient(
                colors: [AppColors.accentGold, AppColors.accentOrange],
              )
            : const LinearGradient(
                colors: [AppColors.tomatoRed, AppColors.tomatoRedDark],
              ),
        borderRadius: AppRadius.extraLarge,
        boxShadow: AppShadows.primaryButton(),
      );
}
