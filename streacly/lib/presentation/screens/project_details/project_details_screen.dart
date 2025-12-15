import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/project_model.dart';
import '../../../data/models/session_model.dart';
import '../../../logic/session/session_notifier.dart';
import '../../widgets/primary_button.dart';
import '../timer/timer_screen.dart';
import '../manual_entry/manual_entry_screen.dart';
import '../heatmap/heatmap_screen.dart'; // We will build this Day 6

class ProjectDetailsScreen extends ConsumerWidget {
  final ProjectModel project;

  const ProjectDetailsScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Get Real Color
    final color = AppColors.projectColors[project.colorIndex];

    // 2. Get Real Session Data (Filtering specifically for this project)
    final allSessions = ref.watch(sessionProvider);
    final projectSessions = allSessions
        .where((s) => s.projectId == project.id)
        .toList()
      ..sort((a, b) => b.startTime.compareTo(a.startTime)); // Newest first

    // 3. Calculate Progress
    final totalSeconds = projectSessions.fold(
      0,
      (sum, s) => sum + s.durationSeconds,
    );
    final totalHours = totalSeconds / 3600;
    final double goalHours = project.weeklyGoalMinutes / 60;
    final progress =
        goalHours == 0 ? 0.0 : (totalHours / goalHours).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // --- Header ---
            _buildHeader(context, color),

            // --- Scrollable Stats & List ---
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 24),

                    // Circular Progress (Real Data)
                    _buildCircularProgress(
                        color, totalHours, goalHours, progress),

                    const SizedBox(height: 24),

                    // Motivational Pill
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        progress >= 1.0
                            ? "Goal reached! Amazing work! 🎉"
                            : "You're on track! Keep it up.",
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Stats Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            icon: Icons.access_time_filled,
                            label: "TOTAL TIME",
                            // Formatting: "12h 30m"
                            value:
                                "${totalSeconds ~/ 3600}h ${(totalSeconds % 3600 ~/ 60)}m",
                            color: color,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildStatCard(
                            icon: Icons.local_fire_department,
                            label: "STREAK",
                            value:
                                " Days", // Real Streak ${project.currentStreak}
                            color: AppColors
                                .fire, // Use the fire color from constants
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Recent Sessions Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Recent Sessions",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                          onPressed: () {
                            // Navigate to full History (Day 5 task)
                          },
                          child: const Text("View All",
                              style: TextStyle(color: AppColors.textSecondary)),
                        )
                      ],
                    ),

                    // Recent Sessions List (Dynamic)
                    if (projectSessions.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text("No sessions yet. Start working!",
                            style: TextStyle(color: Colors.grey[400])),
                      )
                    else
                      ...projectSessions
                          .take(3)
                          .map((session) => _buildSessionItem(session, color)),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // --- Bottom Action Buttons ---
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  PrimaryButton(
                    text: "Start Timer",
                    backgroundColor: color,
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TimerScreen(project: project),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ManualEntryScreen(project: project),
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit_note,
                          color: AppColors.textPrimary),
                      label: const Text("Manual Entry",
                          style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton.icon(
                    onPressed: () {
                      // Navigate to Heatmap (Day 6 task)
                      // Navigator.push(context, MaterialPageRoute(builder: (_) => HeatmapScreen(project: project)));
                    },
                    icon: Icon(Icons.grid_view, size: 18, color: color),
                    label: Text("View Heatmap", style: TextStyle(color: color)),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildHeader(BuildContext context, Color color) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          ),
          const SizedBox(width: 8),
          Container(
            height: 40,
            width: 4,
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                project.name,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary),
              ),
              if (project.category.isNotEmpty)
                Text(
                  project.category,
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary),
                ),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: () {}, // Edit logic later
            icon: const Icon(Icons.edit, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularProgress(
      Color color, double currentHours, double goalHours, double progress) {
    return SizedBox(
      height: 250,
      width: 250,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: 200,
            width: 200,
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: 15,
              color: AppColors.background,
              strokeCap: StrokeCap.round,
            ),
          ),
          SizedBox(
            height: 200,
            width: 200,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 15,
              color: color,
              strokeCap: StrokeCap.round,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    currentHours.toStringAsFixed(1), // "4.5"
                    style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary),
                  ),
                  Text(
                    "/${goalHours.toStringAsFixed(0)}h", // "/5h"
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textSecondary),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                "WEEKLY GOAL",
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: color,
                    letterSpacing: 1.2),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      {required IconData icon,
      required String label,
      required String value,
      required Color color}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 8),
              Text(label,
                  style: TextStyle(
                      fontSize: 10, fontWeight: FontWeight.bold, color: color)),
            ],
          ),
          const SizedBox(height: 12),
          Text(value,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary)),
        ],
      ),
    );
  }

  Widget _buildSessionItem(SessionModel session, Color color) {
    // Format Duration
    final int hours = session.durationSeconds ~/ 3600;
    final int minutes = (session.durationSeconds % 3600) ~/ 60;
    String durationStr = hours > 0 ? "${hours}h ${minutes}m" : "${minutes}m";

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade100),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 5,
                offset: const Offset(0, 2))
          ]),
      child: Row(
        children: [
          Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.timer, color: color)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (session.notes == null || session.notes!.isEmpty)
                      ? "Focus Session"
                      : session.notes!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  DateFormat('MMM d, h:mm a').format(session.startTime),
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(durationStr,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 4),
              Row(
                children: [
                  Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                          color: AppColors.success, shape: BoxShape.circle)),
                  const SizedBox(width: 4),
                  const Text("DONE",
                      style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: AppColors.success)),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
