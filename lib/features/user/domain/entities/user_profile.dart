/// User profile domain entity.
///
/// Represents the user's core data including balance, statistics, and streak.
/// This is a pure domain entity with no framework dependencies.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';

/// Represents the user's profile data.
@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    /// Current tomato balance (spendable currency)
    required int tomatoBalance,

    /// Total tomatoes ever earned
    required int totalTomatoesEarned,

    /// Total minutes spent focusing
    required int totalFocusMinutes,

    /// Current streak (consecutive days)
    required int currentStreak,

    /// Longest streak ever achieved
    required int longestStreak,

    /// Last date the user was active (for streak calculation)
    DateTime? lastActiveDate,
  }) = _UserProfile;

  const UserProfile._();

  /// Creates an empty/new user profile with default values.
  factory UserProfile.initial() => const UserProfile(
    tomatoBalance: 0,
    totalTomatoesEarned: 0,
    totalFocusMinutes: 0,
    currentStreak: 0,
    longestStreak: 0,
    lastActiveDate: null,
  );

  /// Formatted total focus time (e.g., "2h 30m").
  String get formattedTotalFocusTime {
    final hours = totalFocusMinutes ~/ 60;
    final minutes = totalFocusMinutes % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  /// Checks if the user has any focus history.
  bool get hasHistory => totalFocusMinutes > 0;
}
