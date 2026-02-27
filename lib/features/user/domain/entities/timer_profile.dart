/// Timer profile domain entity.
///
/// Represents a customizable focus profile (e.g., "Pomodoro", "50/10").
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'timer_profile.freezed.dart';

/// A user-defined or default timer profile.
@freezed
class TimerProfile with _$TimerProfile {
  const factory TimerProfile({
    /// Unique identifier for the profile
    required String id,

    /// Display name of the profile
    required String name,

    /// Focus session duration in minutes
    required int focusDurationMinutes,

    /// Short break duration in minutes
    required int shortBreakMinutes,

    /// Long break duration in minutes
    required int longBreakMinutes,
  }) = _TimerProfile;

  const TimerProfile._();

  /// Creates a predefined Pomodoro profile
  factory TimerProfile.pomodoro() => const TimerProfile(
    id: 'default_pomodoro',
    name: 'Pomodoro',
    focusDurationMinutes: 25,
    shortBreakMinutes: 5,
    longBreakMinutes: 15,
  );

  factory TimerProfile.fromJson(Map<String, dynamic> json) {
    return TimerProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      focusDurationMinutes: json['focusDurationMinutes'] as int,
      shortBreakMinutes: json['shortBreakMinutes'] as int,
      longBreakMinutes: json['longBreakMinutes'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'focusDurationMinutes': focusDurationMinutes,
      'shortBreakMinutes': shortBreakMinutes,
      'longBreakMinutes': longBreakMinutes,
    };
  }
}
