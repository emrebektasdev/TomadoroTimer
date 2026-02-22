/// Weekly statistics domain entity.
///
/// Aggregated statistics for a single week.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'weekly_stats.freezed.dart';

/// Aggregated weekly statistics.
@freezed
class WeeklyStats with _$WeeklyStats {
  const factory WeeklyStats({
    /// Start date of the week (Monday)
    required DateTime weekStart,

    /// Total focus minutes for the week
    @Default(0) int totalMinutes,

    /// Number of completed sessions
    @Default(0) int sessionsCompleted,

    /// Tomatoes earned this week
    @Default(0) int tomatoesEarned,

    /// Days with activity this week (0-7)
    @Default(0) int activeDays,

    /// Weekly goal in minutes
    @Default(500) int goalMinutes,

    /// Per-day breakdown (Mon-Sun, 7 values)
    @Default([0, 0, 0, 0, 0, 0, 0]) List<int> dailyMinutes,
  }) = _WeeklyStats;

  const WeeklyStats._();

  /// Progress toward weekly goal (0.0 to 1.0, can exceed 1.0)
  double get goalProgress => goalMinutes > 0 ? totalMinutes / goalMinutes : 0.0;

  /// Whether the weekly goal was met
  bool get goalCompleted => totalMinutes >= goalMinutes;

  /// Formatted total time (e.g., "8h 45m")
  String get formattedTotalTime {
    final hours = totalMinutes ~/ 60;
    final mins = totalMinutes % 60;
    if (hours > 0) {
      return '${hours}h ${mins}m';
    }
    return '${mins}m';
  }

  /// Average daily minutes
  int get averageDailyMinutes =>
      activeDays > 0 ? totalMinutes ~/ activeDays : 0;
}
