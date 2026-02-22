/// Application-wide constants.
///
/// All magic numbers and configuration values should be defined here
/// to ensure consistency and easy modification.
library;

/// Timer-related constants
abstract final class TimerConstants {
  /// Default focus session duration in minutes
  static const int defaultFocusMinutes = 25;

  /// Default short break duration in minutes
  static const int defaultShortBreakMinutes = 5;

  /// Default long break duration in minutes
  static const int defaultLongBreakMinutes = 15;

  /// Number of focus sessions before a long break
  static const int sessionsBeforeLongBreak = 4;

  /// Tomatoes earned per 25 minutes of focus
  static const int tomatoesPerSession = 1;

  /// Timer tick interval
  static const Duration tickInterval = Duration(seconds: 1);
}

/// User-related constants
abstract final class UserConstants {
  /// Default daily focus goal in minutes
  static const int defaultDailyGoalMinutes = 120;

  /// Default weekly focus goal in minutes
  static const int defaultWeeklyGoalMinutes = 600;

  /// Days to check for streak calculation
  static const int streakCheckDays = 1;
}

/// UI-related constants
abstract final class UIConstants {
  /// Bottom navigation bar height
  static const double navBarHeight = 70.0;

  /// Default animation duration
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);

  /// Long animation duration
  static const Duration longAnimationDuration = Duration(milliseconds: 600);

  /// Timer display animation duration
  static const Duration pulseAnimationDuration = Duration(milliseconds: 2000);

  /// Snackbar display duration
  static const Duration snackBarDuration = Duration(seconds: 2);

  /// Default border radius
  static const double defaultBorderRadius = 16.0;

  /// Card border radius
  static const double cardBorderRadius = 20.0;

  /// Tomato character default size
  static const double tomatoCharacterSize = 220.0;

  /// Space reserved for bottom nav bar
  static const double bottomNavBarSpace = 100.0;
}
