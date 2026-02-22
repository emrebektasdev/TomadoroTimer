import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

/// Break choice options after completing a focus session
enum BreakChoice { shortBreak, longBreak, skipBreak }

/// Modal bottom sheet for selecting break type after focus session
class BreakChoiceModal extends StatelessWidget {
  final int shortBreakMinutes;
  final int longBreakMinutes;
  final ValueChanged<BreakChoice> onChoiceSelected;

  const BreakChoiceModal({
    super.key,
    required this.shortBreakMinutes,
    required this.longBreakMinutes,
    required this.onChoiceSelected,
  });

  /// Show the break choice modal
  static Future<BreakChoice?> show(
    BuildContext context, {
    required int shortBreakMinutes,
    required int longBreakMinutes,
  }) {
    return showModalBottomSheet<BreakChoice>(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) => BreakChoiceModal(
        shortBreakMinutes: shortBreakMinutes,
        longBreakMinutes: longBreakMinutes,
        onChoiceSelected: (choice) => Navigator.of(context).pop(choice),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),

          // Title
          const Text(
            '🎉 Great Focus Session!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),

          // Subtitle
          Text(
            'You\'ve earned a break. What would you like to do?',
            style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // Break options
          _BreakOptionButton(
            icon: Icons.coffee_rounded,
            title: 'Short Break',
            subtitle: '$shortBreakMinutes minutes',
            color: AppColors.accentOrange,
            onTap: () => onChoiceSelected(BreakChoice.shortBreak),
          ),
          const SizedBox(height: 12),

          _BreakOptionButton(
            icon: Icons.self_improvement_rounded,
            title: 'Long Break',
            subtitle: '$longBreakMinutes minutes',
            color: AppColors.shopBackgrounds,
            onTap: () => onChoiceSelected(BreakChoice.longBreak),
          ),
          const SizedBox(height: 12),

          _BreakOptionButton(
            icon: Icons.skip_next_rounded,
            title: 'Skip Break',
            subtitle: 'Continue focusing',
            color: AppColors.textSecondary,
            isOutlined: true,
            onTap: () => onChoiceSelected(BreakChoice.skipBreak),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

/// Individual break option button
class _BreakOptionButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final bool isOutlined;
  final VoidCallback onTap;

  const _BreakOptionButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: isOutlined ? Colors.transparent : color.withAlpha(20),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isOutlined ? color.withAlpha(100) : color.withAlpha(50),
              width: isOutlined ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isOutlined ? color.withAlpha(20) : color.withAlpha(30),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isOutlined ? color : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: isOutlined
                            ? color.withAlpha(180)
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: isOutlined ? color.withAlpha(150) : color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
