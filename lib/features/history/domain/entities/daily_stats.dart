/// Daily statistics domain entity.
///
/// Aggregated statistics for a single day.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_stats.freezed.dart';

/// Aggregated daily statistics.
@freezed
class DailyStats with _$DailyStats {
  const factory DailyStats({
    /// Date in YYYY-MM-DD format
    required String dateKey,

    /// Total focus minutes for the day
    @Default(0) int totalMinutes,

    /// Number of completed sessions
    @Default(0) int sessionsCompleted,

    /// Tomatoes earned on this day
    @Default(0) int tomatoesEarned,

    /// Daily goal in minutes (at time of recording)
    @Default(100) int goalMinutes,
  }) = _DailyStats;

  const DailyStats._();

  /// Creates empty stats for a date.
  factory DailyStats.empty(String dateKey) => DailyStats(dateKey: dateKey);

  /// Progress toward daily goal (0.0 to 1.0, can exceed 1.0)
  double get goalProgress => goalMinutes > 0 ? totalMinutes / goalMinutes : 0.0;

  /// Whether the daily goal was met
  bool get goalCompleted => totalMinutes >= goalMinutes;

  /// Formatted total time (e.g., "2h 30m")
  String get formattedTotalTime {
    final hours = totalMinutes ~/ 60;
    final mins = totalMinutes % 60;
    if (hours > 0) {
      return '${hours}h ${mins}m';
    }
    return '${mins}m';
  }

  /// Returns true if this day has any activity
  bool get hasActivity => totalMinutes > 0 || sessionsCompleted > 0;
}
