/// Settings tab for history/profile screen.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../user/application/user_providers.dart';

class HistorySettingsTab extends ConsumerWidget {
  const HistorySettingsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(userSettingsProvider);
    final userNotifier = ref.read(userNotifierProvider.notifier);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timer Settings
          const Text(
            'Timer Settings',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          _SettingsCard(
            children: [
              _SliderSetting(
                title: 'Focus Duration',
                value: settings.focusDurationMinutes.toDouble(),
                min: 5,
                max: 60,
                suffix: 'min',
                onChanged: (value) =>
                    userNotifier.setFocusDuration(value.toInt()),
              ),
              const Divider(),
              _SliderSetting(
                title: 'Short Break',
                value: settings.shortBreakMinutes.toDouble(),
                min: 1,
                max: 15,
                suffix: 'min',
                onChanged: (value) =>
                    userNotifier.setShortBreakDuration(value.toInt()),
              ),
              const Divider(),
              _SliderSetting(
                title: 'Long Break',
                value: settings.longBreakMinutes.toDouble(),
                min: 5,
                max: 30,
                suffix: 'min',
                onChanged: (value) =>
                    userNotifier.setLongBreakDuration(value.toInt()),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Goals Settings
          const Text(
            'Goals',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          _SettingsCard(
            children: [
              _SliderSetting(
                title: 'Daily Goal',
                value: settings.dailyGoalMinutes.toDouble(),
                min: 30,
                max: 480,
                suffix: 'min',
                onChanged: (value) => userNotifier.setDailyGoal(value.toInt()),
              ),
              const Divider(),
              _SliderSetting(
                title: 'Weekly Goal',
                value: settings.weeklyGoalMinutes.toDouble(),
                min: 120,
                max: 2400,
                suffix: 'min',
                onChanged: (value) => userNotifier.setWeeklyGoal(value.toInt()),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Notification Settings
          const Text(
            'Notifications',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          _SettingsCard(
            children: [
              _SwitchSetting(
                title: 'Notifications',
                subtitle: 'Get reminded when timer ends',
                value: settings.notificationsEnabled,
                onChanged: (val) => userNotifier.setNotificationsEnabled(val),
              ),
              const Divider(),
              _SwitchSetting(
                title: 'Sound',
                subtitle: 'Play sound when timer ends',
                value: settings.soundEnabled,
                onChanged: (val) => userNotifier.setSoundEnabled(val),
              ),
              const Divider(),
              _SwitchSetting(
                title: 'Vibration',
                subtitle: 'Vibrate when timer ends',
                value: settings.vibrationEnabled,
                onChanged: (val) => userNotifier.setVibrationEnabled(val),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // About section
          const Text(
            'About',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          _SettingsCard(
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.tomatoRed.withAlpha(20),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text('🍅', style: TextStyle(fontSize: 22)),
                  ),
                ),
                title: const Text(
                  'Tomadoro',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                subtitle: const Text(
                  'Version 1.0.0',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;

  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _SliderSetting extends StatelessWidget {
  final String title;
  final double value;
  final double min;
  final double max;
  final String suffix;
  final ValueChanged<double> onChanged;

  const _SliderSetting({
    required this.title,
    required this.value,
    required this.min,
    required this.max,
    required this.suffix,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              '${value.toInt()} $suffix',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.tomatoRed,
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: AppColors.tomatoRed,
            inactiveTrackColor: AppColors.tomatoRed.withAlpha(50),
            thumbColor: AppColors.tomatoRed,
            overlayColor: AppColors.tomatoRed.withAlpha(30),
            trackHeight: 4,
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: (max - min).toInt(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

class _SwitchSetting extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchSetting({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
      ),
      activeColor: AppColors.tomatoRed,
      value: value,
      onChanged: onChanged,
    );
  }
}
