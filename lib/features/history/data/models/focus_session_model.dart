/// Hive model for FocusSession.
///
/// Used to persist focus sessions to local storage.
library;

import 'package:hive_flutter/hive_flutter.dart';

import '../../domain/entities/focus_session.dart';

part 'focus_session_model.g.dart';

@HiveType(typeId: 1)
class FocusSessionModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime startTime;

  @HiveField(2)
  final DateTime endTime;

  @HiveField(3)
  final int durationMinutes;

  @HiveField(4)
  final int tomatoesEarned;

  @HiveField(5)
  final bool completed;

  FocusSessionModel({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.durationMinutes,
    required this.tomatoesEarned,
    required this.completed,
  });

  /// Creates a model from a domain entity.
  factory FocusSessionModel.fromEntity(FocusSession entity) {
    return FocusSessionModel(
      id: entity.id,
      startTime: entity.startTime,
      endTime: entity.endTime,
      durationMinutes: entity.durationMinutes,
      tomatoesEarned: entity.tomatoesEarned,
      completed: entity.completed,
    );
  }

  /// Converts to a domain entity.
  FocusSession toEntity() {
    return FocusSession(
      id: id,
      startTime: startTime,
      endTime: endTime,
      durationMinutes: durationMinutes,
      tomatoesEarned: tomatoesEarned,
      completed: completed,
    );
  }
}
