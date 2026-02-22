/// Typography constants for consistent text styling.
///
/// These extend the theme's text styles with app-specific variations.
library;

import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Custom text styles for app-specific use cases.
abstract final class AppTypography {
  // Timer display
  static const TextStyle timerDisplay = TextStyle(
    fontSize: 64,
    fontWeight: FontWeight.w300,
    color: AppColors.textPrimary,
    letterSpacing: 4,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  // App title/branding
  static const TextStyle appTitle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  // Tomato counter
  static const TextStyle tomatoCount = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  // Session indicator
  static const TextStyle sessionIndicator = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.tomatoRed,
  );

  // Mode label
  static const TextStyle modeLabel = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  // Progress percentage
  static const TextStyle progressText = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  // Collect instruction
  static const TextStyle collectInstruction = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.tomatoRed,
  );

  // Stat value (large number)
  static const TextStyle statValue = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  // Stat label
  static const TextStyle statLabel = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  // Shop item title
  static const TextStyle shopItemTitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Shop item price
  static const TextStyle shopItemPrice = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w700,
  );

  // Section header
  static const TextStyle sectionHeader = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Chart label
  static const TextStyle chartLabel = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  // Nav bar label
  static const TextStyle navBarLabel = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
  );

  // Debug button (will be removed)
  static const TextStyle debugButton = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w600,
  );
}
