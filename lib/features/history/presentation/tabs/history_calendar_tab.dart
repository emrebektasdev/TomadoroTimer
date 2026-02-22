/// Calendar tab for history screen.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../core/theme/app_colors.dart';
import '../../application/history_providers.dart';

class HistoryCalendarTab extends ConsumerStatefulWidget {
  const HistoryCalendarTab({super.key});

  @override
  ConsumerState<HistoryCalendarTab> createState() => _HistoryCalendarTabState();
}

class _HistoryCalendarTabState extends ConsumerState<HistoryCalendarTab> {
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(selectedDateProvider);
    final datesWithActivity = ref.watch(datesWithActivityProvider);
    // We need to parse datesWithActivity (Set<String>) back to DateTime for the calendar
    // Format is YYYY-MM-DD
    final activeDates = datesWithActivity.map((dateStr) {
      final parts = dateStr.split('-');
      return DateTime(
        int.parse(parts[0]),
        int.parse(parts[1]),
        int.parse(parts[2]),
      );
    }).toSet();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Calendar
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(10),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: selectedDate,
              selectedDayPredicate: (day) => isSameDay(selectedDate, day),
              calendarFormat: _calendarFormat,
              eventLoader: (day) {
                // Check if day matches any active date (ignoring time)
                final isActivity = activeDates.any((d) => isSameDay(d, day));
                return isActivity ? [true] : [];
              },
              onDaySelected: (selected, focused) {
                if (!isSameDay(selectedDate, selected)) {
                  ref
                      .read(historyNotifierProvider.notifier)
                      .selectDate(selected);
                }
              },
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: AppColors.tomatoRed.withAlpha(100),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: const BoxDecoration(
                  color: AppColors.tomatoRed,
                  shape: BoxShape.circle,
                ),
                markerDecoration: const BoxDecoration(
                  color: AppColors.leafGreen,
                  shape: BoxShape.circle,
                ),
                markersMaxCount: 1,
                markerSize: 6,
                markerMargin: const EdgeInsets.symmetric(horizontal: 1),
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                leftChevronIcon: Icon(
                  Icons.chevron_left_rounded,
                  color: AppColors.tomatoRed,
                ),
                rightChevronIcon: Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.tomatoRed,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Selected day stats
          _buildDayStats(context, ref, selectedDate),
        ],
      ),
    );
  }

  Widget _buildDayStats(BuildContext context, WidgetRef ref, DateTime date) {
    final stats = ref.watch(selectedDayStatsProvider);
    final isToday = isSameDay(date, DateTime.now());

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isToday ? 'Today' : DateFormat('EEEE, MMMM d').format(date),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _StatTile(
                icon: Icons.timer_outlined,
                value: '${stats.totalMinutes}',
                label: 'minutes',
                color: AppColors.tomatoRed,
              ),
              const SizedBox(width: 12),
              _StatTile(
                icon: Icons.check_circle_outline,
                value: '${stats.sessionsCompleted}',
                label: 'sessions',
                color: AppColors.leafGreen,
              ),
              const SizedBox(width: 12),
              _StatTile(
                icon: Icons.emoji_events_outlined,
                value: '${stats.tomatoesEarned}',
                label: 'tomatoes',
                color: AppColors.accentOrange,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatTile({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withAlpha(15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
