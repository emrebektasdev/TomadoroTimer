/// History repository interface.
///
/// Defines the contract for history data persistence.
library;

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/daily_stats.dart';
import '../entities/focus_session.dart';
import '../entities/weekly_stats.dart';

/// Repository contract for history-related data operations.
abstract class HistoryRepository {
  // ============ Session Operations ============

  /// Records a new focus session.
  Future<Either<Failure, FocusSession>> recordSession(FocusSession session);

  /// Gets all sessions for a specific date.
  Future<Either<Failure, List<FocusSession>>> getSessionsForDate(DateTime date);

  /// Gets sessions for a date range.
  Future<Either<Failure, List<FocusSession>>> getSessionsInRange(
    DateTime start,
    DateTime end,
  );

  /// Gets all sessions (for calendar markers).
  Future<Either<Failure, List<FocusSession>>> getAllSessions();

  /// Deletes a session by ID.
  Future<Either<Failure, Unit>> deleteSession(String sessionId);

  // ============ Daily Stats Operations ============

  /// Gets stats for a specific date.
  Future<Either<Failure, DailyStats>> getDailyStats(DateTime date);

  /// Gets stats for multiple dates.
  Future<Either<Failure, Map<String, DailyStats>>> getMultipleDailyStats(
    List<DateTime> dates,
  );

  /// Gets all dates that have activity (for calendar highlighting).
  Future<Either<Failure, Set<String>>> getDatesWithActivity();

  // ============ Weekly Stats Operations ============

  /// Gets stats for a specific week.
  Future<Either<Failure, WeeklyStats>> getWeeklyStats(DateTime weekStart);

  /// Gets stats for the current week.
  Future<Either<Failure, WeeklyStats>> getCurrentWeekStats();

  // ============ Aggregation ============

  /// Gets total focus minutes for a month.
  Future<Either<Failure, int>> getMonthlyTotalMinutes(int year, int month);

  /// Updates daily stats after a session is recorded.
  Future<Either<Failure, DailyStats>> updateDailyStats(
    DateTime date,
    int additionalMinutes,
    int additionalTomatoes,
  );
}
