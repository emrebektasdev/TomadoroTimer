import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../widgets/tomato/cozy_scene.dart';
import '../../../core/di/core_providers.dart';
import '../../../core/services/session_alert.dart';
import '../../shop/data/datasources/default_shop_items.dart';
import '../../timer/application/timer_providers.dart';
import '../../timer/domain/entities/timer_mode.dart';
import '../../user/application/user_providers.dart';

final focusBackdropProvider = Provider((ref) {
  if (ref.watch(timerModeProvider) != TimerMode.focus) return null;
  return DefaultShopItems.backgroundFor(ref.watch(equippedBackgroundProvider));
});

class TimerScreen extends ConsumerStatefulWidget {
  const TimerScreen({super.key});
  @override
  ConsumerState<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends ConsumerState<TimerScreen> {
  final alert = SessionAlert();
  Future<void> audioChange = Future.value();

  Future<void> editDuration() async {
    final state = ref.read(timerNotifierProvider);
    var minutes = state.initialDuration.clamp(1, 180);
    final selected = await showModalBottomSheet<int>(
      context: context,
      showDragHandle: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheet) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const GardenHeading('ZAMANLAYICI', 'Süreyi ayarla'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () =>
                          setSheet(() => minutes = (minutes - 5).clamp(1, 180)),
                      child: const Text('−5 dk'),
                    ),
                    Text(
                      '$minutes dk',
                      style: const TextStyle(fontSize: 30, color: ink),
                    ),
                    TextButton(
                      onPressed: () =>
                          setSheet(() => minutes = (minutes + 5).clamp(1, 180)),
                      child: const Text('+5 dk'),
                    ),
                  ],
                ),
                Slider(
                  value: minutes.toDouble(),
                  min: 1,
                  max: 180,
                  divisions: 179,
                  label: '$minutes dakika',
                  onChanged: (v) => setSheet(() => minutes = v.round()),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(context, minutes),
                  child: const Text('Süreyi kaydet'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    if (selected == null || !mounted) return;
    final p = ref.read(userSettingsProvider).activeProfile;
    final updated = switch (state.mode) {
      TimerMode.focus => p.copyWith(focusDurationMinutes: selected),
      TimerMode.shortBreak => p.copyWith(shortBreakMinutes: selected),
      TimerMode.longBreak => p.copyWith(longBreakMinutes: selected),
    };
    await ref.read(userNotifierProvider.notifier).updateTimerProfile(updated);
  }

  void sounds() => showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (_) => Consumer(
      builder: (context, ref, _) {
        final current = ref.watch(equippedSoundProvider);
        final userState = ref.watch(userNotifierProvider);
        final user = ref.read(userNotifierProvider.notifier);
        final settings = ref.watch(userSettingsProvider);
        final soundOptions = <String?, String>{
          null: 'Sessiz',
          'sound_rain': 'Camda yağmur',
          'sound_cafe': 'Kafe uğultusu',
          if (userState.isItemPurchased('sound_forest'))
            'sound_forest': 'Orman esintisi',
          if (userState.isItemPurchased('sound_ocean'))
            'sound_ocean': 'Okyanus dalgaları',
          if (userState.isItemPurchased('sound_fireplace'))
            'sound_fireplace': 'Şömine çıtırtısı',
        };
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 4, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const GardenHeading('ÇALIŞMA KÖŞESİ', 'Ortam sesi'),
                for (final entry in soundOptions.entries)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(entry.value),
                    trailing: current == entry.key
                        ? const Icon(Icons.check, color: sage)
                        : null,
                    onTap: () => user.equipSound(entry.key),
                  ),
                const Divider(),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Bitiş bildirimi'),
                  value: settings.notificationsEnabled,
                  onChanged: user.setNotificationsEnabled,
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Seans sonu zili'),
                  value: settings.soundEnabled,
                  onChanged: settings.notificationsEnabled
                      ? user.setSoundEnabled
                      : null,
                ),
              ],
            ),
          ),
        );
      },
    ),
  );

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(timerNotifierProvider);
    final timer = ref.read(timerNotifierProvider.notifier);
    final focus = s.mode == TimerMode.focus;
    final sound = ref.watch(equippedSoundProvider);
    ref.listen(_ambientProvider, (prev, next) {
      audioChange = audioChange
          .then((_) {
            final player = ref.read(soundServiceProvider);
            return next == null ? player.stop() : player.play(next);
          })
          .catchError((Object e) {
            debugPrint('Ortam sesi çalınamadı: $e');
          });
    });
    ref.listen(_alarmProvider, (previous, next) {
      if (next.end == null && previous?.end == null) return;
      // Let a notification already due reach the system.
      if (next.end == null && ref.read(timerNotifierProvider).isCompleted) {
        return;
      }
      alert.update(
        end: next.end,
        chime: next.bell,
        vibrate: next.vibrate,
        focus: next.focus,
      );
    });
    final phase = focus
        ? 'Odak'
        : s.mode == TimerMode.shortBreak
        ? 'Kısa mola'
        : 'Uzun mola';
    final pose = s.isCompleted && focus
        ? GardenPose.harvest
        : !focus
        ? GardenPose.rest
        : s.isRunning || s.progress > 0
        ? GardenPose.focus
        : GardenPose.ready;
    final nextLong = s.sessionsCompleted > 0 && s.sessionsCompleted % 4 == 0;
    final label = s.isCompleted
        ? (focus
              ? (nextLong ? 'Uzun molaya başla' : 'Kısa molaya başla')
              : 'Odağa başla')
        : s.isRunning
        ? 'Duraklat'
        : s.progress > 0
        ? 'Devam et'
        : focus
        ? 'Odağa başla'
        : 'Molaya başla';
    final accessory = ref.watch(equippedAccessoryProvider);
    final backdrop = ref.watch(focusBackdropProvider);
    final lightHeading = const {
      'bg_forest',
      'bg_night',
      'bg_ocean',
    }.contains(backdrop?.id);
    return Scaffold(
      backgroundColor: backdrop == null
          ? const Color(0xfff1f4e8)
          : Colors.transparent,
      body: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, box) {
            final sceneHeight = (box.maxHeight * .36).clamp(140.0, 290.0);
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: box.maxHeight),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 530),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 14,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: GardenHeading(
                                  backdrop == null ||
                                          backdrop ==
                                              DefaultShopItems.sunnyGreenhouse
                                      ? 'SABAH SERASI'
                                      : backdrop.name,
                                  'Tomadoro',
                                  foreground: lightHeading ? parchment : null,
                                ),
                              ),
                              IconButton.filledTonal(
                                tooltip: 'Ortam sesi',
                                onPressed: sounds,
                                icon: Icon(
                                  sound == null
                                      ? Icons.volume_off_outlined
                                      : Icons.volume_up_outlined,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: sceneHeight,
                            width: double.infinity,
                            child: CozyScene(
                              pose: pose,
                              accessory: accessory,
                              showBackground: backdrop == null,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            s.isCompleted
                                ? (focus ? 'HASAT ZAMANI' : 'MOLA TAMAMLANDI')
                                : '${phase.toUpperCase()}   ·   ${s.sessionsCompleted % 4 + 1} / 4',
                            style: const TextStyle(
                              color: sage,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.8,
                            ),
                          ),
                          Semantics(
                            button: !s.isRunning && s.progress == 0,
                            label: '${s.formattedTime}, $phase',
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: !s.isRunning && s.progress == 0
                                  ? editDuration
                                  : null,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: Text(
                                  s.formattedTime,
                                  style: const TextStyle(
                                    color: ink,
                                    height: 1.16,
                                    fontSize: 72,
                                    letterSpacing: -3,
                                    fontFeatures: [
                                      FontFeature.tabularFigures(),
                                    ],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 162,
                            height: 18,
                            child: CustomPaint(painter: LeafBranch(s.progress)),
                          ),
                          Text(
                            s.isCompleted
                                ? (focus
                                      ? 'Bir domates hasadına eklendi.'
                                      : 'Bir sonraki seansa hazırsın.')
                                : s.isRunning
                                ? (focus
                                      ? 'Şimdi yalnızca önündeki işe odaklan.'
                                      : 'Kısa bir nefes al.')
                                : (s.progress > 0
                                      ? 'Kaldığın yerden devam edebilirsin.'
                                      : 'Süreyi değiştirmek için sayaca dokun.'),
                            style: const TextStyle(color: Color(0xff715e56)),
                          ),
                          const SizedBox(height: 18),
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: FilledButton.icon(
                              style: FilledButton.styleFrom(
                                backgroundColor: focus ? berry : sage,
                              ),
                              onPressed: s.isLoading
                                  ? null
                                  : () {
                                      if (s.isCompleted) timer.nextMode();
                                      if (s.isRunning) {
                                        timer.pause();
                                      } else {
                                        timer.start();
                                      }
                                    },
                              icon: Icon(
                                s.isRunning
                                    ? Icons.pause_rounded
                                    : Icons.play_arrow_rounded,
                              ),
                              label: Text(
                                label,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          if (s.isCompleted && focus)
                            TextButton(
                              onPressed: () => timer.setMode(TimerMode.focus),
                              child: const Text('Molayı geç'),
                            )
                          else if (!focus || s.progress > 0 || s.isRunning)
                            TextButton(
                              onPressed: () => focus
                                  ? timer.reset()
                                  : timer.setMode(TimerMode.focus),
                              child: Text(
                                focus ? 'Seansı sıfırla' : 'Odağa dön',
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

final _ambientProvider = Provider<String?>((ref) {
  final running = ref.watch(isTimerRunningProvider);
  return running && ref.watch(timerModeProvider) == TimerMode.focus
      ? ref.watch(equippedSoundProvider)
      : null;
});
final _alarmProvider = Provider((ref) {
  final anchor = ref.watch(
    timerNotifierProvider.select(
      (s) => (
        start: s.startTime,
        minutes: s.initialDuration,
        focus: s.mode == TimerMode.focus,
      ),
    ),
  );
  final settings = ref.watch(userSettingsProvider);
  final end = settings.notificationsEnabled
      ? anchor.start?.add(Duration(minutes: anchor.minutes))
      : null;
  return (
    end: end,
    bell: settings.soundEnabled,
    vibrate: settings.vibrationEnabled,
    focus: anchor.focus,
  );
});
