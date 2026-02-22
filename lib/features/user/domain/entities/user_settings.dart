/// User settings domain entity.
///
/// Contains user preferences for app behavior.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_settings.freezed.dart';

/// User preferences and settings.
@freezed
class UserSettings with _$UserSettings {
  const factory UserSettings({
    /// Whether push notifications are enabled
    @Default(true) bool notificationsEnabled,

    /// Whether sounds are enabled
    @Default(true) bool soundEnabled,

    /// Whether vibration feedback is enabled
    @Default(true) bool vibrationEnabled,

    /// Daily focus goal in minutes (default: 100 = 25 * 4)
    @Default(100) int dailyGoalMinutes,

    /// Weekly focus goal in minutes (default: 500 = 25 * 20)
    @Default(500) int weeklyGoalMinutes,

    /// Focus session duration in minutes (default: 25)
    @Default(25) int focusDurationMinutes,

    /// Short break duration in minutes (default: 5)
    @Default(5) int shortBreakMinutes,

    /// Long break duration in minutes (default: 15)
    @Default(15) int longBreakMinutes,
  }) = _UserSettings;

  const UserSettings._();

  /// Creates default settings.
  factory UserSettings.defaults() => const UserSettings();
}
