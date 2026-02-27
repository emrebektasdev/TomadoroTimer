/// Settings tab for history/profile screen.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../user/application/user_providers.dart';
import '../../../user/domain/entities/timer_profile.dart';

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Focus Profile',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton.icon(
                onPressed: () => _showAddProfileDialog(context, ref),
                icon: const Icon(
                  Icons.add,
                  size: 18,
                  color: AppColors.tomatoRed,
                ),
                label: const Text(
                  'Yeni',
                  style: TextStyle(
                    color: AppColors.tomatoRed,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _SettingsCard(
            children: [
              // Profile Selector Dropdown
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.backgroundCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.surface),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: settings.activeProfileId,
                    isExpanded: true,
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.textSecondary,
                    ),
                    dropdownColor: AppColors.backgroundCard,
                    items: settings.profiles.map((TimerProfile profile) {
                      return DropdownMenuItem<String>(
                        value: profile.id,
                        child: Text(
                          '${profile.name} (${profile.focusDurationMinutes}/${profile.shortBreakMinutes}/${profile.longBreakMinutes})',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newId) {
                      if (newId != null) {
                        userNotifier.setActiveTimerProfile(newId);
                      }
                    },
                  ),
                ),
              ),

              // Only show delete button if it's not the default pomodoro
              if (settings.activeProfileId != 'default_pomodoro') ...[
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () {
                      _showDeleteConfirmation(
                        context,
                        ref,
                        settings.activeProfile,
                      );
                    },
                    icon: const Icon(
                      Icons.delete_outline,
                      size: 16,
                      color: Colors.grey,
                    ),
                    label: const Text(
                      'Sil',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),

              _SliderSetting(
                title: 'Focus Duration',
                value: settings.activeProfile.focusDurationMinutes.toDouble(),
                min: 5,
                max: 60,
                suffix: 'min',
                onChanged: (value) => userNotifier.updateTimerProfile(
                  settings.activeProfile.copyWith(
                    focusDurationMinutes: value.toInt(),
                  ),
                ),
              ),
              const Divider(),
              _SliderSetting(
                title: 'Short Break',
                value: settings.activeProfile.shortBreakMinutes.toDouble(),
                min: 1,
                max: 15,
                suffix: 'min',
                onChanged: (value) => userNotifier.updateTimerProfile(
                  settings.activeProfile.copyWith(
                    shortBreakMinutes: value.toInt(),
                  ),
                ),
              ),
              const Divider(),
              _SliderSetting(
                title: 'Long Break',
                value: settings.activeProfile.longBreakMinutes.toDouble(),
                min: 5,
                max: 30,
                suffix: 'min',
                onChanged: (value) => userNotifier.updateTimerProfile(
                  settings.activeProfile.copyWith(
                    longBreakMinutes: value.toInt(),
                  ),
                ),
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
              _GoalCalculatorSetting(
                title: 'Daily Goal',
                initialMinutes: settings.dailyGoalMinutes,
                profiles: settings.profiles,
                activeProfileId: settings.activeProfileId,
                maxRepetitions: 20,
                onChanged: (value) => userNotifier.setDailyGoal(value),
              ),
              const Divider(height: 32),
              _GoalCalculatorSetting(
                title: 'Weekly Goal',
                initialMinutes: settings.weeklyGoalMinutes,
                profiles: settings.profiles,
                activeProfileId: settings.activeProfileId,
                maxRepetitions: 100,
                onChanged: (value) => userNotifier.setWeeklyGoal(value),
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

  void _showAddProfileDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Yeni Profil',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              hintText: 'Profil Adı (Örn: Hardcore)',
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.tomatoRed),
              ),
            ),
            autofocus: true,
            textCapitalization: TextCapitalization.words,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('İptal', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                if (name.isNotEmpty) {
                  final newProfile = TimerProfile(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: name,
                    focusDurationMinutes: 50,
                    shortBreakMinutes: 10,
                    longBreakMinutes: 30,
                  );
                  ref
                      .read(userNotifierProvider.notifier)
                      .addTimerProfile(newProfile, makeActive: true);
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.tomatoRed,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Oluştur'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    WidgetRef ref,
    TimerProfile profile,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Profili Sil',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          content: Text(
            '"${profile.name}" profilini silmek istediğinize emin misiniz?',
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('İptal', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                ref
                    .read(userNotifierProvider.notifier)
                    .deleteTimerProfile(profile.id);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Sil'),
            ),
          ],
        );
      },
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
      activeThumbColor: AppColors.tomatoRed,
      value: value,
      onChanged: onChanged,
    );
  }
}

class _GoalCalculatorSetting extends StatefulWidget {
  final String title;
  final int initialMinutes;
  final List<TimerProfile> profiles;
  final String activeProfileId;
  final int maxRepetitions;
  final ValueChanged<int> onChanged;

  const _GoalCalculatorSetting({
    required this.title,
    required this.initialMinutes,
    required this.profiles,
    required this.activeProfileId,
    required this.maxRepetitions,
    required this.onChanged,
  });

  @override
  State<_GoalCalculatorSetting> createState() => _GoalCalculatorSettingState();
}

class _GoalCalculatorSettingState extends State<_GoalCalculatorSetting> {
  late TimerProfile _selectedProfile;
  late int _repetitions;

  @override
  void initState() {
    super.initState();
    _initializeValues();
  }

  void _initializeValues() {
    TimerProfile? matchedProfile;
    int? matchedRepetitions;

    // Try to find a profile that Perfectly matches the stored minutes
    for (final profile in widget.profiles) {
      if (profile.focusDurationMinutes > 0 &&
          widget.initialMinutes % profile.focusDurationMinutes == 0) {
        matchedProfile = profile;
        matchedRepetitions =
            widget.initialMinutes ~/ profile.focusDurationMinutes;
        break;
      }
    }

    if (matchedProfile != null &&
        matchedRepetitions != null &&
        matchedRepetitions <= widget.maxRepetitions) {
      _selectedProfile = matchedProfile;
      _repetitions = matchedRepetitions;
      if (_repetitions == 0) _repetitions = 1;
    } else {
      // Default fallback
      _selectedProfile = widget.profiles.firstWhere(
        (p) => p.id == widget.activeProfileId,
        orElse: () => widget.profiles.first,
      );
      _repetitions =
          (widget.initialMinutes /
                  (_selectedProfile.focusDurationMinutes > 0
                      ? _selectedProfile.focusDurationMinutes
                      : 1))
              .ceil();
      if (_repetitions <= 0) _repetitions = 1;
      if (_repetitions > widget.maxRepetitions)
        _repetitions = widget.maxRepetitions;
    }
  }

  @override
  void didUpdateWidget(_GoalCalculatorSetting oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Refresh calculations if external settings override them natively or profiles change
    if (oldWidget.initialMinutes != widget.initialMinutes ||
        oldWidget.profiles != widget.profiles) {
      final supposedMinutes =
          _selectedProfile.focusDurationMinutes * _repetitions;
      if (supposedMinutes != widget.initialMinutes) {
        _initializeValues();
      }
    }
  }

  void _updateCalculation() {
    final totalMinutes = _selectedProfile.focusDurationMinutes * _repetitions;
    widget.onChanged(totalMinutes);
  }

  String _formatDuration(int minutes) {
    if (minutes < 60) {
      return '$minutes dk';
    }
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    if (mins == 0) return '$hours saat';
    return '$hours saat $mins dk';
  }

  @override
  Widget build(BuildContext context) {
    // Determine bounds and ensure _selectedProfile is always valid regarding current widget.profiles
    if (!widget.profiles.contains(_selectedProfile)) {
      _selectedProfile = widget.profiles.firstWhere(
        (p) => p.id == widget.activeProfileId,
        orElse: () => widget.profiles.first,
      );
    }

    final totalMinutes = _selectedProfile.focusDurationMinutes * _repetitions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              _formatDuration(totalMinutes),
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.tomatoRed,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Dropdown for selecting Focus Profile
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<TimerProfile>(
              value: _selectedProfile,
              isExpanded: true,
              dropdownColor: AppColors.backgroundCard,
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.textSecondary,
              ),
              items: widget.profiles.map((profile) {
                return DropdownMenuItem<TimerProfile>(
                  value: profile,
                  child: Text(
                    '${profile.name} (${profile.focusDurationMinutes} dk)',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (TimerProfile? newProfile) {
                if (newProfile != null) {
                  setState(() {
                    _selectedProfile = newProfile;
                    _updateCalculation();
                  });
                }
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Slider for configuring repetitions
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Tekrar Sayısı:',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.tomatoRed.withAlpha(20),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '$_repetitions x',
                style: const TextStyle(
                  color: AppColors.tomatoRed,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
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
            value: _repetitions.toDouble(),
            min: 1,
            max: widget.maxRepetitions.toDouble(),
            divisions: widget.maxRepetitions - 1,
            onChanged: (val) {
              setState(() {
                _repetitions = val.toInt();
                _updateCalculation();
              });
            },
          ),
        ),
        // Calculation Footnote
        Center(
          child: Text(
            '${_selectedProfile.name} x $_repetitions = $totalMinutes dk (${_formatDuration(totalMinutes)})',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
