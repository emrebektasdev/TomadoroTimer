/// Widget to display current timer mode (Focus/Break).
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../timer/application/timer_providers.dart';
import '../../../timer/domain/entities/timer_mode.dart';

class ModeSelector extends ConsumerWidget {
  const ModeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(timerModeProvider);
    final sessionsCompleted = ref.watch(
      timerNotifierProvider.select((s) => s.sessionsCompleted),
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(200),
        borderRadius: BorderRadius.circular(16),
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
          Icon(
            mode == TimerMode.focus
                ? Icons.center_focus_strong_rounded
                : (mode == TimerMode.shortBreak
                      ? Icons.coffee_rounded
                      : Icons.self_improvement_rounded),
            size: 20,
            color: _getModeColor(mode),
          ),
          const SizedBox(width: 8),
          Text(
            mode.displayName,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: _getModeColor(mode),
            ),
          ),
          // Show session count during focus
          if (mode == TimerMode.focus) ...[
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.tomatoRed.withAlpha(20),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Session ${sessionsCompleted + 1}',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppColors.tomatoRed,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getModeColor(TimerMode mode) {
    switch (mode) {
      case TimerMode.focus:
        return AppColors.tomatoRed;
      case TimerMode.shortBreak:
        return AppColors.accentOrange;
      case TimerMode.longBreak:
        return AppColors.shopBackgrounds;
    }
  }
}
