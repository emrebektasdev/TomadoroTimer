import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../widgets/tomato/cozy_scene.dart';
import '../application/history_providers.dart';
import 'history_screen.dart';

class HarvestScreen extends ConsumerWidget {
  const HarvestScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(historyNotifierProvider);
    final now = DateTime.now();
    final sessions = state.selectedDaySessions;
    final minutes = sessions.fold(0, (sum, s) => sum + s.durationMinutes);
    const dayNames = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];
    final today = DateUtils.isSameDay(now, state.selectedDate);
    return Scaffold(
      backgroundColor: parchment,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.all(22),
          children: [
            const GardenHeading('ODAK GÜNLÜĞÜ', 'Hasat sepeti'),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: const Color(0xffe7ecd9),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          today
                              ? 'Bugünkü hasat'
                              : '${state.selectedDate.day}.${state.selectedDate.month} hasadı',
                          style: const TextStyle(
                            color: sage,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '$minutes dk',
                          style: const TextStyle(
                            fontFamily: 'serif',
                            fontSize: 44,
                            color: ink,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('${sessions.length} tamamlanan seans'),
                      ],
                    ),
                  ),
                  Image.asset('assets/images/harvest.png', width: 86),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Son yedi gün',
              style: TextStyle(
                fontSize: 19,
                color: ink,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: List.generate(7, (i) {
                final day = DateTime(now.year, now.month, now.day - 6 + i);
                final selected = DateUtils.isSameDay(state.selectedDate, day);
                return Expanded(
                  child: Semantics(
                    selected: selected,
                    button: true,
                    child: InkWell(
                      onTap: () => ref
                          .read(historyNotifierProvider.notifier)
                          .selectDate(day),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        decoration: BoxDecoration(
                          color: selected ? berry : null,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            Text(
                              dayNames[day.weekday - 1],
                              style: TextStyle(
                                fontSize: 11,
                                color: selected ? Colors.white : ink,
                              ),
                            ),
                            Text(
                              '${day.day}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: selected ? Colors.white : ink,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            const Divider(height: 32),
            if (sessions.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'Bu günün sepeti boş. Tamamladığın odak seansları burada birikecek.',
                ),
              ),
            for (final session in sessions)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.eco, color: sage),
                title: Text('${session.durationMinutes} dakika odak'),
                subtitle: Text(
                  TimeOfDay.fromDateTime(session.endTime).format(context),
                ),
                trailing: const Text('+1 🍅'),
              ),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HistoryScreen()),
              ),
              child: const Text('Takvim, istatistik ve ayarlar'),
            ),
          ],
        ),
      ),
    );
  }
}
