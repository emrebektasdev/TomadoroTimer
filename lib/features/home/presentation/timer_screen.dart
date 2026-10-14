/// Main timer screen using Riverpod.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/tomato_state.dart' as legacy_tomato;
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../widgets/break_choice_modal.dart';
import '../../../../widgets/tomato/tomato_character.dart';
import '../../history/application/history_providers.dart';
import '../../timer/application/timer_providers.dart';
import '../../timer/domain/entities/timer_mode.dart';
import '../../user/application/user_providers.dart';
import 'widgets/mode_selector.dart';
import 'widgets/timer_controls.dart';
import 'widgets/timer_display.dart';
import '../../../../core/services/sound_service.dart';
import '../../../../core/di/core_providers.dart';
import 'widgets/timer_progress.dart';

class TimerScreen extends ConsumerStatefulWidget {
  const TimerScreen({super.key});

  @override
  ConsumerState<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends ConsumerState<TimerScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _playPulseAnimation();
  }

  void _playPulseAnimation() {
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  // Logic for collecting tomato
  void _collectTomato() {
    // 1. Logic to calculate reward (mock logic for now, or use UserNotifier)
    const earned = 1; // Simplified for MVP refactor: 1 session = 1 tomato

    final timerState = ref.read(timerNotifierProvider);
    final durationMinutes = timerState.initialDuration;

    // Record session
    // NOTE: In production, we should use timerState.startTime to calculate actual duration if interrupted,
    // but for now we trust initialDuration as the "focused" time.

    // We call HistoryNotifier to record the session
    // We use recordSession() which takes fields directly, NOT a FocusSession object (based on my previous read of history_notifier.dart line 82)
    // Wait, history_notifier.dart line 82: recordSession({required DateTime startTime...})
    // It does NOT take a FocusSession object. It creates one internally.

    final now = DateTime.now();
    final startTime =
        timerState.startTime ??
        now.subtract(Duration(minutes: durationMinutes));

    ref
        .read(historyNotifierProvider.notifier)
        .recordSession(
          startTime: startTime,
          endTime: now,
          durationMinutes: durationMinutes,
          tomatoesEarned: earned,
        );

    // Update User Stats
    ref.read(userNotifierProvider.notifier).addTomatoes(earned);
    final activeProfileId = ref.read(userSettingsProvider).activeProfile.id;
    // ignore: avoid_print
    print(
      '[DEBUG_SESSION] _collectTomato: profileId=$activeProfileId, minutes=$durationMinutes',
    );
    ref
        .read(userNotifierProvider.notifier)
        .recordFocusSession(durationMinutes, profileId: activeProfileId);

    // Show animation
    _showCollectAnimation(earned);

    // Call Next Mode (usually Break)
    ref.read(timerNotifierProvider.notifier).nextMode();
  }

  void _showCollectAnimation(int earned) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🍅', style: TextStyle(fontSize: 24)),
            const SizedBox(width: 8),
            Text(
              '+$earned ${earned == 1 ? 'Tomato' : 'Tomatoes'}!',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        backgroundColor: AppColors.tomatoRed,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _handleTimerCompletion() async {
    // Show Break Choice Modal
    // We need to know current user settings for break durations
    final settings = ref.read(userSettingsProvider);

    final choice = await BreakChoiceModal.show(
      context,
      shortBreakMinutes: settings.activeProfile.shortBreakMinutes,
      longBreakMinutes: settings.activeProfile.longBreakMinutes,
    );

    if (choice == null) return;

    final notifier = ref.read(timerNotifierProvider.notifier);

    switch (choice) {
      case BreakChoice.shortBreak:
        notifier.setMode(TimerMode.shortBreak);
        break;
      case BreakChoice.longBreak:
        notifier.setMode(TimerMode.longBreak);
        break;
      case BreakChoice.skipBreak:
        // Force focus
        notifier.setMode(TimerMode.focus);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen for completion
    ref.listen(isTimerCompletedProvider, (prev, isCompleted) {
      if (isCompleted) {
        // If it was a Focus session, show break choice
        final mode = ref.read(timerModeProvider);
        if (mode == TimerMode.focus) {
          _handleTimerCompletion();
        } else {
          // Break over, automatically go to focus or notify?
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Break is over! Time to focus.')),
          );
          ref.read(timerNotifierProvider.notifier).nextMode(); // Reset to Focus
        }
      }
    });

    // Listen for timer functionality (Ambient Sound)
    ref.listen(isTimerRunningProvider, (prev, isRunning) {
      final soundService = ref.read(soundServiceProvider) as SoundService;
      final equippedSound = ref.read(equippedSoundProvider);

      if (isRunning && equippedSound != null) {
        soundService.play(equippedSound);
      } else {
        soundService.stop();
      }
    });

    // Also listen for equipped sound changes while running
    ref.listen(equippedSoundProvider, (prev, next) {
      final isRunning = ref.read(isTimerRunningProvider);
      if (isRunning) {
        final soundService = ref.read(soundServiceProvider) as SoundService;
        if (next != null) {
          soundService.play(next);
        } else {
          soundService.stop();
        }
      }
    });

    final backgroundId = ref.watch(equippedBackgroundProvider);
    final accessoryId = ref.watch(equippedAccessoryProvider);

    final isRunning = ref.watch(isTimerRunningProvider);
    final progress = ref.watch(timerProgressProvider);
    final mode = ref.watch(timerModeProvider);

    // Determine Tomato State (Legacy enum) based on progress
    legacy_tomato.TomatoState tomatoState;
    if (progress < 0.5) {
      tomatoState = legacy_tomato.TomatoState.unripe;
    } else if (progress < 1.0) {
      tomatoState = legacy_tomato.TomatoState.halfRipe;
    } else {
      tomatoState = legacy_tomato.TomatoState.ripe;
    }

    final isCollectible = (progress >= 1.0 && mode == TimerMode.focus);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppGradients.forId(backgroundId)),
        child: SafeArea(
          child: Column(
            children: [
              _buildTopBar(context, ref),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const ModeSelector(),
                    const SizedBox(height: 20),

                    // Tomato Character - RESPONSIVE SIZE (45-50% of screen width)
                    Builder(
                      builder: (context) {
                        final screenWidth = MediaQuery.of(context).size.width;
                        // Target 48% of screen width, clamped for safety
                        final tomatoSize = (screenWidth * 0.48).clamp(
                          200.0,
                          320.0,
                        );

                        return GestureDetector(
                          onTap: isCollectible ? _collectTomato : null,
                          child: AnimatedBuilder(
                            animation: _pulseAnimation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: isRunning ? _pulseAnimation.value : 1.0,
                                child: TomatoCharacter(
                                  state: tomatoState,
                                  progress: progress,
                                  accessory: accessoryId?.replaceFirst(
                                    'acc_',
                                    '',
                                  ),
                                  isCollectible: isCollectible,
                                  size: tomatoSize,
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 8),
                    if (isCollectible)
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 500),
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: const Text(
                              'Tap to collect! 🍅',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppColors.tomatoRed,
                              ),
                            ),
                          );
                        },
                      ),

                    const SizedBox(height: 24),
                    const TimerDisplay(),
                    const SizedBox(height: 8),
                    const TimerProgress(),
                  ],
                ),
              ),
              TimerControls(
                onCollect: _collectTomato,
                isCollectible: isCollectible,
              ),

              // ============ DEBUG BUTONLARI ============
              // Bu butonlar SADECE test amaçlıdır
              // Production'da kDebugMode kontrolü ile gizlenebilir
              if (kDebugMode) _buildDebugButtons(ref),

              const SizedBox(height: 100), // Space for nav bar
            ],
          ),
        ),
      ),
    );
  }

  // ============ DEBUG WIDGET ============
  // Test amaçlı - kolayca kaldırılabilir
  int _debugClickCount = 0; // Zamanlayıcı butonu için tıklama sayacı

  Widget _buildDebugButtons(WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // BUTON 1: Zamanlayıcı Kontrolü
          Opacity(
            opacity: 0.4, // Yarı saydam - dikkat çekmesin
            child: IconButton(
              icon: const Icon(Icons.fast_forward, size: 20),
              onPressed: () {
                final notifier = ref.read(timerNotifierProvider.notifier);
                final state = ref.read(timerNotifierProvider);

                _debugClickCount++;

                if (_debugClickCount == 1) {
                  // İlk tık: %50'ye düşür
                  final halfTime = (state.initialDuration * 60) ~/ 2;
                  notifier.debugSetRemainingSeconds(halfTime);
                  debugPrint(
                    '[DEBUG] Zamanlayıcı %50\'ye düşürüldü: $halfTime saniye',
                  );
                } else {
                  // İkinci tık: Bitir
                  notifier.debugSetRemainingSeconds(0);
                  _debugClickCount = 0; // Sıfırla
                  debugPrint('[DEBUG] Zamanlayıcı bitirildi');
                }
              },
              tooltip: 'Debug: Hızlı İleri',
              color: Colors.grey,
            ),
          ),

          const SizedBox(width: 8),

          // BUTON 2: Domates Ekleme
          Opacity(
            opacity: 0.4,
            child: IconButton(
              icon: const Icon(Icons.add_circle_outline, size: 20),
              onPressed: () {
                ref.read(userNotifierProvider.notifier).addTomatoes(100);
                debugPrint('[DEBUG] +100 domates eklendi');

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('+100 🍅'),
                    duration: Duration(milliseconds: 500),
                  ),
                );
              },
              tooltip: 'Debug: +100 Domates',
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, WidgetRef ref) {
    final balance = ref.watch(tomatoBalanceProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Tomadoro',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          _TomatoCounter(count: balance),
        ],
      ),
    );
  }
}

/// Helper for top bar counter
class _TomatoCounter extends StatelessWidget {
  final int count;
  const _TomatoCounter({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🍅', style: TextStyle(fontSize: 18)),
          const SizedBox(width: 6),
          Text(
            '$count',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
