/// Timer state notifier.
///
/// Manages the timer logic using a timestamp-based approach for reliability.
library;

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/entities/timer_mode.dart';
import '../domain/entities/timer_snapshot.dart';
import '../domain/repositories/timer_repository.dart';
import 'ticker.dart';
import 'timer_state.dart';

/// StateNotifier for controlling the timer.
class TimerNotifier extends StateNotifier<TimerState> {
  final TimerRepository _repository;
  final Ticker _ticker;
  StreamSubscription<int>? _tickerSubscription;

  TimerNotifier(this._repository, this._ticker) : super(TimerState.initial()) {
    _restoreState();
  }

  /// Restores timer state from persistence.
  Future<void> _restoreState() async {
    state = state.copyWith(isLoading: true);

    final result = await _repository.loadTimerState();
    result.fold(
      (failure) {
        // Fallback to initial if load fails
        state = state.copyWith(isLoading: false);
      },
      (snapshot) {
        if (snapshot != null) {
          // Restore from snapshot
          state = state.copyWith(
            mode: snapshot.mode,
            initialDuration: snapshot.initialDuration,
            remainingSeconds: snapshot.remainingSeconds,
            isRunning: snapshot.isRunning,
            startTime: snapshot.startTime,
            sessionsCompleted: snapshot.sessionsCompleted,
            isLoading: false,
          );

          if (state.isRunning) {
            _resumeTicker();
          }
        } else {
          state = state.copyWith(isLoading: false);
        }
      },
    );
  }

  /// Starts the timer.
  void start() {
    if (state.isRunning) return;

    final now = DateTime.now();
    state = state.copyWith(
      isRunning: true,
      startTime: now,
      // If we are starting fresh (not resumed), ensure remaining matches duration
      // But if we are effectively resuming a paused timer, keep remaining as is.
      // Wait, if we paused, start time is null.
      // So when we start, we need to treat current 'remainingSeconds' as the NEW duration relative to now?
      // Or should we track 'initialDuration' separately?
      // Logic:
      // When effectively resuming: targetEndTime = now + remainingSeconds
      // startTime = now - (initialDuration - remainingSeconds) ??
      // Let's simplify:
      // We track 'startTime' as the time when the current *logical* session started.
      // But for simple "Resume", it's easier to say:
      // effectiveStartTime = now - (timeElapsedSoFar)
      // timeElapsedSoFar = initialDuration - remainingSeconds
    );

    // Adjust startTime to account for elapsed time if this is a resume
    final elapsedSeconds =
        (state.initialDuration * 60) - state.remainingSeconds;
    state = state.copyWith(
      startTime: now.subtract(Duration(seconds: elapsedSeconds)),
    );

    _saveState();
    _startTicker();
  }

  /// Pauses the timer.
  void pause() {
    if (!state.isRunning) return;

    _tickerSubscription?.cancel();
    state = state.copyWith(
      isRunning: false,
      startTime: null, // Clear start time on pause
    );
    _saveState();
  }

  /// Resets the timer to the start of the current mode.
  void reset() {
    _tickerSubscription?.cancel();
    state = state.copyWith(
      isRunning: false,
      remainingSeconds: state.initialDuration * 60,
      startTime: null,
      isCompleted: false,
    );
    _repository.clearTimerState();
  }

  /// Skips the current session (completes it immediately? or just moves to next?)
  /// Usually "skip" means jump to next mode without earning tomatoes.
  void skip() {
    _completeSession(earnedTomato: false);
  }

  /// Ticks logic.
  void _startTicker() {
    _tickerSubscription?.cancel();
    _tickerSubscription = _ticker.tick().listen((_) => _onTick());
  }

  void _resumeTicker() {
    // Check if we already finished while backgrounded
    final now = DateTime.now();
    if (state.startTime != null) {
      final elapsed = now.difference(state.startTime!).inSeconds;
      final totalSeconds = state.initialDuration * 60;
      final remaining = totalSeconds - elapsed;

      if (remaining <= 0) {
        state = state.copyWith(remainingSeconds: 0);
        _onTimerComplete();
        return;
      } else {
        state = state.copyWith(remainingSeconds: remaining);
      }
    }
    _startTicker();
  }

  void _onTick() {
    if (!state.isRunning || state.startTime == null) return;

    final now = DateTime.now();
    final elapsed = now.difference(state.startTime!).inSeconds;
    final totalSeconds = state.initialDuration * 60;
    final remaining = totalSeconds - elapsed;

    if (remaining <= 0) {
      state = state.copyWith(remainingSeconds: 0);
      _onTimerComplete();
    } else {
      state = state.copyWith(remainingSeconds: remaining);
    }
  }

  void _onTimerComplete() {
    _tickerSubscription?.cancel();
    state = state.copyWith(
      isRunning: false,
      startTime: null,
      isCompleted: true,
    );

    // Auto-save completion state logic usually handled by UI listener
    // or we can auto-transition here.
    // For now, we stop and let UI handle "What happened?".
    // But we should probably clear the saved "running" state.
    _repository.clearTimerState();

    // NOTE: Actual session recording should be done by listening to this state change
    // in the UI or a coordinator provider that calls UserNotifier / HistoryNotifier.
  }

  void _completeSession({required bool earnedTomato}) {
    // Transition logic (Focus -> Break -> Focus)
    TimerMode nextMode;
    if (state.mode == TimerMode.focus) {
      final newCompleted = state.sessionsCompleted + 1;
      state = state.copyWith(sessionsCompleted: newCompleted);

      if (newCompleted % 4 == 0) {
        nextMode = TimerMode.longBreak;
      } else {
        nextMode = TimerMode.shortBreak;
      }
    } else {
      // Break is over, back to focus
      nextMode = TimerMode.focus;
    }

    _setMode(nextMode);
  }

  /// Sets the timer mode explicitly (e.g. from user choice)
  void setMode(TimerMode mode) {
    _setMode(mode);
  }

  /// Public method to force next mode (e.g. called by UI after completion)
  void nextMode() {
    _completeSession(
      earnedTomato: true,
    ); // Argument ignored by internal logic for now
  }

  void _setMode(TimerMode mode) {
    _tickerSubscription?.cancel();
    state = state.copyWith(
      mode: mode,
      initialDuration: mode.defaultMinutes,
      remainingSeconds: mode.defaultMinutes * 60,
      isRunning: false,
      startTime: null,
      isCompleted: false,
    );
    _repository.clearTimerState();
  }

  // ============ DEBUG METHODS ============
  // Bu metodlar SADECE test amaçlıdır, production'da kaldırılmalıdır

  /// [DEBUG] Kalan süreyi direkt olarak ayarlar
  void debugSetRemainingSeconds(int seconds) {
    if (seconds <= 0) {
      // Zamanlayıcıyı bitir
      state = state.copyWith(remainingSeconds: 0);
      _onTimerComplete();
    } else {
      state = state.copyWith(remainingSeconds: seconds);
      // StartTime'ı güncelle ki progress doğru hesaplansın
      if (state.isRunning && state.startTime != null) {
        final elapsed = (state.initialDuration * 60) - seconds;
        state = state.copyWith(
          startTime: DateTime.now().subtract(Duration(seconds: elapsed)),
        );
      }
    }
  }

  /// Updates configuration (e.g. user changed settings).
  void updateDuration(int minutes) {
    if (!state.isRunning) {
      state = state.copyWith(
        initialDuration: minutes,
        remainingSeconds: minutes * 60,
      );
    }
  }

  Future<void> _saveState() async {
    final snapshot = TimerSnapshot(
      mode: state.mode,
      initialDuration: state.initialDuration,
      remainingSeconds: state.remainingSeconds,
      isRunning: state.isRunning,
      startTime: state.startTime,
      sessionsCompleted: state.sessionsCompleted,
    );
    await _repository.saveTimerState(snapshot);
  }

  @override
  void dispose() {
    _tickerSubscription?.cancel();
    super.dispose();
  }
}
