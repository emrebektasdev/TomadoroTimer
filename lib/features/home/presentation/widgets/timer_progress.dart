/// Linear progress indicator for the timer.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../timer/application/timer_providers.dart';

class TimerProgress extends ConsumerWidget {
  const TimerProgress({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(timerProgressProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: Colors.white.withAlpha(150),
              valueColor: AlwaysStoppedAnimation<Color>(
                _getProgressColor(progress),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${(progress * 100).toInt()}% complete',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary.withAlpha(180),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _getProgressColor(double progress) {
    if (progress < 0.5) {
      return Color.lerp(
        AppColors.tomatoUnripe,
        AppColors.tomatoHalfRipe,
        progress * 2,
      )!;
    } else {
      return Color.lerp(
        AppColors.tomatoHalfRipe,
        AppColors.tomatoRipe,
        (progress - 0.5) * 2,
      )!;
    }
  }
}
