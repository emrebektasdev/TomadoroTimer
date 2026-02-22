/// Timer state for the application layer.
///
/// Immutable state exposed to the presentation layer.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

import '../domain/entities/timer_mode.dart';

part 'timer_state.freezed.dart';

/// Application state for the timer.
@freezed
class TimerState with _$TimerState {
  const factory TimerState({
    /// Current timer mode
    required TimerMode mode,

    /// Initial duration in minutes
    required int initialDuration,

    /// Remaining seconds to display
    required int remainingSeconds,

    /// Whether the timer is currently running
    required bool isRunning,

    /// Start timestamp (null if paused/stopped)
    DateTime? startTime,

    /// Number of sessions completed (for auto-break logic)
    @Default(0) int sessionsCompleted,

    /// Whether the timer is currently loading/restoring
    @Default(false) bool isLoading,

    /// Whether the current session is effectively complete (reached 0)
    /// Used to trigger completion logic only once.
    @Default(false) bool isCompleted,
  }) = _TimerState;

  const TimerState._();

  /// Initial state
  factory TimerState.initial() => const TimerState(
    mode: TimerMode.focus,
    initialDuration: 25,
    remainingSeconds: 25 * 60,
    isRunning: false,
  );

  /// Progress from 0.0 to 1.0
  double get progress {
    if (initialDuration == 0) return 0.0;
    final totalSeconds = initialDuration * 60;
    if (totalSeconds == 0) return 0.0;
    return 1.0 - (remainingSeconds / totalSeconds);
  }

  /// Formatted time (MM:SS)
  String get formattedTime {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
