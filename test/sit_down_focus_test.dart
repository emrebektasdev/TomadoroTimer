import 'dart:async';
import 'dart:ui' as ui;

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tomadoro/core/error/failures.dart';
import 'package:tomadoro/features/home/presentation/timer_screen.dart';
import 'package:tomadoro/features/timer/application/timer_providers.dart';
import 'package:tomadoro/features/timer/application/timer_notifier.dart';
import 'package:tomadoro/features/timer/application/ticker.dart';
import 'package:tomadoro/features/timer/domain/entities/timer_snapshot.dart';
import 'package:tomadoro/features/timer/domain/repositories/timer_repository.dart';
import 'package:tomadoro/features/user/application/user_providers.dart';
import 'package:tomadoro/features/user/domain/entities/user_settings.dart';
import 'package:tomadoro/widgets/tomato/tomato_clip.dart';

class _TimerStorage implements TimerRepository {
  TimerSnapshot? snapshot;
  @override
  Future<Either<Failure, TimerSnapshot?>> loadTimerState() async =>
      Right(snapshot);

  @override
  Future<Either<Failure, Unit>> saveTimerState(TimerSnapshot state) async {
    snapshot = state;
    return const Right(unit);
  }

  @override
  Future<Either<Failure, Unit>> clearTimerState() async => const Right(unit);
}

class _ManualTicker extends Ticker {
  final ticks = StreamController<int>.broadcast();
  @override
  Stream<int> tick() => ticks.stream;
}

final _painted = find.byWidgetPredicate(
  (widget) => widget is CustomPaint && widget.painter is TomatoClipPainter,
);

TomatoClipPainter _painter(WidgetTester tester) =>
    tester.widget<CustomPaint>(_painted).painter! as TomatoClipPainter;

final _ring = find.byWidgetPredicate(
  (w) => w is Semantics && w.properties.label == 'Odak ilerlemesi',
);

Future<void> _waitForClips(WidgetTester tester) async {
  for (
    var attempt = 0;
    attempt < 1000 && _painted.evaluate().isEmpty;
    attempt++
  ) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 20)),
    );
    await tester.pump();
  }
  expect(_painted, findsOneWidget);
}

Future<ProviderContainer> _openFocus(
  WidgetTester tester, {
  ValueNotifier<bool>? visible,
  StateProvider<String?>? equipped,
  StateProvider<String?>? background,
  TimerNotifier? timer,
}) async {
  final container = ProviderContainer(
    overrides: [
      timerRepositoryProvider.overrideWithValue(_TimerStorage()),
      if (timer != null) timerNotifierProvider.overrideWith((ref) => timer),
      userSettingsProvider.overrideWithValue(
        UserSettings.defaults().copyWith(notificationsEnabled: false),
      ),
      equippedAccessoryProvider.overrideWith(
        (ref) => equipped == null ? 'acc_sunglasses' : ref.watch(equipped),
      ),
      equippedBackgroundProvider.overrideWith(
        (ref) => background == null ? 'bg_sunset' : ref.watch(background),
      ),
      equippedSoundProvider.overrideWithValue(null),
    ],
  );
  addTearDown(container.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        home: visible == null
            ? const TimerScreen()
            : ValueListenableBuilder(
                valueListenable: visible,
                builder: (_, enabled, child) =>
                    TickerMode(enabled: enabled, child: child!),
                child: const TimerScreen(),
              ),
      ),
    ),
  );
  await tester.pump();
  return container;
}

Future<void> _press(WidgetTester tester, String label) async {
  final button = find.text(label);
  expect(button, findsOneWidget);
  await tester.ensureVisible(button);
  await tester.tap(button);
  await tester.pump();
}

Future<ByteData> _clipPixels(TomatoClip clip, double progress) async {
  final recorder = ui.PictureRecorder();
  TomatoClipPainter(
    clip: clip,
    progress: AlwaysStoppedAnimation(progress),
    glasses: true,
    scarf: true,
  ).paint(Canvas(recorder), const Size(600, 600));
  final picture = recorder.endRecording();
  final image = await picture.toImage(600, 600);
  try {
    return (await image.toByteData(format: ui.ImageByteFormat.rawRgba))!;
  } finally {
    image.dispose();
    picture.dispose();
  }
}

Future<int> _armCrossingRed(TomatoClip clip, double sampledFrame) async {
  final pixels = await _clipPixels(clip, sampledFrame / 56);
  // At frame 48 the arm covers this opaque body pixel only in the front order.
  // Both samples use frame 48's geometry.
  return pixels.getUint8((341 * 600 + 154) * 4);
}

Future<List<int>> _plantedSole(
  TomatoClipPainter painter, {
  int left = 196,
  int right = 290,
}) async {
  final rgba = (await _clipPixels(
    painter.clip,
    painter.progress.value,
  )).buffer.asUint8List();
  // The planted shoe's lower rows, below the baked leg and its occlusion.
  return [
    for (var y = 524; y < 541; y++)
      ...rgba.sublist((y * 600 + left) * 4, (y * 600 + right) * 4),
  ];
}

void main() {
  setUp(rootBundle.clear);

  testWidgets(
    'Hidden focus resumes its shown sitting and breathing poses without a jump',
    (tester) async {
      tester.view.physicalSize = const Size(448, 1500);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final visible = ValueNotifier(true);
      addTearDown(visible.dispose);
      final container = await _openFocus(tester, visible: visible);
      await _waitForClips(tester);
      await _press(tester, 'Odağa başla');
      await tester.pump(const Duration(milliseconds: 400));
      for (final duration in [
        const Duration(seconds: 1),
        const Duration(seconds: 4),
      ]) {
        final clip = _painter(tester).clip;
        expect(clip.duration, duration);
        final shown = _painter(tester).progress.value;
        visible.value = false;
        await tester.pump();
        await tester.pump(const Duration(seconds: 5));
        expect(container.read(timerNotifierProvider).isRunning, isTrue);
        expect(_painter(tester).progress.value, shown);
        visible.value = true;
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));
        expect(_painter(tester).clip, same(clip));
        expect(
          _painter(tester).progress.value,
          closeTo(shown + .1 / duration.inSeconds, .005),
        );
        if (duration.inSeconds == 1) {
          await tester.pump(const Duration(milliseconds: 600));
          await tester.pump(const Duration(milliseconds: 700));
        }
      }
      container.read(timerNotifierProvider.notifier).pause();
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets('Debug short focus starts ten actual seconds of progress', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(448, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final container = await _openFocus(tester);
    await _waitForClips(tester);
    await _press(tester, '10 saniyelik odak');
    final state = container.read(timerNotifierProvider);
    expect(state.isRunning, isTrue);
    expect(state.remainingSeconds, 10);
    expect(state.progress, 0);
    expect(find.text('00:10'), findsOneWidget);
    expect(_ring, findsOneWidget);
    expect(tester.widget<Semantics>(_ring).properties.value, '0%');
    container.read(timerNotifierProvider.notifier).pause();
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets(
    'Completion preserves the visible breath pose then holds its last frame',
    (tester) async {
      tester.view.physicalSize = const Size(448, 1500);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final visible = ValueNotifier(true);
      addTearDown(visible.dispose);
      final ticks = _ManualTicker();
      addTearDown(ticks.ticks.close);
      var now = DateTime(2026, 11, 11);
      var harvests = 0;
      final storage = _TimerStorage();
      final timer = TimerNotifier(storage, ticks, (_, _) async {
        harvests++;
      }, now: () => now);
      final accessory = StateProvider<String?>((ref) => 'acc_sunglasses');
      final background = StateProvider<String?>((ref) => 'bg_sunset');
      final container = await _openFocus(
        tester,
        visible: visible,
        timer: timer,
        equipped: accessory,
        background: background,
      );
      await _waitForClips(tester);
      await _press(tester, '10 saniyelik odak');
      await tester.pump(const Duration(milliseconds: 1001));
      await tester.pump(const Duration(milliseconds: 717));
      final breathing = _painter(tester).clip;
      expect(breathing.duration, const Duration(seconds: 4));
      now = now.add(const Duration(seconds: 4));
      ticks.ticks.add(0);
      await tester.pump();
      expect(timer.state.progress, .4);
      expect(tester.widget<Semantics>(_ring).properties.value, '40%');
      await _press(tester, 'Duraklat');
      final paused = _painter(tester).progress.value;
      now = now.add(const Duration(seconds: 7));
      ticks.ticks.add(0);
      await tester.pump(const Duration(seconds: 7));
      expect(timer.state.remainingSeconds, 6);
      expect(tester.widget<Semantics>(_ring).properties.value, '40%');
      expect(_painter(tester).progress.value, paused);
      await _press(tester, 'Devam et');
      await tester.pump(const Duration(milliseconds: 241));
      final before = (await tester.runAsync(
        () => _clipPixels(breathing, _painter(tester).progress.value),
      ))!.buffer.asUint8List();
      final stage = tester.getTopLeft(_painted);
      now = now.add(const Duration(seconds: 6));
      ticks.ticks.add(0);
      await tester.pump();
      expect(timer.state.isCompleted, isTrue);
      expect(timer.state.remainingSeconds, 0);
      expect(timer.state.progress, 1);
      expect(tester.widget<Semantics>(_ring).properties.value, '100%');
      expect(harvests, 1);
      expect(find.text('00:00'), findsOneWidget);
      expect(find.text('Oturum tamamlandı'), findsOneWidget);
      expect(_painted, findsOneWidget);
      expect(tester.getTopLeft(_painted), stage);
      final bridge = _painter(tester).clip;
      expect(bridge.duration, const Duration(milliseconds: 240));
      final initial = (await tester.runAsync(
        () => _clipPixels(bridge, 0),
      ))!.buffer.asUint8List();
      expect(initial, before);
      await tester.pump(const Duration(milliseconds: 241));
      final complete = _painter(tester).clip;
      expect(complete.duration.inMicroseconds, 1791667);
      await tester.pump(const Duration(milliseconds: 450));
      final playing = _painter(tester).progress.value;
      container.read(accessory.notifier).state = 'acc_scarf';
      container.read(background.notifier).state = 'bg_night';
      await tester.pump();
      expect(_painter(tester).scarf, isTrue);
      expect(_painter(tester).progress.value, playing);
      await tester.pump(const Duration(seconds: 2));
      expect(_painter(tester).clip, same(complete));
      expect(_painter(tester).progress.value, 1);
      visible.value = false;
      await tester.pump();
      await tester.pump(const Duration(seconds: 20));
      visible.value = true;
      await tester.pump();
      expect(_painter(tester).clip, same(complete));
      expect(_painter(tester).progress.value, 1);
      expect(harvests, 1);
      // Recreate the screen against the completed persisted timer state.
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: TimerScreen()),
        ),
      );
      await _waitForClips(tester);
      expect(_painter(tester).progress.value, 1);
      expect(_painter(tester).clip.duration.inMicroseconds, 1791667);
      expect(harvests, 1);
      await _press(tester, 'Molayı geç');
      expect(_painter(tester).clip.duration, const Duration(seconds: 3));
      await _press(tester, 'Odağa başla');
      expect(_painter(tester).clip.duration, const Duration(seconds: 1));
      await _press(tester, 'Seansı sıfırla');
      expect(_painter(tester).clip.duration, const Duration(seconds: 3));
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets('Idle schedules one waiting clip after a fresh visible wait', (
    tester,
  ) async {
    final visible = ValueNotifier(true);
    addTearDown(visible.dispose);
    await _openFocus(tester, visible: visible);
    await _waitForClips(tester);
    final idle = _painter(tester).clip;
    expect(idle.duration, const Duration(seconds: 3));

    await tester.pump(const Duration(seconds: 9));
    expect(_painter(tester).clip, same(idle));
    visible.value = false;
    await tester.pump();
    await tester.pump(const Duration(seconds: 21));
    expect(_painter(tester).clip, same(idle));

    visible.value = true;
    await tester.pump();
    await tester.pump(const Duration(seconds: 9));
    expect(_painter(tester).clip, same(idle));
    await tester.pump(const Duration(seconds: 11));
    expect(
      _painter(tester).clip.duration.inMilliseconds,
      anyOf(2833, 2333, 2666, 2208, 2000),
    );
    await tester.pump(const Duration(seconds: 3));
    expect(_painter(tester).clip, same(idle));
    await tester.pump(const Duration(seconds: 9));
    expect(_painter(tester).clip, same(idle));
    await tester.pumpWidget(const SizedBox.shrink());
  });

  for (final (label, duration, peakMs, soleLeft, soleRight) in [
    ('Esnemeyi oynat', 2208333, 1125, 196, 405),
    ('Denge toplamayı oynat', 2000000, 875, 311, 405),
  ]) {
    testWidgets('$label settles the shown pose before sitting', (tester) async {
      tester.view.physicalSize = const Size(448, 1200);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final container = await _openFocus(tester);
      await _waitForClips(tester);
      final idle = _painter(tester).clip;
      await _press(tester, label);
      final gesture = _painter(tester).clip;
      expect(gesture.duration.inMicroseconds, duration);
      await tester.pump(Duration(microseconds: duration + 1000));
      expect(_painter(tester).clip, same(idle));

      await _press(tester, label);
      await tester.pump(Duration(milliseconds: peakMs));
      final position = _painter(tester).progress.value;
      final stage = tester.getTopLeft(_painted);
      final before = await tester.runAsync(
        () => _plantedSole(_painter(tester), left: soleLeft, right: soleRight),
      );
      expect(before!.any((value) => value != 0), isTrue);
      await _press(tester, 'Odağa başla');
      expect(container.read(timerNotifierProvider).isRunning, isTrue);
      expect(_painter(tester).clip, same(gesture));
      expect(_painter(tester).progress.value, position);
      expect(tester.getTopLeft(_painted), stage);
      await tester.pump(const Duration(milliseconds: 120));
      expect(_painter(tester).clip, same(gesture));
      expect(_painter(tester).progress.value, greaterThan(position));
      final after = await tester.runAsync(
        () => _plantedSole(_painter(tester), left: soleLeft, right: soleRight),
      );
      expect(after, before);
      await tester.pump(const Duration(milliseconds: 550));
      expect(_painter(tester).clip.duration, const Duration(seconds: 1));
      await tester.pump(const Duration(milliseconds: 1001));
      expect(_painter(tester).clip.duration, const Duration(seconds: 4));
      container.read(timerNotifierProvider.notifier).pause();
      await tester.pumpWidget(const SizedBox.shrink());
    });
  }

  testWidgets('Fidget lands from either lift with its support foot fixed', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(448, 1050);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final equipped = StateProvider<String?>((ref) => 'acc_scarf');
    final container = await _openFocus(tester, equipped: equipped);
    await _waitForClips(tester);
    final idle = _painter(tester).clip;
    await _press(tester, 'Oyalanmayı oynat');
    final fidget = _painter(tester).clip;
    expect(fidget.duration.inMicroseconds, 2666667);
    await tester.pump(const Duration(milliseconds: 2668));
    expect(_painter(tester).clip, same(idle));

    for (final (lift, reverse) in [(625, true), (1042, false)]) {
      await _press(tester, 'Oyalanmayı oynat');
      await tester.pump(Duration(milliseconds: lift));
      final start = _painter(tester).progress.value;
      final stage = tester.getTopLeft(_painted);
      final initialSole = (await tester.runAsync(
        () => _plantedSole(_painter(tester)),
      ))!;
      expect(initialSole.any((channel) => channel != 0), isTrue);

      await _press(tester, 'Odağa başla');
      expect(container.read(timerNotifierProvider).isRunning, isTrue);
      expect(tester.getTopLeft(_painted), stage);
      expect(_painter(tester).clip, same(fidget));
      expect(_painter(tester).progress.value, start);
      await tester.pump(const Duration(milliseconds: 120));
      expect(_painter(tester).clip, same(fidget));
      expect(
        _painter(tester).progress.value,
        reverse ? lessThan(start) : greaterThan(start),
      );
      expect(_painter(tester).scarf, isTrue);
      final movedSole = await tester.runAsync(
        () => _plantedSole(_painter(tester)),
      );
      expect(movedSole, initialSole);
      await tester.pump(const Duration(milliseconds: 600));
      expect(_painter(tester).clip.duration, const Duration(seconds: 1));
      final sittingSole = await tester.runAsync(
        () => _plantedSole(_painter(tester)),
      );
      expect(sittingSole, initialSole);
      await tester.pump(const Duration(milliseconds: 1001));
      expect(_painter(tester).clip.duration, const Duration(seconds: 4));
      await _press(tester, 'Seansı sıfırla');
      expect(_painter(tester).clip, same(idle));
    }
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('Starting at leaf contact follows the authored lowering frames', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(448, 1050);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final equipped = StateProvider<String?>((ref) => 'acc_scarf');
    final container = await _openFocus(tester, equipped: equipped);
    await _waitForClips(tester);
    await _press(tester, 'Yaprak düzeltmeyi oynat');
    await tester.pump(const Duration(milliseconds: 1125));
    final leaf = _painter(tester).clip;
    final contact = _painter(tester).progress.value;
    expect(leaf.duration.inMilliseconds, 2333);
    expect(contact, closeTo(.482, .01));
    expect(_painter(tester).scarf, isTrue);
    await tester.runAsync(() async {
      final crossing = await _armCrossingRed(leaf, 46.6);
      final behind = await _armCrossingRed(leaf, 47);
      expect(crossing, greaterThan(behind + 25));
    });
    expect(
      tester
          .widget<TextButton>(
            find.widgetWithText(TextButton, 'Düşünmeyi oynat'),
          )
          .onPressed,
      isNull,
    );
    expect(
      tester
          .widget<TextButton>(
            find.widgetWithText(TextButton, 'Yaprak düzeltmeyi oynat'),
          )
          .onPressed,
      isNull,
    );

    final stagePosition = tester.getTopLeft(_painted);
    await _press(tester, 'Odağa başla');
    expect(container.read(timerNotifierProvider).isRunning, isTrue);
    expect(tester.getTopLeft(_painted), stagePosition);
    expect(_painter(tester).clip, same(leaf));
    expect(_painter(tester).progress.value, contact);
    await tester.pump(const Duration(milliseconds: 250));
    expect(_painter(tester).clip, same(leaf));
    expect(_painter(tester).progress.value, greaterThan(contact));
    container.read(equipped.notifier).state = 'acc_sunglasses';
    final lowering = _painter(tester).progress.value;
    await tester.pump();
    expect(_painter(tester).glasses, isTrue);
    expect(_painter(tester).progress.value, lowering);
    await tester.pump(const Duration(milliseconds: 450));
    expect(_painter(tester).clip.duration, const Duration(seconds: 1));
    await tester.pump(const Duration(milliseconds: 1001));
    expect(_painter(tester).clip.duration, const Duration(seconds: 4));
    container.read(timerNotifierProvider.notifier).pause();
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('Starting during think lowers the hand from the visible frame', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(448, 1050);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final equipped = StateProvider<String?>((ref) => 'acc_sunglasses');
    final background = StateProvider<String?>((ref) => 'bg_sunset');
    final container = await _openFocus(
      tester,
      equipped: equipped,
      background: background,
    );
    await _waitForClips(tester);
    await _press(tester, 'Düşünmeyi oynat');
    await tester.pump(const Duration(milliseconds: 1200));
    final think = _painter(tester).clip;
    final startingPosition = _painter(tester).progress.value;
    expect(think.duration.inMilliseconds, 2833);
    expect(startingPosition, closeTo(.424, .01));

    container.read(equipped.notifier).state = 'acc_scarf';
    container.read(background.notifier).state = 'bg_night';
    await tester.pump();
    expect(_painter(tester).scarf, isTrue);
    expect(_painter(tester).progress.value, startingPosition);
    expect(find.text('Ay Işığı'), findsOneWidget);

    final stagePosition = tester.getTopLeft(_painted);
    await _press(tester, 'Odağa başla');
    expect(container.read(timerNotifierProvider).isRunning, isTrue);
    expect(tester.getTopLeft(_painted), stagePosition);
    expect(_painter(tester).clip, same(think));
    expect(_painter(tester).progress.value, startingPosition);
    await tester.pump(const Duration(milliseconds: 100));
    expect(_painter(tester).clip, same(think));
    expect(_painter(tester).progress.value, lessThan(startingPosition));

    await tester.pump(const Duration(milliseconds: 500));
    expect(_painter(tester).clip.duration, const Duration(seconds: 1));
    await tester.pump(const Duration(milliseconds: 1001));
    expect(_painter(tester).clip.duration, const Duration(seconds: 4));
    container.read(timerNotifierProvider.notifier).pause();
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets(
    'Focus plays the transition and preserves the active clip on pause',
    (tester) async {
      final equipped = StateProvider<String?>((ref) => 'acc_sunglasses');
      final background = StateProvider<String?>((ref) => 'bg_sunset');
      final container = await _openFocus(
        tester,
        equipped: equipped,
        background: background,
      );
      expect(find.text('Sonbahar Bahçesi'), findsOneWidget);

      await tester.ensureVisible(find.text('Odağa başla'));
      await tester.tap(find.text('Odağa başla'));
      expect(container.read(timerNotifierProvider).isRunning, isTrue);

      TomatoClipPainter painter() => _painter(tester);
      await _waitForClips(tester);
      expect(painter().glasses, isTrue);
      expect(painter().scarf, isFalse);
      expect(painter().clip.duration, const Duration(seconds: 1));
      await tester.pump(const Duration(milliseconds: 400));

      Future<void> press(String label) => _press(tester, label);

      await press('Duraklat');
      final pausedSit = painter().progress.value;
      expect(pausedSit, closeTo(.4, .01));
      await tester.pump(const Duration(seconds: 1));
      expect(painter().progress.value, pausedSit);
      expect(painter().clip.duration, const Duration(seconds: 1));
      container.read(equipped.notifier).state = 'acc_scarf';
      await tester.pump();
      expect(painter().scarf, isTrue);
      expect(painter().glasses, isFalse);
      expect(painter().progress.value, pausedSit);

      String resumeLabel() => container.read(timerNotifierProvider).progress > 0
          ? 'Devam et'
          : 'Odağa başla';
      await press(resumeLabel());
      await tester.pump(const Duration(milliseconds: 300));
      expect(painter().progress.value, closeTo(.7, .01));
      await tester.pump(const Duration(milliseconds: 300));
      expect(painter().progress.value, 1);
      await tester.pump(const Duration(milliseconds: 1));
      expect(painter().clip.duration, const Duration(seconds: 4));
      expect(painter().scarf, isTrue);
      expect(painter().progress.value, closeTo(0, .01));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      expect(painter().progress.value, closeTo(.25, .01));

      container.read(background.notifier).state = 'bg_night';
      container.read(equipped.notifier).state = 'acc_sunglasses';
      await tester.pump();
      expect(find.text('Ay Işığı'), findsOneWidget);
      expect(painter().glasses, isTrue);
      expect(painter().scarf, isFalse);
      expect(painter().progress.value, closeTo(.25, .01));
      await press('Duraklat');
      await tester.pump(const Duration(seconds: 2));
      expect(painter().progress.value, closeTo(.25, .01));
      await press(resumeLabel());
      await tester.pump(const Duration(seconds: 4, milliseconds: 500));
      expect(painter().clip.duration, const Duration(seconds: 4));
      expect(painter().progress.value, closeTo(.375, .01));

      await press('Seansı sıfırla');
      expect(painter().clip.duration, const Duration(seconds: 3));
      await press('Odağa başla');
      expect(painter().clip.duration, const Duration(seconds: 1));
      expect(painter().progress.value, 0);
      container.read(timerNotifierProvider.notifier).pause();
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );
}
