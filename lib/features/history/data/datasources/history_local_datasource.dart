/// History local data source.
///
/// Handles direct interaction with Hive for history data.
library;

import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/extensions/datetime_extensions.dart';
import '../../domain/entities/daily_stats.dart';
import '../../domain/entities/focus_session.dart';
import '../../domain/entities/weekly_stats.dart';

/// Local data source for history data using Hive.
class HistoryLocalDataSource {
  final Box _historyBox;

  HistoryLocalDataSource(this._historyBox);

  // Key prefixes
  static const _sessionsKey = 'sessions';
  static const _dailyStatsPrefix = 'daily_';

  // ============ Session Operations ============

  /// Saves a focus session.
  Future<void> saveSession(FocusSession session) async {
    try {
      final sessions = _getSessions();
      sessions.add(_sessionToJson(session));
      await _historyBox.put(_sessionsKey, jsonEncode(sessions));
    } catch (e, stackTrace) {
      throw CacheException(
        'Failed to save session',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Gets all sessions.
  List<FocusSession> getAllSessions() {
    try {
      return _getSessions().map(_sessionFromJson).toList();
    } catch (e, stackTrace) {
      throw CacheException(
        'Failed to load sessions',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Gets sessions for a specific date.
  List<FocusSession> getSessionsForDate(DateTime date) {
    final dateKey = date.toDateKey;
    return getAllSessions().where((s) => s.dateKey == dateKey).toList()
      ..sort((a, b) => b.startTime.compareTo(a.startTime));
  }

  /// Gets sessions in a date range.
  List<FocusSession> getSessionsInRange(DateTime start, DateTime end) {
    return getAllSessions()
        .where(
          (s) =>
              s.startTime.isAfter(start.subtract(const Duration(days: 1))) &&
              s.startTime.isBefore(end.add(const Duration(days: 1))),
        )
        .toList()
      ..sort((a, b) => b.startTime.compareTo(a.startTime));
  }

  /// Deletes a session by ID.
  Future<void> deleteSession(String sessionId) async {
    try {
      final sessions = _getSessions();
      sessions.removeWhere((s) => s['id'] == sessionId);
      await _historyBox.put(_sessionsKey, jsonEncode(sessions));
    } catch (e, stackTrace) {
      throw CacheException(
        'Failed to delete session',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Gets all dates that have sessions.
  Set<String> getDatesWithSessions() {
    return getAllSessions().map((s) => s.dateKey).toSet();
  }

  // ============ Daily Stats Operations ============

  /// Gets daily stats for a date.
  DailyStats getDailyStats(DateTime date) {
    final dateKey = date.toDateKey;
    final key = '$_dailyStatsPrefix$dateKey';
    final json = _historyBox.get(key) as String?;

    if (json == null) {
      // Calculate from sessions if no cached stats
      return _calculateDailyStats(date);
    }

    try {
      final data = jsonDecode(json) as Map<String, dynamic>;
      return DailyStats(
        dateKey: data['dateKey'] as String,
        totalMinutes: data['totalMinutes'] as int? ?? 0,
        sessionsCompleted: data['sessionsCompleted'] as int? ?? 0,
        tomatoesEarned: data['tomatoesEarned'] as int? ?? 0,
        goalMinutes: data['goalMinutes'] as int? ?? 100,
      );
    } catch (e) {
      return _calculateDailyStats(date);
    }
  }

  /// Saves daily stats.
  Future<void> saveDailyStats(DailyStats stats) async {
    final key = '$_dailyStatsPrefix${stats.dateKey}';
    final json = jsonEncode({
      'dateKey': stats.dateKey,
      'totalMinutes': stats.totalMinutes,
      'sessionsCompleted': stats.sessionsCompleted,
      'tomatoesEarned': stats.tomatoesEarned,
      'goalMinutes': stats.goalMinutes,
    });
    await _historyBox.put(key, json);
  }

  /// Updates daily stats atomically.
  Future<DailyStats> updateDailyStats(
    DateTime date,
    int additionalMinutes,
    int additionalTomatoes,
  ) async {
    final current = getDailyStats(date);
    final updated = current.copyWith(
      totalMinutes: current.totalMinutes + additionalMinutes,
      sessionsCompleted: current.sessionsCompleted + 1,
      tomatoesEarned: current.tomatoesEarned + additionalTomatoes,
    );
    await saveDailyStats(updated);
    return updated;
  }

  // ============ Weekly Stats ============

  /// Calculates weekly stats.
  WeeklyStats getWeeklyStats(DateTime weekStart) {
    final monday = weekStart.startOfWeek;
    final dailyMinutes = <int>[];
    var totalMinutes = 0;
    var sessionsCompleted = 0;
    var tomatoesEarned = 0;
    var activeDays = 0;

    for (var i = 0; i < 7; i++) {
      final day = monday.add(Duration(days: i));
      final stats = getDailyStats(day);
      dailyMinutes.add(stats.totalMinutes);
      totalMinutes += stats.totalMinutes;
      sessionsCompleted += stats.sessionsCompleted;
      tomatoesEarned += stats.tomatoesEarned;
      if (stats.hasActivity) activeDays++;
    }

    return WeeklyStats(
      weekStart: monday,
      totalMinutes: totalMinutes,
      sessionsCompleted: sessionsCompleted,
      tomatoesEarned: tomatoesEarned,
      activeDays: activeDays,
      dailyMinutes: dailyMinutes,
    );
  }

  // ============ Helpers ============

  List<Map<String, dynamic>> _getSessions() {
    final json = _historyBox.get(_sessionsKey) as String?;
    if (json == null) return [];
    try {
      final list = jsonDecode(json) as List;
      return list.cast<Map<String, dynamic>>();
    } catch (_) {
      return [];
    }
  }

  Map<String, dynamic> _sessionToJson(FocusSession session) {
    return {
      'id': session.id,
      'startTime': session.startTime.toIso8601String(),
      'endTime': session.endTime.toIso8601String(),
      'durationMinutes': session.durationMinutes,
      'tomatoesEarned': session.tomatoesEarned,
      'completed': session.completed,
    };
  }

  FocusSession _sessionFromJson(Map<String, dynamic> json) {
    return FocusSession(
      id: json['id'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      durationMinutes: json['durationMinutes'] as int,
      tomatoesEarned: json['tomatoesEarned'] as int,
      completed: json['completed'] as bool? ?? true,
    );
  }

  DailyStats _calculateDailyStats(DateTime date) {
    final sessions = getSessionsForDate(date);
    if (sessions.isEmpty) {
      return DailyStats.empty(date.toDateKey);
    }

    var totalMinutes = 0;
    var tomatoesEarned = 0;
    for (final session in sessions) {
      totalMinutes += session.durationMinutes;
      tomatoesEarned += session.tomatoesEarned;
    }

    return DailyStats(
      dateKey: date.toDateKey,
      totalMinutes: totalMinutes,
      sessionsCompleted: sessions.length,
      tomatoesEarned: tomatoesEarned,
    );
  }
}
