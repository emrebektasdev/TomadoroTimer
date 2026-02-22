/// Statistics tab containing charts and goal progress.
library;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../user/application/user_providers.dart';
import '../../application/history_providers.dart';

class HistoryStatsTab extends ConsumerWidget {
  const HistoryStatsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Overview cards
          _buildOverviewSection(ref),

          const SizedBox(height: 24),

          // Weekly chart
          _buildWeeklyChart(ref),

          const SizedBox(height: 24),

          // Goals progress
          _buildGoalsSection(ref),
        ],
      ),
    );
  }

  Widget _buildOverviewSection(WidgetRef ref) {
    final formattedTotalTime = ref.watch(formattedTotalFocusTimeProvider);
    // We need totalTomatoesEarned from UserNotifier (via UserState)
    final totalTomatoes = ref.watch(
      userNotifierProvider.select((s) => s.profile.totalTomatoesEarned),
    );
    final longestStreak = ref.watch(
      userNotifierProvider.select((s) => s.profile.longestStreak),
    );

    // We need monthly minutes. HistoryNotifier has getMonthlyMinutes but it is a Future.
    // For now, let's use the simplified approach or skip it.
    // The legacy code showed "This Month".
    // I will read daily stats from history/weekly stats which is already loaded.
    // Actually, let's stick to what's easily available in providers or add a provider for monthly.
    // For MVP refactor, I might skip "This Month" or use a placeholder if not ready.
    // Ideally we should have a 'monthlyStatsProvider'.
    // Let's omit "This Month" for now or use a placeholder "0h" to avoid async complexity in build.

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Overview',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _OverviewCard(
                icon: Icons.timer_rounded,
                value: formattedTotalTime,
                label: 'Total Focus',
                color: AppColors.tomatoRed,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _OverviewCard(
                icon: Icons.emoji_events_rounded,
                value: '$totalTomatoes',
                label: 'Total Tomatoes',
                color: AppColors.accentOrange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _OverviewCard(
                icon: Icons.local_fire_department_rounded,
                value: '$longestStreak',
                label: 'Best Streak',
                color: AppColors.error,
              ),
            ),
            // Placeholder for monthly stats or reuse space
            // const SizedBox(width: 12),
            // Expanded(child: SizedBox()),
          ],
        ),
      ],
    );
  }

  Widget _buildWeeklyChart(WidgetRef ref) {
    final weeklyStats = ref.watch(currentWeekStatsProvider);
    final dailyMinutes = weeklyStats.dailyMinutes;

    final maxMinutes = dailyMinutes.reduce((a, b) => a > b ? a : b);
    final double chartMax = maxMinutes > 0
        ? (maxMinutes * 1.2).ceil().toDouble()
        : 60.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'This Week',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 180,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: chartMax,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => AppColors.tomatoRed,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${rod.toY.toInt()} min',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                        final index = value.toInt();
                        if (index < 0 || index >= days.length) {
                          return const SizedBox();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            days[index],
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(7, (index) {
                  final minutes = dailyMinutes[index].toDouble();
                  final now = DateTime.now();
                  final isToday = index == (now.weekday - 1);

                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: minutes,
                        color: isToday
                            ? AppColors.tomatoRed
                            : AppColors.tomatoRedLight.withAlpha(150),
                        width: 24,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(8),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalsSection(WidgetRef ref) {
    // Current progress matches
    final todayStats = ref.watch(todayStatsProvider);
    final weeklyStats = ref.watch(currentWeekStatsProvider);

    final dailyGoal = ref.watch(
      userSettingsProvider.select((s) => s.dailyGoalMinutes),
    );
    final weeklyGoal = ref.watch(
      userSettingsProvider.select((s) => s.weeklyGoalMinutes),
    );

    final todayMinutes = todayStats.totalMinutes;
    final weeklyMinutes = weeklyStats.totalMinutes;

    final dailyProgress = dailyGoal > 0
        ? (todayMinutes / dailyGoal).clamp(0.0, 1.0)
        : 0.0;
    final weeklyProgress = weeklyGoal > 0
        ? (weeklyMinutes / weeklyGoal).clamp(0.0, 1.0)
        : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Goals',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        _GoalCard(
          title: 'Daily Goal',
          current: todayMinutes,
          goal: dailyGoal,
          progress: dailyProgress,
          color: AppColors.tomatoRed,
        ),
        const SizedBox(height: 12),
        _GoalCard(
          title: 'Weekly Goal',
          current: weeklyMinutes,
          goal: weeklyGoal,
          progress: weeklyProgress,
          color: AppColors.leafGreen,
        ),
      ],
    );
  }
}

class _OverviewCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _OverviewCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

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
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withAlpha(20),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  final String title;
  final int current;
  final int goal;
  final double progress;
  final Color color;

  const _GoalCard({
    required this.title,
    required this.current,
    required this.goal,
    required this.progress,
    required this.color,
  });

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '$current / $goal min',
                style: TextStyle(fontWeight: FontWeight.w600, color: color),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: color.withAlpha(30),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}
