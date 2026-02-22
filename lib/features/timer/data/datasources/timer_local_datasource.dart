/// Timer local data source.
///
/// Handles Hive persistence for timer state.
library;

import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/entities/timer_mode.dart';
import '../../domain/entities/timer_snapshot.dart';

/// Local data source for timer persistence.
class TimerLocalDataSource {
  final Box _timerBox;

  TimerLocalDataSource(this._timerBox);

  static const _timerStateKey = 'timer_state';

  /// Saves timer snapshot.
  Future<void> saveTimerSnapshot(TimerSnapshot snapshot) async {
    try {
      final json = jsonEncode(_snapshotToJson(snapshot));
      await _timerBox.put(_timerStateKey, json);
    } catch (e, stackTrace) {
      throw CacheException(
        'Failed to save timer state',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Loads timer snapshot.
  TimerSnapshot? loadTimerSnapshot() {
    try {
      final json = _timerBox.get(_timerStateKey) as String?;
      if (json == null) return null;
      final map = jsonDecode(json) as Map<String, dynamic>;
      return _snapshotFromJson(map);
    } catch (e, stackTrace) {
      throw CacheException(
        'Failed to load timer state',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Clears timer snapshot.
  Future<void> clearTimerSnapshot() async {
    await _timerBox.delete(_timerStateKey);
  }

  // ============ Helpers ============

  Map<String, dynamic> _snapshotToJson(TimerSnapshot snapshot) {
    return {
      'mode': snapshot.mode.index,
      'initialDuration': snapshot.initialDuration,
      'remainingSeconds': snapshot.remainingSeconds,
      'isRunning': snapshot.isRunning,
      'startTime': snapshot.startTime?.toIso8601String(),
      'sessionsCompleted': snapshot.sessionsCompleted,
    };
  }

  TimerSnapshot _snapshotFromJson(Map<String, dynamic> json) {
    return TimerSnapshot(
      mode: TimerMode.values[json['mode'] as int],
      initialDuration: json['initialDuration'] as int,
      remainingSeconds: json['remainingSeconds'] as int,
      isRunning: json['isRunning'] as bool,
      startTime: json['startTime'] != null
          ? DateTime.parse(json['startTime'] as String)
          : null,
      sessionsCompleted: json['sessionsCompleted'] as int? ?? 0,
    );
  }
}
