/// Timer state notifier.
///
/// Manages the timer logic using a timestamp-based approach for reliability.
library;

import 'dart:async';

import 'package:flutter/foundation.dart';
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

  // Active profile durations (updated externally from provider listener)
  int _focusDuration = 25;
  int _shortBreakDuration = 5;
  int _longBreakDuration = 15;

  final Future<void> Function(DateTime, int) onHarvest;
  bool _finishing = false;
  final DateTime Function() _now;

  TimerNotifier(
    this._repository,
    this._ticker,
    this.onHarvest, {
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now,
       super(TimerState.initial().copyWith(isLoading: true)) {
    Future.microtask(() => _restoreState());
  }

  /// Called by the provider when user settings change to keep durations in sync.
  void updateProfileDurations({
    required int focus,
    required int shortBreak,
    required int longBreak,
  }) {
    _focusDuration = focus;
    _shortBreakDuration = shortBreak;
    _longBreakDuration = longBreak;
  }

  /// Restores timer state from persistence.
  Future<void> _restoreState() async {
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
            sessionDurationSeconds: snapshot.sessionDurationSeconds,
            remainingSeconds: snapshot.remainingSeconds,
            isRunning: snapshot.isRunning,
            isCompleted: !snapshot.isRunning && snapshot.remainingSeconds == 0,
            startTime: snapshot.startTime,
            sessionsCompleted: snapshot.sessionsCompleted,
            isLoading: false,
          );

          if (state.isRunning) {
            _resumeTicker();
          }
        } else {
          final duration = switch (state.mode) {
            TimerMode.focus => _focusDuration,
            TimerMode.shortBreak => _shortBreakDuration,
            TimerMode.longBreak => _longBreakDuration,
          };
          state = state.copyWith(
            initialDuration: duration,
            remainingSeconds: duration * 60,
            isLoading: false,
          );
        }
      },
    );
  }

  /// Starts the timer.
  void start() {
    if (state.isRunning || state.isLoading || state.isCompleted) return;

    final now = _now();
    final elapsedSeconds = state.totalSeconds - state.remainingSeconds;
    state = state.copyWith(
      isRunning: true,
      startTime: now.subtract(Duration(seconds: elapsedSeconds)),
    );

    _saveState();
    _startTicker();
  }

  /// Pauses the timer.
  void pause() {
    if (!state.isRunning || _finishing) return;

    _onTick();
    if (_finishing) return;
    _tickerSubscription?.cancel();
    state = state.copyWith(
      isRunning: false,
      startTime: null, // Clear start time on pause
    );
    _saveState();
  }

  /// Resets the timer to the start of the current mode.
  void reset() {
    if (_finishing) return;
    _tickerSubscription?.cancel();
    state = state.copyWith(
      isRunning: false,
      initialDuration: state.sessionDurationSeconds == null
          ? state.initialDuration
          : _focusDuration,
      remainingSeconds:
          (state.sessionDurationSeconds == null
              ? state.initialDuration
              : _focusDuration) *
          60,
      sessionDurationSeconds: null,
      startTime: null,
      isCompleted: false,
    );
    _saveState();
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
    final now = _now();
    if (state.startTime != null) {
      final elapsed = now.difference(state.startTime!).inSeconds;
      final totalSeconds = state.totalSeconds;
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

    final now = _now();
    final elapsed = now.difference(state.startTime!).inSeconds;
    final totalSeconds = state.totalSeconds;
    final remaining = totalSeconds - elapsed;

    if (remaining <= 0) {
      state = state.copyWith(remainingSeconds: 0);
      _onTimerComplete();
    } else {
      state = state.copyWith(remainingSeconds: remaining);
    }
  }

  Future<void> _onTimerComplete() async {
    if (_finishing || !state.isRunning || state.startTime == null) return;
    _finishing = true;
    _tickerSubscription?.cancel();
    try {
      if (state.mode == TimerMode.focus) {
        await onHarvest(state.startTime!, state.initialDuration);
      }
      state = state.copyWith(
        isRunning: false,
        isCompleted: true,
        remainingSeconds: 0,
        startTime: null,
        sessionsCompleted:
            state.sessionsCompleted + (state.mode == TimerMode.focus ? 1 : 0),
      );
      await _saveState();
    } catch (_) {
      // Retain the running snapshot so the same harvest can safely be retried.
      _startTicker();
    } finally {
      _finishing = false;
    }
  }

  void _completeSession({required bool earnedTomato}) {
    // Transition logic (Focus -> Break -> Focus)
    TimerMode nextMode;
    if (state.mode == TimerMode.focus) {
      final newCompleted = state.sessionsCompleted;

      if (earnedTomato && newCompleted > 0 && newCompleted % 4 == 0) {
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

  void _setMode(TimerMode mode, [int? customDuration]) {
    if (_finishing && !state.isCompleted) return;
    _tickerSubscription?.cancel();

    // Use stored profile durations, falling back to enum defaults as last resort.
    int duration;
    if (customDuration != null) {
      duration = customDuration;
    } else {
      switch (mode) {
        case TimerMode.focus:
          duration = _focusDuration;
          break;
        case TimerMode.shortBreak:
          duration = _shortBreakDuration;
          break;
        case TimerMode.longBreak:
          duration = _longBreakDuration;
          break;
      }
    }

    state = state.copyWith(
      mode: mode,
      initialDuration: duration,
      sessionDurationSeconds: null,
      remainingSeconds: duration * 60,
      isRunning: false,
      startTime: null,
      isCompleted: false,
    );
    _saveState();
  }

  // ============ DEBUG METHODS ============
  // Bu metodlar SADECE test amaçlıdır, production'da kaldırılmalıdır

  /// Extracted for provider configuration to fetch inner mode without triggering infinite cycle
  TimerMode get mode => state.mode;

  /// Uses the normal ticker, persistence and harvest path for the debug UI.
  void debugStartShortFocus() {
    if (!kDebugMode || state.isLoading || _finishing) return;
    _setMode(TimerMode.focus);
    state = state.copyWith(
      initialDuration: 0,
      sessionDurationSeconds: 10,
      remainingSeconds: 10,
    );
    start();
  }

  /// Updates configuration (e.g. user changed settings).
  void updateDuration(int minutes) {
    if (!state.isRunning &&
        !state.isCompleted &&
        state.progress == 0 &&
        minutes > 0) {
      state = state.copyWith(
        initialDuration: minutes,
        sessionDurationSeconds: null,
        remainingSeconds: minutes * 60,
      );
      _saveState();
    }
  }

  Future<void> _saveState() async {
    final snapshot = TimerSnapshot(
      mode: state.mode,
      initialDuration: state.initialDuration,
      sessionDurationSeconds: state.sessionDurationSeconds,
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
