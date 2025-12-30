import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../logic/session/session_notifier.dart';
import '../../../logic/project/project_notifier.dart'; // Import Project Provider

class HeatmapScreen extends ConsumerStatefulWidget {
  const HeatmapScreen({super.key});

  @override
  ConsumerState<HeatmapScreen> createState() => _HeatmapScreenState();
}

class _HeatmapScreenState extends ConsumerState<HeatmapScreen> {
  DateTime _selectedDate = DateTime.now();
  String? _selectedProjectId; // Null means "All Projects"

  @override
  Widget build(BuildContext context) {
    // 1. Watch Data
    final projects = ref.watch(projectProvider);
    final allSessions = ref.watch(sessionProvider);

    // 2. Filter Sessions based on Dropdown
    final filteredSessions = _selectedProjectId == null
        ? allSessions
        : allSessions.where((s) => s.projectId == _selectedProjectId).toList();

    // 3. Re-calculate Heatmap Dataset locally based on filtered data
    // Map<DateTime, int> where int is "intensity" (duration in minutes or just 1 for presence)
    final Map<DateTime, int> heatmapDataset = {};
    for (var session in filteredSessions) {
      final dateKey = DateTime(
          session.startTime.year, session.startTime.month, session.startTime.day);
      // We assume simple intensity: 1 = active. 
      // If you want opacity based on duration, add minutes here:
      // heatmapDataset[dateKey] = (heatmapDataset[dateKey] ?? 0) + (session.durationSeconds ~/ 60);
      heatmapDataset[dateKey] = 1; 
    }

    // 4. Re-calculate Streak locally (Simple version)
    int currentStreak = 0;
    DateTime checkDate = DateTime.now();
    // Normalize today to remove time
    checkDate = DateTime(checkDate.year, checkDate.month, checkDate.day);
    
    // Check if we have activity today, if not, check yesterday to start counting
    if (!heatmapDataset.containsKey(checkDate)) {
      checkDate = checkDate.subtract(const Duration(days: 1));
    }
    
    while (heatmapDataset.containsKey(checkDate)) {
      currentStreak++;
      checkDate = checkDate.subtract(const Duration(days: 1));
    }

    // 5. Filter for the specific "Selected Day" stats
    final selectedDaySessions = filteredSessions.where((s) {
      return s.startTime.year == _selectedDate.year &&
          s.startTime.month == _selectedDate.month &&
          s.startTime.day == _selectedDate.day;
    }).toList();

    // Calculate total time for selected day
    int selectedDayMinutes = 0;
    for (var s in selectedDaySessions) {
      selectedDayMinutes += (s.durationSeconds / 60).round();
    }
    final int hours = selectedDayMinutes ~/ 60;
    final int mins = selectedDayMinutes % 60;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Streacly",
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header
            const Text(
              "Your Streak\nHeatmap",
              style: TextStyle(
                  fontSize: 32, fontWeight: FontWeight.w800, height: 1.1),
            ),
            const SizedBox(height: 24),
            
            // 2. Filter & Badge Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Real Project Dropdown
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String?>(
                      value: _selectedProjectId,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      borderRadius: BorderRadius.circular(12),
                      hint: const Text("All Projects", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                      items: [
                        // "All Projects" Option
                        const DropdownMenuItem<String?>(
                          value: null,
                          child: Text("All Projects",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        // Dynamic Project Options
                        ...projects.map((project) {
                          return DropdownMenuItem<String?>(
                            value: project.id,
                            child: Text(
                              project.name,
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          );
                        }),
                      ],
                      onChanged: (newValue) {
                        setState(() {
                          _selectedProjectId = newValue;
                        });
                      },
                    ),
                  ),
                ),

                // Streak Badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E1FF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.local_fire_department,
                          color: AppColors.primary, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        "$currentStreak Day Streak",
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // 3. The Heatmap Calendar
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: heatmapDataset.isEmpty
                  ? const SizedBox(
                      height: 200,
                      child: Center(
                        child: Text(
                          "No activity found",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: HeatMapCalendar(
                        datasets: heatmapDataset,
                        colorMode: ColorMode.opacity,
                        colorsets: const {
                          1: AppColors.primary,
                        },
                        onClick: (date) {
                          setState(() => _selectedDate = date);
                        },
                        defaultColor: Colors.grey.shade100,
                        textColor: AppColors.textPrimary,
                        showColorTip: false,
                        margin: const EdgeInsets.all(4),
                        size: 32, // Adjusted size
                        fontSize: 12,
                      ),
                    ),
            ),

            const SizedBox(height: 32),

            // 4. Selected Day Stats
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('MMMM d').format(_selectedDate),
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${hours}h ${mins}m",
                        style: const TextStyle(
                            fontSize: 32, fontWeight: FontWeight.w800),
                      ),
                      // Optional: Add comparison stats here if needed
                    ],
                  ),

                  const SizedBox(height: 24),
                  const Text("SESSIONS",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textSecondary)),
                  const SizedBox(height: 16),

                  // Session List for Selected Day
                  if (selectedDaySessions.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text("No activity on this day.",
                          style: TextStyle(color: Colors.grey)),
                    ),

                  ...selectedDaySessions.map((s) {
                    // Find project name for this session (optional helper)
                    final project = projects.firstWhere(
                        (p) => p.id == s.projectId,
                        orElse: () => projects.isNotEmpty ? projects.first : projects.first); // fallback
                    // Note: Ideally create a safe lookup or handle "Unknown Project"
                    
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                                color: Color(0xFFE0E1FF),
                                shape: BoxShape.circle),
                            child: const Icon(Icons.timer,
                                color: AppColors.primary, size: 16),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  (s.notes == null || s.notes!.isEmpty)
                                      ? "Deep Work"
                                      : s.notes!,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(DateFormat('h:mm a').format(s.startTime),
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.grey)),
                              ],
                            ),
                          ),
                          Text(
                            "${(s.durationSeconds / 60).round()}m",
                            style:
                                const TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}