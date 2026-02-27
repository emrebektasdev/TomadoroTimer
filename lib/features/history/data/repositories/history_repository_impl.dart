/// History repository implementation.
///
/// Implements HistoryRepository using Hive for persistence.
library;

import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/extensions/datetime_extensions.dart';
import '../../domain/entities/daily_stats.dart';
import '../../domain/entities/focus_session.dart';
import '../../domain/entities/weekly_stats.dart';
import '../../domain/repositories/history_repository.dart';
import '../datasources/history_local_datasource.dart';
import '../datasources/history_remote_datasource.dart';

/// Implementation of [HistoryRepository].
class HistoryRepositoryImpl implements HistoryRepository {
  final HistoryLocalDataSource _localDataSource;
  final HistoryRemoteDataSource _remoteDataSource;

  HistoryRepositoryImpl(this._localDataSource, this._remoteDataSource);

  @override
  Future<Either<Failure, FocusSession>> recordSession(
    FocusSession session,
  ) async {
    try {
      await _localDataSource.saveSession(session);
      // Update daily stats
      await _localDataSource.updateDailyStats(
        session.startTime,
        session.durationMinutes,
        session.tomatoesEarned,
      );
      return Right(session);
    } on CacheException catch (e) {
      return Left(Failure.cache(message: e.message, originalError: e));
    } catch (e) {
      return Left(
        Failure.unexpected(
          message: 'Failed to record session',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<FocusSession>>> getSessionsForDate(
    DateTime date,
  ) async {
    try {
      final sessions = _localDataSource.getSessionsForDate(date);
      return Right(sessions);
    } on CacheException catch (e) {
      return Left(Failure.cache(message: e.message, originalError: e));
    } catch (e) {
      return Left(
        Failure.unexpected(
          message: 'Failed to load sessions',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<FocusSession>>> getSessionsInRange(
    DateTime start,
    DateTime end,
  ) async {
    try {
      final sessions = _localDataSource.getSessionsInRange(start, end);
      return Right(sessions);
    } on CacheException catch (e) {
      return Left(Failure.cache(message: e.message, originalError: e));
    } catch (e) {
      return Left(
        Failure.unexpected(
          message: 'Failed to load sessions',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<FocusSession>>> getAllSessions() async {
    try {
      final sessions = _localDataSource.getAllSessions();
      return Right(sessions);
    } on CacheException catch (e) {
      return Left(Failure.cache(message: e.message, originalError: e));
    } catch (e) {
      return Left(
        Failure.unexpected(
          message: 'Failed to load sessions',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteSession(String sessionId) async {
    try {
      await _localDataSource.deleteSession(sessionId);
      return const Right(unit);
    } on CacheException catch (e) {
      return Left(Failure.cache(message: e.message, originalError: e));
    } catch (e) {
      return Left(
        Failure.unexpected(
          message: 'Failed to delete session',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, DailyStats>> getDailyStats(DateTime date) async {
    try {
      final stats = _localDataSource.getDailyStats(date);
      return Right(stats);
    } catch (e) {
      return Left(
        Failure.unexpected(message: 'Failed to load stats', originalError: e),
      );
    }
  }

  @override
  Future<Either<Failure, Map<String, DailyStats>>> getMultipleDailyStats(
    List<DateTime> dates,
  ) async {
    try {
      final result = <String, DailyStats>{};
      for (final date in dates) {
        final stats = _localDataSource.getDailyStats(date);
        result[date.toDateKey] = stats;
      }
      return Right(result);
    } catch (e) {
      return Left(
        Failure.unexpected(message: 'Failed to load stats', originalError: e),
      );
    }
  }

  @override
  Future<Either<Failure, Set<String>>> getDatesWithActivity() async {
    try {
      final dates = _localDataSource.getDatesWithSessions();
      return Right(dates);
    } catch (e) {
      return Left(
        Failure.unexpected(
          message: 'Failed to load activity dates',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, WeeklyStats>> getWeeklyStats(
    DateTime weekStart,
  ) async {
    try {
      final stats = _localDataSource.getWeeklyStats(weekStart);
      return Right(stats);
    } catch (e) {
      return Left(
        Failure.unexpected(
          message: 'Failed to load weekly stats',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, WeeklyStats>> getCurrentWeekStats() async {
    return getWeeklyStats(DateTime.now());
  }

  @override
  Future<Either<Failure, int>> getMonthlyTotalMinutes(
    int year,
    int month,
  ) async {
    try {
      final firstDay = DateTime(year, month, 1);
      final lastDay = DateTime(year, month + 1, 0);
      var total = 0;

      for (
        var day = firstDay;
        !day.isAfter(lastDay);
        day = day.add(const Duration(days: 1))
      ) {
        final stats = _localDataSource.getDailyStats(day);
        total += stats.totalMinutes;
      }

      return Right(total);
    } catch (e) {
      return Left(
        Failure.unexpected(
          message: 'Failed to calculate monthly total',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, DailyStats>> updateDailyStats(
    DateTime date,
    int additionalMinutes,
    int additionalTomatoes,
  ) async {
    try {
      final updated = await _localDataSource.updateDailyStats(
        date,
        additionalMinutes,
        additionalTomatoes,
      );
      return Right(updated);
    } on CacheException catch (e) {
      return Left(Failure.cache(message: e.message, originalError: e));
    } catch (e) {
      return Left(
        Failure.unexpected(message: 'Failed to update stats', originalError: e),
      );
    }
  }

  // ============ Sync ============

  @override
  Future<Either<Failure, Unit>> syncUnsyncedSessions(String uid) async {
    try {
      final unsynced = _localDataSource.getUnsyncedSessions();
      if (unsynced.isEmpty) return const Right(unit);

      await _remoteDataSource.saveSessions(uid, unsynced);

      // Mark as synced locally
      for (final session in unsynced) {
        final syncedSession = session.copyWith(isSynced: true);
        await _localDataSource.updateOrSaveSession(syncedSession);
      }

      return const Right(unit);
    } catch (e) {
      return Left(
        Failure.unexpected(
          message: 'Failed to sync sessions',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> restoreSessionsFromBackend(String uid) async {
    try {
      final sessions = await _remoteDataSource.getSessions(uid);

      for (final session in sessions) {
        await _localDataSource.updateOrSaveSession(session);
        // We also need to recalculate daily stats for these restored sessions
        // This is a simplified approach. In a more robust system, we might want
        // to fully rebuild the daily stats cache.
        _localDataSource.getDailyStats(session.startTime);
      }

      return const Right(unit);
    } catch (e) {
      return Left(
        Failure.unexpected(
          message: 'Failed to restore sessions',
          originalError: e,
        ),
      );
    }
  }
}
