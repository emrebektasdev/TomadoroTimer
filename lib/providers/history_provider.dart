import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/models/focus_session.dart';

/// Provider for managing focus history and statistics
class HistoryProvider extends ChangeNotifier {
  List<FocusSession> _sessions = [];
  Map<String, DailyStats> _dailyStats = {};
  
  List<FocusSession> get sessions => List.unmodifiable(_sessions);
  
  /// Load history from SharedPreferences
  Future<void> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    
    final sessionsJson = prefs.getStringList('focusSessions') ?? [];
    _sessions = sessionsJson
        .map((json) => FocusSession.fromJson(jsonDecode(json)))
        .toList();
    
    final statsJson = prefs.getString('dailyStats');
    if (statsJson != null) {
      final Map<String, dynamic> statsMap = jsonDecode(statsJson);
      _dailyStats = statsMap.map(
        (key, value) => MapEntry(key, DailyStats.fromJson(value)),
      );
    }
    
    notifyListeners();
  }
  
  /// Save history to SharedPreferences
  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    
    final sessionsJson = _sessions
        .map((session) => jsonEncode(session.toJson()))
        .toList();
    await prefs.setStringList('focusSessions', sessionsJson);
    
    final statsJson = jsonEncode(
      _dailyStats.map((key, value) => MapEntry(key, value.toJson())),
    );
    await prefs.setString('dailyStats', statsJson);
  }
  
  /// Record a completed focus session
  void recordSession(FocusSession session) {
    _sessions.add(session);
    
    // Update daily stats
    final dateKey = _getDateKey(session.endTime);
    final existingStats = _dailyStats[dateKey];
    
    if (existingStats != null) {
      _dailyStats[dateKey] = DailyStats(
        date: existingStats.date,
        totalFocusMinutes: existingStats.totalFocusMinutes + session.durationMinutes,
        sessionsCompleted: existingStats.sessionsCompleted + 1,
        tomatoesEarned: existingStats.tomatoesEarned + session.tomatoesEarned,
      );
    } else {
      _dailyStats[dateKey] = DailyStats(
        date: session.endTime,
        totalFocusMinutes: session.durationMinutes,
        sessionsCompleted: 1,
        tomatoesEarned: session.tomatoesEarned,
      );
    }
    
    _saveHistory();
    notifyListeners();
  }
  
  /// Get stats for a specific date
  DailyStats getStatsForDate(DateTime date) {
    final dateKey = _getDateKey(date);
    return _dailyStats[dateKey] ?? DailyStats.empty(date);
  }
  
  /// Get stats for today
  DailyStats get todayStats => getStatsForDate(DateTime.now());
  
  /// Get stats for this week
  int get weeklyFocusMinutes {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    
    int total = 0;
    for (int i = 0; i < 7; i++) {
      final date = weekStart.add(Duration(days: i));
      final stats = getStatsForDate(date);
      total += stats.totalFocusMinutes;
    }
    return total;
  }
  
  /// Get stats for this month
  int get monthlyFocusMinutes {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    
    int total = 0;
    for (int i = 0; i < daysInMonth; i++) {
      final date = monthStart.add(Duration(days: i));
      if (date.isAfter(now)) break;
      final stats = getStatsForDate(date);
      total += stats.totalFocusMinutes;
    }
    return total;
  }
  
  /// Get sessions for a specific date
  List<FocusSession> getSessionsForDate(DateTime date) {
    return _sessions.where((session) {
      return session.endTime.year == date.year &&
          session.endTime.month == date.month &&
          session.endTime.day == date.day;
    }).toList();
  }
  
  /// Get weekly stats as a list (Mon-Sun)
  List<DailyStats> getWeeklyStats() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    
    return List.generate(7, (index) {
      final date = weekStart.add(Duration(days: index));
      return getStatsForDate(date);
    });
  }
  
  /// Get dates with focus sessions (for calendar highlighting)
  Set<DateTime> get datesWithSessions {
    return _sessions.map((s) {
      final date = s.endTime;
      return DateTime(date.year, date.month, date.day);
    }).toSet();
  }
  
  String _getDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
