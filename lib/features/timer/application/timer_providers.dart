/// Timer feature Riverpod providers.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'ticker.dart';
import 'timer_notifier.dart';
import 'timer_state.dart';
import '../data/datasources/timer_local_datasource.dart';
import '../data/repositories/timer_repository_impl.dart';
import '../domain/repositories/timer_repository.dart';
import '../domain/entities/timer_mode.dart';
import '../../user/application/user_providers.dart';

// ============ Data Layer Providers ============

/// Provides the timer Hive box.
final timerBoxProvider = Provider<Box>((ref) {
  // We assume this box is opened in main.dart/bootstrap
  return Hive.box(
    'timer_state',
  ); // Using literal string as in implementation plan
});

/// Provides the timer local data source.
final timerLocalDataSourceProvider = Provider<TimerLocalDataSource>((ref) {
  final box = ref.watch(timerBoxProvider);
  return TimerLocalDataSource(box);
});

/// Provides the timer repository.
final timerRepositoryProvider = Provider<TimerRepository>((ref) {
  final dataSource = ref.watch(timerLocalDataSourceProvider);
  return TimerRepositoryImpl(dataSource);
});

/// Provides the ticker.
final tickerProvider = Provider<Ticker>((ref) => Ticker());

// ============ Application Layer Providers ============

/// Main timer state notifier provider.
final timerNotifierProvider = StateNotifierProvider<TimerNotifier, TimerState>((
  ref,
) {
  final repository = ref.watch(timerRepositoryProvider);
  final ticker = ref.watch(tickerProvider);

  final notifier = TimerNotifier(repository, ticker);

  // Seed profile durations from current settings immediately
  final initialSettings = ref.read(userSettingsProvider);
  notifier.updateProfileDurations(
    focus: initialSettings.activeProfile.focusDurationMinutes,
    shortBreak: initialSettings.activeProfile.shortBreakMinutes,
    longBreak: initialSettings.activeProfile.longBreakMinutes,
  );

  // Listen to UserSettings changes
  ref.listen(userSettingsProvider, (previous, next) {
    if (next == null) return;

    // Keep stored durations in sync for mode transitions
    notifier.updateProfileDurations(
      focus: next.activeProfile.focusDurationMinutes,
      shortBreak: next.activeProfile.shortBreakMinutes,
      longBreak: next.activeProfile.longBreakMinutes,
    );

    // Calculate active durations based on the active profile
    final currentMode = notifier.debugStateMode();
    int nextDuration;
    switch (currentMode) {
      case TimerMode.focus:
        nextDuration = next.activeProfile.focusDurationMinutes;
        break;
      case TimerMode.shortBreak:
        nextDuration = next.activeProfile.shortBreakMinutes;
        break;
      case TimerMode.longBreak:
        nextDuration = next.activeProfile.longBreakMinutes;
        break;
      default:
        nextDuration = next.activeProfile.focusDurationMinutes;
    }

    // Update the timer duration if it's currently stopped or matches this phase
    notifier.updateDuration(nextDuration);
  });

  return notifier;
});

// ============ Selector Providers ============

/// Provides current remaining formatted time.
final timerFormattedTimeProvider = Provider<String>((ref) {
  return ref.watch(timerNotifierProvider.select((s) => s.formattedTime));
});

/// Provides timer progress (0.0 to 1.0).
final timerProgressProvider = Provider<double>((ref) {
  return ref.watch(timerNotifierProvider.select((s) => s.progress));
});

/// Provides whether timer is running.
final isTimerRunningProvider = Provider<bool>((ref) {
  return ref.watch(timerNotifierProvider.select((s) => s.isRunning));
});

/// Provides current timer mode.
final timerModeProvider = Provider((ref) {
  return ref.watch(timerNotifierProvider.select((s) => s.mode));
});

/// Provides check if timer is completed.
final isTimerCompletedProvider = Provider<bool>((ref) {
  return ref.watch(timerNotifierProvider.select((s) => s.isCompleted));
});
