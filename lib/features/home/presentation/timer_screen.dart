import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../widgets/tomato/cozy_scene.dart';
import '../../../widgets/tomato/tomato_clip.dart';
import '../../../widgets/tomato/focus_progress_ring.dart';
import '../../../widgets/tomato/focus_composition.dart';
import '../../../core/di/core_providers.dart';
import '../../../core/services/session_alert.dart';
import '../../shop/data/datasources/default_shop_items.dart';
import '../../timer/application/timer_providers.dart';
import '../../timer/application/timer_state.dart';
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

enum _FocusMotion {
  idle,
  thinking,
  fixingLeaf,
  fidgeting,
  stretching,
  rebalancing,
  loweringThinkHand,
  loweringLeafHand,
  settlingFidget,
  settlingStretch,
  settlingRebalance,
  sittingDown,
  breathing,
  bridgingComplete,
  completing,
  completed;

  static const gestures = [
    thinking,
    fixingLeaf,
    fidgeting,
    stretching,
    rebalancing,
  ];

  bool get isGesture => gestures.contains(this);
  bool get isWaiting => this == idle || isGesture;
  bool get isCompletion =>
      this == bridgingComplete || this == completing || this == completed;
  bool get isSettling =>
      this == loweringThinkHand ||
      this == loweringLeafHand ||
      this == settlingFidget ||
      this == settlingStretch ||
      this == settlingRebalance;
}

class _TimerScreenState extends ConsumerState<TimerScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  final alert = SessionAlert();
  Future<void> audioChange = Future.value();
  late final _clipProgress = AnimationController(vsync: this);
  late final _completionGlow = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 650),
  );
  FocusClips? _clips;
  TomatoClip? _completionBridge;
  _FocusMotion _motion = _FocusMotion.idle;
  final _random = Random();
  Timer? _waitingTimer;
  bool _routeVisible = false;
  late bool _appVisible;
  bool _rewindGesture = false;
  bool _debugFrozen = false;
  bool? _debugGlasses;
  bool? _debugScarf;
  bool _debugPanelOpen = false;

  @override
  void initState() {
    super.initState();
    final lifecycle = WidgetsBinding.instance.lifecycleState;
    _appVisible = lifecycle == null || lifecycle == AppLifecycleState.resumed;
    WidgetsBinding.instance.addObserver(this);
    _clipProgress.addStatusListener(_advanceFocusMotion);
    ref.listenManual(
      timerNotifierProvider,
      _syncFocusMotion,
      fireImmediately: true,
    );
    unawaited(_loadFocusClips());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final visible =
        TickerMode.of(context) && (ModalRoute.isCurrentOf(context) ?? true);
    if (_routeVisible == visible) return;
    _routeVisible = visible;
    _updateMotionVisibility();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _appVisible = state == AppLifecycleState.resumed;
    _updateMotionVisibility();
  }

  bool get _visible => _routeVisible && _appVisible;

  void _updateMotionVisibility() {
    if (_motion.isCompletion) {
      if (!_visible) _holdCompletedPose();
      return;
    }
    if (!_motion.isWaiting) {
      if (_visible) {
        _playFocusMotion();
      } else {
        _clipProgress.stop();
      }
      return;
    }
    if (_visible) {
      _playWaitingMotion();
    } else {
      _cancelWaitingTimer();
      _clipProgress.stop();
    }
  }

  void _cancelWaitingTimer() {
    _waitingTimer?.cancel();
    _waitingTimer = null;
  }

  TomatoClip? get _activeClip => switch (_motion) {
    _FocusMotion.idle => _clips?.idleBreathe,
    _FocusMotion.thinking || _FocusMotion.loweringThinkHand => _clips?.think,
    _FocusMotion.fixingLeaf || _FocusMotion.loweringLeafHand => _clips?.fixLeaf,
    _FocusMotion.fidgeting || _FocusMotion.settlingFidget => _clips?.fidget,
    _FocusMotion.stretching || _FocusMotion.settlingStretch => _clips?.stretch,
    _FocusMotion.rebalancing ||
    _FocusMotion.settlingRebalance => _clips?.rebalance,
    _FocusMotion.sittingDown => _clips?.sitDown,
    _FocusMotion.breathing => _clips?.focusBreathe,
    _FocusMotion.bridgingComplete => _completionBridge,
    _FocusMotion.completing || _FocusMotion.completed => _clips?.focusComplete,
  };

  bool _canPlayWaiting(TimerState state) =>
      _visible &&
      state.mode == TimerMode.focus &&
      !state.isRunning &&
      !state.isCompleted &&
      !state.isLoading;

  void _playWaitingMotion() {
    if (!_motion.isWaiting ||
        !_canPlayWaiting(ref.read(timerNotifierProvider))) {
      return;
    }
    if (_motion == _FocusMotion.idle) {
      _waitingTimer ??= Timer(Duration(seconds: 10 + _random.nextInt(11)), () {
        _waitingTimer = null;
        final gestures = _FocusMotion.gestures;
        _startWaitingGesture(gestures[_random.nextInt(gestures.length)]);
      });
    }
    final clip = _activeClip;
    if (clip == null || _clipProgress.isAnimating) return;
    if (_motion == _FocusMotion.idle) {
      _clipProgress.repeat(period: clip.duration);
    } else {
      _clipProgress.duration = clip.duration;
      _clipProgress.forward();
    }
  }

  void _startWaitingGesture(_FocusMotion gesture) {
    if (_clips == null ||
        _motion != _FocusMotion.idle ||
        !_canPlayWaiting(ref.read(timerNotifierProvider))) {
      return;
    }
    _cancelWaitingTimer();
    _changeMotion(gesture);
    _playWaitingMotion();
  }

  Future<void> _loadFocusClips() async {
    try {
      final clips = await FocusClips.load(rootBundle);
      if (!mounted) {
        clips.dispose();
        return;
      }
      setState(() => _clips = clips);
      if (_motion.isWaiting) {
        _playWaitingMotion();
      } else {
        _playFocusMotion();
      }
    } catch (error) {
      debugPrint('Odak klipleri yüklenemedi: $error');
    }
  }

  void _syncFocusMotion(TimerState? previous, TimerState next) {
    if (next.isLoading) return;
    if (next.mode != TimerMode.focus) {
      _resetFocusMotion();
      return;
    }
    if (next.remainingSeconds == 0 && (next.isRunning || next.isCompleted)) {
      _beginFocusCompletion(restored: previous == null || previous.isLoading);
      return;
    }
    if (_motion.isCompletion) {
      _resetFocusMotion();
    }
    if (_motion.isWaiting) {
      if (!next.isRunning && next.progress == 0) {
        _playWaitingMotion();
        return;
      }
      _cancelWaitingTimer();
      final restored =
          previous == null || previous.isLoading || next.progress > 0;
      final position = _clipProgress.value;
      if (!restored && _motion.isGesture && position > 0 && position < 1) {
        _clipProgress.stop();
        final (settling, reverseBefore) = switch (_motion) {
          // From leaf contact (frame 27 of 57), use the authored lowering tail.
          _FocusMotion.fixingLeaf => (_FocusMotion.loweringLeafHand, 25.5 / 56),
          // Use the closer flat-foot phase (frames 10 and 41 of 65). The
          // supporting shoe stays planted along either authored path.
          _FocusMotion.fidgeting => (_FocusMotion.settlingFidget, 24.5 / 64),
          // At full extension, close the arms along the stretch's return tail.
          _FocusMotion.stretching => (_FocusMotion.settlingStretch, 21.5 / 53),
          // The right foot reaches its highest point at frame 21 of 49.
          _FocusMotion.rebalancing => (
            _FocusMotion.settlingRebalance,
            19.5 / 48,
          ),
          _ => (_FocusMotion.loweringThinkHand, .5),
        };
        _rewindGesture = position < reverseBefore;
        setState(() => _motion = settling);
      } else {
        _changeMotion(
          restored ? _FocusMotion.breathing : _FocusMotion.sittingDown,
        );
      }
    }
    if (next.isRunning) {
      _playFocusMotion();
    } else {
      _clipProgress.stop();
    }
  }

  void _playFocusMotion() {
    if (_motion.isCompletion) {
      _playCompletionMotion();
      return;
    }
    final clip = _activeClip;
    if (!_visible ||
        clip == null ||
        _debugFrozen ||
        _clipProgress.isAnimating ||
        !ref.read(timerNotifierProvider).isRunning) {
      return;
    }
    switch (_motion) {
      case _FocusMotion.idle:
      case _FocusMotion.thinking:
      case _FocusMotion.fixingLeaf:
      case _FocusMotion.fidgeting:
      case _FocusMotion.stretching:
      case _FocusMotion.rebalancing:
        break;
      case _FocusMotion.loweringThinkHand:
      case _FocusMotion.loweringLeafHand:
      case _FocusMotion.settlingFidget:
      case _FocusMotion.settlingStretch:
      case _FocusMotion.settlingRebalance:
        final remaining = _rewindGesture
            ? _clipProgress.value
            : 1 - _clipProgress.value;
        final speed = switch (_motion) {
          _FocusMotion.loweringLeafHand => 2.0,
          _FocusMotion.settlingFidget => 2.5,
          _FocusMotion.settlingStretch => 2.5,
          _FocusMotion.settlingRebalance => 2.5,
          _ => 3.0,
        };
        final duration = Duration(
          microseconds: (clip.duration.inMicroseconds * remaining / speed)
              .round(),
        );
        if (_rewindGesture) {
          _clipProgress.animateBack(0, duration: duration);
        } else {
          _clipProgress.animateTo(1, duration: duration);
        }
      case _FocusMotion.sittingDown:
        _clipProgress.duration = clip.duration;
        _clipProgress.forward();
      case _FocusMotion.breathing:
        _clipProgress.repeat(period: clip.duration);
      case _FocusMotion.bridgingComplete:
      case _FocusMotion.completing:
      case _FocusMotion.completed:
        break;
    }
  }

  void _beginFocusCompletion({required bool restored}) {
    if (_motion.isCompletion) return;
    _cancelWaitingTimer();
    _debugFrozen = false;
    final current = _activeClip;
    if (restored || !_visible || current == null) {
      _holdCompletedPose();
      return;
    }
    _completionBridge = current.transitionTo(
      _clips!.focusComplete,
      _clipProgress.value,
    );
    _changeMotion(_FocusMotion.bridgingComplete);
    _completionGlow.forward(from: 0);
    _playCompletionMotion();
  }

  void _playCompletionMotion() {
    if (_motion == _FocusMotion.completed) {
      _clipProgress.value = 1;
      return;
    }
    if (!_visible) {
      _holdCompletedPose();
      return;
    }
    final clip = _activeClip;
    if (clip == null || _debugFrozen || _clipProgress.isAnimating) return;
    _clipProgress.duration = clip.duration;
    _clipProgress.forward();
  }

  void _holdCompletedPose() {
    _clipProgress.stop();
    setState(() => _motion = _FocusMotion.completed);
    _clipProgress.value = 1;
    _completionGlow.value = 1;
  }

  void _advanceFocusMotion(AnimationStatus status) {
    if (_motion == _FocusMotion.bridgingComplete &&
        status == AnimationStatus.completed) {
      _changeMotion(_FocusMotion.completing);
      _playCompletionMotion();
    } else if (_motion == _FocusMotion.completing &&
        status == AnimationStatus.completed) {
      setState(() => _motion = _FocusMotion.completed);
    } else if (_motion.isGesture && status == AnimationStatus.completed) {
      _changeMotion(_FocusMotion.idle);
      _playWaitingMotion();
    } else if (_motion.isSettling &&
        status ==
            (_rewindGesture
                ? AnimationStatus.dismissed
                : AnimationStatus.completed)) {
      _changeMotion(_FocusMotion.sittingDown);
      _playFocusMotion();
    } else if (_motion == _FocusMotion.sittingDown &&
        status == AnimationStatus.completed) {
      _changeMotion(_FocusMotion.breathing);
      _playFocusMotion();
    }
  }

  void _changeMotion(_FocusMotion motion) {
    setState(() => _motion = motion);
    _clipProgress.reset();
  }

  void _resetFocusMotion() {
    _cancelWaitingTimer();
    _debugFrozen = false;
    _completionGlow.reset();
    _completionBridge = null;
    _changeMotion(_FocusMotion.idle);
    _playWaitingMotion();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cancelWaitingTimer();
    _clipProgress.dispose();
    _completionGlow.dispose();
    _clips?.dispose();
    super.dispose();
  }

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
    final clip = !focus || s.isLoading ? null : _activeClip;
    final focusStarted = !_motion.isWaiting;
    final glasses = _debugGlasses ?? (accessory == 'acc_sunglasses');
    final scarf = _debugScarf ?? (accessory == 'acc_scarf');
    final backdrop = ref.watch(focusBackdropProvider);
    final lightHeading = const {
      'bg_forest',
      'bg_night',
      'bg_ocean',
    }.contains(backdrop?.id);
    if (focus) {
      return _focusScreen(
        s: s,
        label: label,
        pose: pose,
        clip: clip,
        accessory: accessory,
        glasses: glasses,
        scarf: scarf,
        asset:
            backdrop?.assetPath ?? DefaultShopItems.sunnyGreenhouse.assetPath!,
        eyebrow:
            backdrop == null || backdrop == DefaultShopItems.sunnyGreenhouse
            ? 'SABAH SERASI'
            : backdrop.name,
        lightHeading: lightHeading,
        muted: sound == null,
      );
    }
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
                              motion: clip != null
                                  ? (
                                      clip: clip,
                                      progress: _clipProgress,
                                      glasses: glasses,
                                      scarf: scarf,
                                    )
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            s.isCompleted
                                ? (focus
                                      ? 'Oturum tamamlandı'
                                      : 'MOLA TAMAMLANDI')
                                : '${phase.toUpperCase()}   ·   ${s.sessionsCompleted % 4 + 1} / 4',
                            style: const TextStyle(
                              color: sage,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.8,
                            ),
                          ),
                          FocusProgressRing(
                            progress: s.progress,
                            glow: _completionGlow,
                            strokeWidth: 3,
                            foreground: sage,
                            track: sage.withValues(alpha: .18),
                            label: focus
                                ? 'Odak ilerlemesi'
                                : 'Mola ilerlemesi',
                            child: Semantics(
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
                          ),
                          const SizedBox(height: 8),
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
                          else
                            Visibility(
                              // Keep the centered mascot anchored when the
                              // reset button appears at the start of focus.
                              visible: !focus || focusStarted,
                              maintainSize: true,
                              maintainAnimation: true,
                              maintainState: true,
                              child: TextButton(
                                onPressed: () {
                                  if (focus) {
                                    timer.reset();
                                    _resetFocusMotion();
                                  } else {
                                    timer.setMode(TimerMode.focus);
                                  }
                                },
                                child: Text(
                                  focus ? 'Seansı sıfırla' : 'Odağa dön',
                                ),
                              ),
                            ),
                          if (kDebugMode && focus && _clips != null)
                            _clipDebugControls(
                              (s.isRunning ||
                                      _motion.isCompletion &&
                                          _motion != _FocusMotion.completed) &&
                                  clip != null,
                              _motion == _FocusMotion.idle &&
                                  _canPlayWaiting(s),
                              glasses,
                              scarf,
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

  Widget _focusScreen({
    required TimerState s,
    required String label,
    required GardenPose pose,
    required TomatoClip? clip,
    required String? accessory,
    required bool glasses,
    required bool scarf,
    required String asset,
    required String eyebrow,
    required bool lightHeading,
    required bool muted,
  }) {
    final media = MediaQuery.of(context);
    final inherited = FocusCompositionScope.maybeOf(context);
    final timer = ref.read(timerNotifierProvider.notifier);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: LayoutBuilder(
        builder: (context, box) {
          final spec = FocusBackdropSpec.forAsset(asset);
          final layout =
              inherited ??
              FocusComposition.calculate(
                viewport: media.size,
                bodyHeight: box.maxHeight,
                safeTop: media.padding.top,
                backdrop: spec,
                textScale: media.textScaler.scale(1),
              );
          final contentWidth = (box.maxWidth - 40).clamp(0.0, 490.0);
          final inset = (box.maxWidth - contentWidth) / 2;
          return Stack(
            clipBehavior: Clip.none,
            children: [
              if (inherited == null)
                Positioned.fill(
                  child: FocusBackdrop(spec: spec, composition: layout),
                ),
              Positioned(
                left: inset,
                right: inset,
                top: layout.headerTop,
                child: Row(
                  children: [
                    Expanded(
                      child: GardenHeading(
                        eyebrow,
                        'Tomadoro',
                        foreground: lightHeading ? parchment : null,
                        fitTitle: true,
                      ),
                    ),
                    IconButton.filledTonal(
                      tooltip: 'Ortam sesi',
                      onPressed: sounds,
                      icon: Icon(
                        muted
                            ? Icons.volume_off_outlined
                            : Icons.volume_up_outlined,
                      ),
                    ),
                    if (kDebugMode)
                      IconButton(
                        tooltip: 'Klip testi',
                        onPressed: clip == null
                            ? null
                            : () => setState(
                                () => _debugPanelOpen = !_debugPanelOpen,
                              ),
                        icon: Icon(
                          Icons.bug_report_outlined,
                          size: 20,
                          color: lightHeading ? parchment : ink,
                        ),
                      ),
                  ],
                ),
              ),
              Positioned.fromRect(
                rect: layout.ringRect,
                child: FocusProgressRing(
                  key: const ValueKey('focus-ring'),
                  progress: s.progress,
                  glow: _completionGlow,
                  child: CozyScene(
                    pose: pose,
                    accessory: accessory,
                    showBackground: false,
                    grounded: true,
                    motion: clip == null
                        ? null
                        : (
                            clip: clip,
                            progress: _clipProgress,
                            glasses: glasses,
                            scarf: scarf,
                          ),
                  ),
                ),
              ),
              Positioned(
                top: layout.ringRect.bottom + 8,
                left: inset,
                right: inset,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 16,
                      child: s.isCompleted
                          ? null
                          : Text(
                              'ODAK   ·   ${s.sessionsCompleted % 4 + 1} / 4',
                              style: const TextStyle(
                                color: sage,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.5,
                              ),
                            ),
                    ),
                    SizedBox(
                      height: layout.timerHeight,
                      child: Semantics(
                        button: !s.isRunning && s.progress == 0,
                        label: '${s.formattedTime}, Odak',
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: !s.isRunning && s.progress == 0
                              ? editDuration
                              : null,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              s.formattedTime,
                              style: TextStyle(
                                color: ink,
                                height: 1.12,
                                fontSize: layout.timerFont,
                                letterSpacing: -2.5,
                                fontFeatures: const [
                                  FontFeature.tabularFigures(),
                                ],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      height: layout.captionHeight,
                      child: Center(
                        child: Text(
                          s.isCompleted
                              ? 'Oturum tamamlandı'
                              : s.isRunning
                              ? 'Şimdi yalnızca önündeki işe odaklan.'
                              : s.progress > 0
                              ? 'Kaldığın yerden devam edebilirsin.'
                              : 'Süreyi değiştirmek için sayaca dokun.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: ink.withValues(alpha: .8),
                            fontSize: 12.5,
                            fontWeight: s.isCompleted
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(backgroundColor: berry),
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
                    SizedBox(
                      height: 40,
                      child: s.isCompleted
                          ? TextButton(
                              onPressed: () => timer.setMode(TimerMode.focus),
                              child: const Text('Molayı geç'),
                            )
                          : Visibility(
                              visible: !_motion.isWaiting,
                              maintainState: true,
                              maintainAnimation: true,
                              maintainSize: true,
                              child: TextButton(
                                onPressed: () {
                                  timer.reset();
                                  _resetFocusMotion();
                                },
                                child: const Text('Seansı sıfırla'),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              if (kDebugMode && _clips != null)
                Positioned(
                  left: 12,
                  right: 12,
                  bottom: 8,
                  child: Offstage(
                    offstage: !_debugPanelOpen,
                    child: Material(
                      color: parchment,
                      elevation: 5,
                      borderRadius: BorderRadius.circular(18),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: (box.maxHeight * .42).clamp(160.0, 300.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 2, 10, 8),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  const Expanded(
                                    child: Text(
                                      'Klip testi',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    tooltip: 'Klip testini kapat',
                                    onPressed: () =>
                                        setState(() => _debugPanelOpen = false),
                                    icon: const Icon(Icons.close, size: 20),
                                  ),
                                ],
                              ),
                              Flexible(
                                fit: FlexFit.loose,
                                child: SingleChildScrollView(
                                  child: _clipDebugControls(
                                    (s.isRunning ||
                                            _motion.isCompletion &&
                                                _motion !=
                                                    _FocusMotion.completed) &&
                                        clip != null,
                                    _motion == _FocusMotion.idle &&
                                        _canPlayWaiting(s),
                                    glasses,
                                    scarf,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  void _playDebugGesture(_FocusMotion gesture) {
    setState(() => _debugPanelOpen = false);
    _startWaitingGesture(gesture);
  }

  Widget _clipDebugControls(
    bool active,
    bool canPlayGesture,
    bool glasses,
    bool scarf,
  ) => Wrap(
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.center,
    spacing: 6,
    children: [
      TextButton(
        onPressed: ref.watch(timerNotifierProvider).isRunning
            ? null
            : () {
                setState(() => _debugPanelOpen = false);
                ref.read(timerNotifierProvider.notifier).debugStartShortFocus();
              },
        child: const Text('10 saniyelik odak'),
      ),
      TextButton(
        onPressed: canPlayGesture
            ? () => _playDebugGesture(_FocusMotion.thinking)
            : null,
        child: const Text('Düşünmeyi oynat'),
      ),
      TextButton(
        onPressed: canPlayGesture
            ? () => _playDebugGesture(_FocusMotion.fixingLeaf)
            : null,
        child: const Text('Yaprak düzeltmeyi oynat'),
      ),
      TextButton(
        onPressed: canPlayGesture
            ? () => _playDebugGesture(_FocusMotion.fidgeting)
            : null,
        child: const Text('Oyalanmayı oynat'),
      ),
      TextButton(
        onPressed: canPlayGesture
            ? () => _playDebugGesture(_FocusMotion.stretching)
            : null,
        child: const Text('Esnemeyi oynat'),
      ),
      TextButton(
        onPressed: canPlayGesture
            ? () => _playDebugGesture(_FocusMotion.rebalancing)
            : null,
        child: const Text('Denge toplamayı oynat'),
      ),
      TextButton(
        onPressed: !active
            ? null
            : () {
                setState(() => _debugFrozen = !_debugFrozen);
                if (_debugFrozen) {
                  _clipProgress.stop();
                } else {
                  _playFocusMotion();
                }
              },
        child: Text(_debugFrozen ? 'Sürdür' : 'Dondur'),
      ),
      FilterChip(
        label: const Text('Gözlük'),
        selected: glasses,
        onSelected: (value) => setState(() => _debugGlasses = value),
      ),
      FilterChip(
        label: const Text('Atkı'),
        selected: scarf,
        onSelected: (value) => setState(() => _debugScarf = value),
      ),
    ],
  );
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
        seconds: s.totalSeconds,
        focus: s.mode == TimerMode.focus,
      ),
    ),
  );
  final settings = ref.watch(userSettingsProvider);
  final end = settings.notificationsEnabled
      ? anchor.start?.add(Duration(seconds: anchor.seconds))
      : null;
  return (
    end: end,
    bell: settings.soundEnabled,
    vibrate: settings.vibrationEnabled,
    focus: anchor.focus,
  );
});
