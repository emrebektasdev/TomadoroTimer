/// History state for the application layer.
///
/// Immutable state exposed to the presentation layer.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

import '../domain/entities/daily_stats.dart';
import '../domain/entities/focus_session.dart';
import '../domain/entities/weekly_stats.dart';

part 'history_state.freezed.dart';

/// History state for a selected date/period.
@freezed
class HistoryState with _$HistoryState {
  const factory HistoryState({
    /// Currently selected date
    required DateTime selectedDate,

    /// Stats for the selected date
    required DailyStats selectedDayStats,

    /// Stats for the current week
    required WeeklyStats currentWeekStats,

    /// Sessions for the selected date
    @Default([]) List<FocusSession> selectedDaySessions,

    /// Dates that have activity (for calendar markers)
    @Default({}) Set<String> datesWithActivity,

    /// Whether the state is loading
    @Default(false) bool isLoading,

    /// Error message if something went wrong
    String? errorMessage,
  }) = _HistoryState;

  const HistoryState._();

  /// Creates initial state with today's date.
  factory HistoryState.initial() {
    final today = DateTime.now();
    return HistoryState(
      selectedDate: today,
      selectedDayStats: DailyStats.empty(_dateKey(today)),
      currentWeekStats: WeeklyStats(weekStart: today),
      isLoading: true,
    );
  }

  /// Whether date is selected date
  bool isSelectedDate(DateTime date) {
    return date.year == selectedDate.year &&
        date.month == selectedDate.month &&
        date.day == selectedDate.day;
  }

  /// Whether a date has activity
  bool hasActivity(DateTime date) {
    return datesWithActivity.contains(_dateKey(date));
  }

  /// Helper to create date key
  static String _dateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// Whether there's an error
  bool get hasError => errorMessage != null;
}
