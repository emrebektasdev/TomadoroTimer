/// Represents a focus session record
class FocusSession {
  final String id;
  final DateTime startTime;
  final DateTime endTime;
  final int durationMinutes;
  final int tomatoesEarned;
  final bool completed;

  const FocusSession({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.durationMinutes,
    required this.tomatoesEarned,
    required this.completed,
  });

  factory FocusSession.fromJson(Map<String, dynamic> json) {
    return FocusSession(
      id: json['id'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      durationMinutes: json['durationMinutes'] as int,
      tomatoesEarned: json['tomatoesEarned'] as int,
      completed: json['completed'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'durationMinutes': durationMinutes,
      'tomatoesEarned': tomatoesEarned,
      'completed': completed,
    };
  }
}

/// Represents daily focus statistics
class DailyStats {
  final DateTime date;
  final int totalFocusMinutes;
  final int sessionsCompleted;
  final int tomatoesEarned;

  const DailyStats({
    required this.date,
    required this.totalFocusMinutes,
    required this.sessionsCompleted,
    required this.tomatoesEarned,
  });

  factory DailyStats.empty(DateTime date) {
    return DailyStats(
      date: date,
      totalFocusMinutes: 0,
      sessionsCompleted: 0,
      tomatoesEarned: 0,
    );
  }

  factory DailyStats.fromJson(Map<String, dynamic> json) {
    return DailyStats(
      date: DateTime.parse(json['date'] as String),
      totalFocusMinutes: json['totalFocusMinutes'] as int,
      sessionsCompleted: json['sessionsCompleted'] as int,
      tomatoesEarned: json['tomatoesEarned'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'totalFocusMinutes': totalFocusMinutes,
      'sessionsCompleted': sessionsCompleted,
      'tomatoesEarned': tomatoesEarned,
    };
  }
}

/// Represents user goals
class UserGoals {
  final int dailyFocusGoalMinutes;
  final int weeklyFocusGoalMinutes;
  final int dailyTomatoGoal;

  const UserGoals({
    this.dailyFocusGoalMinutes = 120, // 2 hours default
    this.weeklyFocusGoalMinutes = 600, // 10 hours default
    this.dailyTomatoGoal = 4,
  });

  factory UserGoals.fromJson(Map<String, dynamic> json) {
    return UserGoals(
      dailyFocusGoalMinutes: json['dailyFocusGoalMinutes'] as int? ?? 120,
      weeklyFocusGoalMinutes: json['weeklyFocusGoalMinutes'] as int? ?? 600,
      dailyTomatoGoal: json['dailyTomatoGoal'] as int? ?? 4,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dailyFocusGoalMinutes': dailyFocusGoalMinutes,
      'weeklyFocusGoalMinutes': weeklyFocusGoalMinutes,
      'dailyTomatoGoal': dailyTomatoGoal,
    };
  }

  UserGoals copyWith({
    int? dailyFocusGoalMinutes,
    int? weeklyFocusGoalMinutes,
    int? dailyTomatoGoal,
  }) {
    return UserGoals(
      dailyFocusGoalMinutes: dailyFocusGoalMinutes ?? this.dailyFocusGoalMinutes,
      weeklyFocusGoalMinutes: weeklyFocusGoalMinutes ?? this.weeklyFocusGoalMinutes,
      dailyTomatoGoal: dailyTomatoGoal ?? this.dailyTomatoGoal,
    );
  }
}
