import 'dart:async';
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

class _ManualTicker extends Ticker {
  final ticks = StreamController<int>.broadcast();
  @override
  Stream<int> tick() => ticks.stream;
}

void main() {
  test(
    'Short focus pause and restart persist exact progress and credit one harvest',
    () async {
      final dir = await Directory.systemTemp.createTemp('tomadoro_short_focus');
      Hive.init(dir.path);
      final snapshots = TimerLocalDataSource(await Hive.openBox('timer'));
      final repository = TimerRepositoryImpl(snapshots);
      final profile = UserLocalDataSource(await Hive.openBox('user'));
      final ticks = _ManualTicker();
      var now = DateTime(2026, 11, 11, 12);
      Future<void> harvest(DateTime start, int minutes) =>
          profile.creditHarvest(start.toIso8601String(), start, minutes);
      var timer = TimerNotifier(repository, ticks, harvest, now: () => now);
      Future<void> flush() =>
          Future<void>.delayed(const Duration(milliseconds: 25));
      try {
        await flush();
        timer.debugStartShortFocus();
        expect(timer.state.remainingSeconds, 10);
        expect(timer.state.progress, 0);
        now = now.add(const Duration(seconds: 4));
        ticks.ticks.add(0);
        await flush();
        expect(timer.state.remainingSeconds, 6);
        expect(timer.state.progress, .4);
        timer.pause();
        await flush();
        now = now.add(const Duration(seconds: 20));
        timer.dispose();
        timer = TimerNotifier(repository, ticks, harvest, now: () => now);
        await flush();
        expect(timer.state.isRunning, isFalse);
        expect(timer.state.remainingSeconds, 6);
        expect(timer.state.progress, .4);
        timer.start();
        now = now.add(const Duration(seconds: 6));
        ticks.ticks.add(0);
        await flush();
        expect(timer.state.isCompleted, isTrue);
        expect(timer.state.formattedTime, '00:00');
        expect(timer.state.progress, 1);
        expect(timer.state.sessionsCompleted, 1);
        expect(profile.getTomatoBalance(), 1);
        // Ten debug seconds must not claim a normal 25-minute session.
        expect(profile.getTotalFocusMinutes(), 0);
        timer.dispose();
        timer = TimerNotifier(repository, ticks, harvest, now: () => now);
        await flush();
        ticks.ticks.add(0);
        timer.start();
        await flush();
        expect(timer.state.isCompleted, isTrue);
        expect(timer.state.sessionsCompleted, 1);
        expect(profile.getTomatoBalance(), 1);
        timer.reset();
        expect(timer.state.remainingSeconds, 1500);
        expect(timer.state.progress, 0);
      } finally {
        timer.dispose();
        await ticks.ticks.close();
        await Hive.close();
        await dir.delete(recursive: true);
      }
    },
  );
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
