/// User settings domain entity.
///
/// Contains user preferences for app behavior.
library;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'timer_profile.dart';

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

    /// List of available timer profiles
    @Default([]) List<TimerProfile> profiles,

    /// ID of the currently active timer profile
    @Default('default_pomodoro') String activeProfileId,
  }) = _UserSettings;

  const UserSettings._();

  /// Gets the currently active profile
  TimerProfile get activeProfile {
    if (profiles.isEmpty) return TimerProfile.pomodoro();
    return profiles.firstWhere(
      (p) => p.id == activeProfileId,
      orElse: () => profiles.first,
    );
  }

  /// Creates default settings.
  factory UserSettings.defaults() =>
      UserSettings(profiles: [TimerProfile.pomodoro()]);
}
