/// Focus session domain entity.
///
/// Represents a single completed focus session with all its metadata.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'focus_session.freezed.dart';

/// A completed focus session record.
@freezed
class FocusSession with _$FocusSession {
  const factory FocusSession({
    /// Unique identifier
    required String id,

    /// When the session started
    required DateTime startTime,

    /// When the session ended
    required DateTime endTime,

    /// Duration of the session in minutes
    required int durationMinutes,

    /// Number of tomatoes earned
    required int tomatoesEarned,

    /// Whether the session was completed (not abandoned)
    @Default(true) bool completed,
  }) = _FocusSession;

  const FocusSession._();

  /// Date key for grouping (YYYY-MM-DD)
  String get dateKey =>
      '${startTime.year}-${startTime.month.toString().padLeft(2, '0')}-${startTime.day.toString().padLeft(2, '0')}';

  /// Formatted duration (e.g., "25m")
  String get formattedDuration => '${durationMinutes}m';

  /// Formatted time range (e.g., "14:30 - 14:55")
  String get formattedTimeRange {
    final startHour = startTime.hour.toString().padLeft(2, '0');
    final startMin = startTime.minute.toString().padLeft(2, '0');
    final endHour = endTime.hour.toString().padLeft(2, '0');
    final endMin = endTime.minute.toString().padLeft(2, '0');
    return '$startHour:$startMin - $endHour:$endMin';
  }
}
