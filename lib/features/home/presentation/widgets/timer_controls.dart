/// Timer control buttons (Play/Pause, Reset, Skip).
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../timer/application/timer_providers.dart';
import '../../../timer/domain/entities/timer_mode.dart';

class TimerControls extends ConsumerWidget {
  final VoidCallback onCollect;
  final bool isCollectible;

  const TimerControls({
    super.key,
    required this.onCollect,
    required this.isCollectible,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRunning = ref.watch(isTimerRunningProvider);
    final mode = ref.watch(timerModeProvider);
    final notifier = ref.read(timerNotifierProvider.notifier);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Reset Button
          _ControlButton(
            icon: Icons.refresh_rounded,
            onPressed: notifier.reset,
            isSecondary: true,
          ),

          const SizedBox(width: 24),

          // Play/Pause/Collect Button
          _PlayPauseButton(
            isPlaying: isRunning,
            isCollectible: isCollectible,
            onPressed: () {
              if (isCollectible) {
                onCollect();
              } else if (isRunning) {
                notifier.pause();
              } else {
                notifier.start();
              }
            },
          ),

          const SizedBox(width: 24),

          // Skip Button (for breaks or testing)
          _ControlButton(
            icon: Icons.skip_next_rounded,
            // Allow skipping if not focusing, OR if debugging (but let's stick to design logic)
            // Legacy: onPressed: timerProvider.currentMode != TimerMode.focus ? ...
            onPressed: mode != TimerMode.focus ? notifier.skip : null,
            isSecondary: true,
          ),
        ],
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final bool isSecondary;

  const _ControlButton({
    required this.icon,
    this.onPressed,
    this.isSecondary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(onPressed != null ? 220 : 100),
            borderRadius: BorderRadius.circular(16),
            boxShadow: onPressed != null
                ? [
                    BoxShadow(
                      color: Colors.black.withAlpha(10),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Icon(
            icon,
            size: 28,
            color: onPressed != null
                ? AppColors.textSecondary
                : AppColors.textLight,
          ),
        ),
      ),
    );
  }
}

class _PlayPauseButton extends StatelessWidget {
  final bool isPlaying;
  final bool isCollectible;
  final VoidCallback onPressed;

  const _PlayPauseButton({
    required this.isPlaying,
    required this.isCollectible,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(24),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: isCollectible
                ? const LinearGradient(
                    colors: [AppColors.accentGold, AppColors.accentOrange],
                  )
                : const LinearGradient(
                    colors: [AppColors.tomatoRed, AppColors.tomatoRedDark],
                  ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color:
                    (isCollectible ? AppColors.accentGold : AppColors.tomatoRed)
                        .withAlpha(80),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Icon(
            isCollectible
                ? Icons.catching_pokemon
                : (isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded),
            size: 40,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
