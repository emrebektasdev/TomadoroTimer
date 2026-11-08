import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:tomadoro/features/timer/application/ticker.dart';
import 'package:tomadoro/features/timer/application/timer_notifier.dart';
import 'package:tomadoro/features/timer/data/datasources/timer_local_datasource.dart';
import 'package:tomadoro/features/timer/data/repositories/timer_repository_impl.dart';
import 'package:tomadoro/features/timer/domain/entities/timer_mode.dart';
import 'package:tomadoro/features/timer/domain/entities/timer_snapshot.dart';
import 'package:tomadoro/features/user/data/datasources/user_local_datasource.dart';

void main() {
  test(
    'Expired fourth focus survives restart and credits the harvest once',
    () async {
      final dir = await Directory.systemTemp.createTemp('tomadoro_test');
      Hive.init(dir.path);
      final box = await Hive.openBox('timer');
      final profile = UserLocalDataSource(await Hive.openBox('user'));
      final snapshots = TimerLocalDataSource(box);
      final repository = TimerRepositoryImpl(snapshots);
      final start = DateTime.now().subtract(const Duration(minutes: 2));
      final expired = TimerSnapshot(
        mode: TimerMode.focus,
        initialDuration: 1,
        remainingSeconds: 60,
        isRunning: true,
        startTime: start,
        sessionsCompleted: 3,
      );
      Future<void> harvest(DateTime anchor, int minutes) =>
          profile.creditHarvest(anchor.toIso8601String(), anchor, minutes);
      Future<TimerNotifier> restore() async {
        final timer = TimerNotifier(repository, Ticker(), harvest);
        for (
          var i = 0;
          i < 100 && (timer.state.isLoading || timer.state.isRunning);
          i++
        ) {
          await Future<void>.delayed(const Duration(milliseconds: 5));
        }
        return timer;
      }

      try {
        // Simulate process termination after crediting but before writing the completed snapshot.
        await harvest(start, 1);
        await snapshots.saveTimerSnapshot(expired);
        final timer = await restore();
        expect(timer.state.isCompleted, isTrue);
        expect(timer.state.sessionsCompleted, 4);
        expect(profile.getTomatoBalance(), 1);
        timer.dispose();
        final reopened = await restore();
        expect(reopened.state.isCompleted, isTrue);
        reopened.nextMode();
        expect(reopened.state.mode, TimerMode.longBreak);
        expect(profile.getTotalFocusMinutes(), 1);
        reopened.dispose();
      } finally {
        await Hive.close();
        await dir.delete(recursive: true);
      }
    },
  );
}
