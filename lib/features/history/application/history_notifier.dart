/// History state notifier.
///
/// Manages history state and exposes methods for history-related actions.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../domain/entities/focus_session.dart';
import '../domain/repositories/history_repository.dart';
import 'history_state.dart';

/// StateNotifier for managing history state.
class HistoryNotifier extends StateNotifier<HistoryState> {
  final HistoryRepository _repository;
  final Uuid _uuid = const Uuid();

  HistoryNotifier(this._repository) : super(HistoryState.initial()) {
    _loadInitialData();
  }

  /// Formats a date to YYYY-MM-DD key format.
  String _formatDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// Loads initial data.
  Future<void> _loadInitialData() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    // Load dates with activity
    final activityResult = await _repository.getDatesWithActivity();
    activityResult.fold(
      (f) => state = state.copyWith(errorMessage: f.displayMessage),
      (dates) => state = state.copyWith(datesWithActivity: dates),
    );

    // Load current week stats
    final weekResult = await _repository.getCurrentWeekStats();
    weekResult.fold(
      (f) => state = state.copyWith(errorMessage: f.displayMessage),
      (stats) => state = state.copyWith(currentWeekStats: stats),
    );

    // Load selected day data
    await _loadSelectedDayData();

    state = state.copyWith(isLoading: false);
  }

  /// Loads data for the currently selected date.
  Future<void> _loadSelectedDayData() async {
    // Get daily stats
    final statsResult = await _repository.getDailyStats(state.selectedDate);
    statsResult.fold(
      (f) => state = state.copyWith(errorMessage: f.displayMessage),
      (stats) => state = state.copyWith(selectedDayStats: stats),
    );

    // Get sessions for the day
    final sessionsResult = await _repository.getSessionsForDate(
      state.selectedDate,
    );
    sessionsResult.fold(
      (f) => state = state.copyWith(errorMessage: f.displayMessage),
      (sessions) => state = state.copyWith(selectedDaySessions: sessions),
    );
  }

  /// Selects a new date.
  Future<void> selectDate(DateTime date) async {
    if (state.isSelectedDate(date)) return;

    state = state.copyWith(selectedDate: date, isLoading: true);

    await _loadSelectedDayData();

    state = state.copyWith(isLoading: false);
  }

  /// Records a new focus session.
  Future<FocusSession?> recordSession({
    required DateTime startTime,
    required DateTime endTime,
    required int durationMinutes,
    required int tomatoesEarned,
  }) async {
    final session = FocusSession(
      id: _uuid.v4(),
      startTime: startTime,
      endTime: endTime,
      durationMinutes: durationMinutes,
      tomatoesEarned: tomatoesEarned,
    );

    final result = await _repository.recordSession(session);
    return result.fold(
      (failure) {
        state = state.copyWith(errorMessage: failure.displayMessage);
        return null;
      },
      (recorded) {
        // Update local state
        final dateKey = _formatDateKey(startTime);
        state = state.copyWith(
          datesWithActivity: {...state.datesWithActivity, dateKey},
          errorMessage: null,
        );

        // Reload if this is the selected day
        if (state.isSelectedDate(startTime)) {
          _loadSelectedDayData();
        }

        // Reload week stats
        _refreshWeekStats();

        return recorded;
      },
    );
  }

  /// Refreshes the week stats.
  Future<void> _refreshWeekStats() async {
    final weekResult = await _repository.getCurrentWeekStats();
    weekResult.fold(
      (f) => {},
      (stats) => state = state.copyWith(currentWeekStats: stats),
    );
  }

  /// Refreshes all data.
  Future<void> refresh() async {
    await _loadInitialData();
  }

  /// Gets focus minutes for a specific month.
  Future<int> getMonthlyMinutes(int year, int month) async {
    final result = await _repository.getMonthlyTotalMinutes(year, month);
    return result.fold((f) => 0, (minutes) => minutes);
  }

  /// Deletes a session.
  Future<bool> deleteSession(String sessionId) async {
    final result = await _repository.deleteSession(sessionId);
    return result.fold(
      (failure) {
        state = state.copyWith(errorMessage: failure.displayMessage);
        return false;
      },
      (_) {
        // Refresh the day's data
        _loadSelectedDayData();
        _refreshWeekStats();
        return true;
      },
    );
  }

  /// Clears error message.
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}
