/// Timer snapshot entity.
///
/// Represents the state of the timer at a specific point in time.
/// Used for persistence and restoring state.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

import 'timer_mode.dart';

part 'timer_snapshot.freezed.dart';

/// Immutable snapshot of the timer state.
@freezed
class TimerSnapshot with _$TimerSnapshot {
  const factory TimerSnapshot({
    /// Current timer mode
    required TimerMode mode,

    /// Initial duration in minutes
    required int initialDuration,

    /// Remaining seconds at the time of snapshot
    required int remainingSeconds,

    /// Whether the timer was running
    required bool isRunning,

    /// Timestamp when the timer was started (if running)
    DateTime? startTime,

    /// Number of sessions completed (for long break logic)
    @Default(0) int sessionsCompleted,
  }) = _TimerSnapshot;
}
