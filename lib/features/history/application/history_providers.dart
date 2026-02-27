/// History feature Riverpod providers.
///
/// Providers for the history feature with dependency injection.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../core/constants/storage_keys.dart';
import '../data/datasources/history_local_datasource.dart';
import '../data/datasources/history_remote_datasource.dart';
import '../data/repositories/history_repository_impl.dart';
import '../domain/entities/daily_stats.dart';
import '../domain/entities/weekly_stats.dart';
import '../domain/repositories/history_repository.dart';
import 'history_notifier.dart';
import 'history_state.dart';

// ============ Data Layer Providers ============

/// Provides the history Hive box.
final historyBoxProvider = Provider<Box>((ref) {
  return Hive.box(HiveBoxes.dailyStats);
});

/// Provides the history local data source.
final historyLocalDataSourceProvider = Provider<HistoryLocalDataSource>((ref) {
  final box = ref.watch(historyBoxProvider);
  return HistoryLocalDataSource(box);
});

/// Provides the history remote data source.
final historyRemoteDataSourceProvider = Provider<HistoryRemoteDataSource>((
  ref,
) {
  return HistoryRemoteDataSource();
});

/// Provides the history repository implementation.
final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  final localDataSource = ref.watch(historyLocalDataSourceProvider);
  final remoteDataSource = ref.watch(historyRemoteDataSourceProvider);
  return HistoryRepositoryImpl(localDataSource, remoteDataSource);
});

// ============ Application Layer Providers ============

/// Main history state notifier provider.
final historyNotifierProvider =
    StateNotifierProvider<HistoryNotifier, HistoryState>((ref) {
      final repository = ref.watch(historyRepositoryProvider);
      return HistoryNotifier(repository);
    });

// ============ Selector Providers ============

/// Provides selected date.
final selectedDateProvider = Provider<DateTime>((ref) {
  return ref.watch(historyNotifierProvider.select((s) => s.selectedDate));
});

/// Provides selected day stats.
final selectedDayStatsProvider = Provider<DailyStats>((ref) {
  return ref.watch(historyNotifierProvider.select((s) => s.selectedDayStats));
});

/// Provides current week stats.
final currentWeekStatsProvider = Provider<WeeklyStats>((ref) {
  return ref.watch(historyNotifierProvider.select((s) => s.currentWeekStats));
});

/// Provides sessions for selected day.
final selectedDaySessionsProvider = Provider((ref) {
  return ref.watch(
    historyNotifierProvider.select((s) => s.selectedDaySessions),
  );
});

/// Provides dates with activity.
final datesWithActivityProvider = Provider<Set<String>>((ref) {
  return ref.watch(historyNotifierProvider.select((s) => s.datesWithActivity));
});

/// Provides loading state.
final historyLoadingProvider = Provider<bool>((ref) {
  return ref.watch(historyNotifierProvider.select((s) => s.isLoading));
});

/// Provides weekly chart data (daily minutes for the week).
final weeklyChartDataProvider = Provider<List<int>>((ref) {
  return ref.watch(
    historyNotifierProvider.select((s) => s.currentWeekStats.dailyMinutes),
  );
});

/// Provides today's stats.
final todayStatsProvider = Provider<DailyStats>((ref) {
  final state = ref.watch(historyNotifierProvider);

  final today = DateTime.now();
  if (state.isSelectedDate(today)) {
    return state.selectedDayStats;
  }

  // If today is not selected, return selected day stats as fallback
  return state.selectedDayStats;
});
