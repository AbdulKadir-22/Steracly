import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../data/models/session_model.dart';
import '../session/session_notifier.dart';

// A simple class to hold our calculated stats
class HeatmapStats {
  final Map<DateTime, int> dataset; // For the calendar widget
  final int currentStreak;
  final int totalMinutesToday;

  HeatmapStats({
    required this.dataset,
    required this.currentStreak,
    required this.totalMinutesToday,
  });
}

final heatmapProvider = Provider<HeatmapStats>((ref) {
  final sessions = ref.watch(sessionProvider);

  final Map<DateTime, int> dataset = {};

  for (var session in sessions) {
    final date = DateTime(
      session.startTime.year,
      session.startTime.month,
      session.startTime.day,
    );

    final minutes = session.durationSeconds ~/ 60;
    if (minutes > 0) {
      dataset[date] = (dataset[date] ?? 0) + minutes;
    }
  }

  final today = DateTime.now();
  final todayKey = DateTime(today.year, today.month, today.day);

  final uniqueDates = dataset.keys.toList()
    ..sort((a, b) => b.compareTo(a));

  int streak = 0;
  for (int i = 0; i < uniqueDates.length; i++) {
    final expected = todayKey.subtract(Duration(days: i));
    if (uniqueDates[i].isAtSameMomentAs(expected)) {
      streak++;
    } else {
      break;
    }
  }

  return HeatmapStats(
    dataset: dataset,
    currentStreak: streak,
    totalMinutesToday: dataset[todayKey] ?? 0,
  );
});