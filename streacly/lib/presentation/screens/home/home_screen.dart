import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../widgets/project_card.dart';
import '../../../logic/project/project_notifier.dart';
import '../../../logic/session/session_notifier.dart'; // Import Session Provider
import '../create_project/create_project_screen.dart';
import '../project_details/project_details_screen.dart';
import '../session_history/session_history_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Watch providers
    final projects = ref.watch(projectProvider);
    final allSessions = ref.watch(sessionProvider);

    // 2. Calculate "Today's Focus Time"
    final now = DateTime.now();
    final todaySessions = allSessions.where((session) {
      return session.startTime.year == now.year &&
          session.startTime.month == now.month &&
          session.startTime.day == now.day;
    });

    int todaySeconds = 0;
    for (var session in todaySessions) {
      todaySeconds += session.durationSeconds;
    }

    final int focusHours = todaySeconds ~/ 3600;
    final int focusMinutes = (todaySeconds % 3600) ~/ 60;

    // 3. Calculate "Daily Goal" (Sum of all project weekly goals / 7 days)
    // Default to 6 hours if no projects exist
    int totalWeeklyGoalMinutes = 0;
    for (var project in projects) {
      totalWeeklyGoalMinutes += project.weeklyGoalMinutes;
    }
    
    // If we have projects, calculate daily average, otherwise default 360m (6h)
    final int dailyGoalMinutes = projects.isEmpty 
        ? 360 
        : (totalWeeklyGoalMinutes / 7).round();
        
    final int goalHours = dailyGoalMinutes ~/ 60;
    final int goalMins = dailyGoalMinutes % 60;

    // Greeting Date Logic
    // (Optional: You can use intl package here for real formatting later)
    // For now we keep the structure but you can make this dynamic easily
    final List<String> weekdays = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"];
    final List<String> months = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"];
    final String dateString = "${weekdays[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}";

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left side: Greeting
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dateString, // Dynamic Date
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                            letterSpacing: 1.0),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Hello, Ariont",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),

                  // Right side: Actions
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.history, size: 28),
                        color: AppColors.textPrimary,
                        tooltip: "View History",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const SessionHistoryScreen()),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      const CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(Icons.notifications_none,
                            color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // 2. Focus Time Card (The Big Purple One)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E1FF),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Column(
                  children: [
                    const Text(
                      "TODAY'S FOCUS TIME",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF5A5C75)),
                    ),
                    const SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(color: Color(0xFF1A1C24), height: 1),
                        children: [
                          TextSpan(
                              text: "$focusHours",
                              style: const TextStyle(
                                  fontSize: 64, fontWeight: FontWeight.bold)),
                          const TextSpan(
                              text: "h ",
                              style: TextStyle(
                                  fontSize: 32, fontWeight: FontWeight.w500)),
                          TextSpan(
                              text: "$focusMinutes",
                              style: const TextStyle(
                                  fontSize: 64, fontWeight: FontWeight.bold)),
                          const TextSpan(
                              text: "m",
                              style: TextStyle(
                                  fontSize: 32, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.trending_up,
                              size: 16, color: AppColors.primary),
                          const SizedBox(width: 8),
                          Text(
                            "Daily Goal: ${goalHours}h ${goalMins.toString().padLeft(2, '0')}m",
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF5A5C75)),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Active Projects Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Active Projects",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("View All",
                      style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 16),

              // DYNAMIC PROJECT LIST
              projects.isEmpty
                  ? const Center(child: Text("No projects yet. Create one!"))
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: projects.length,
                      itemBuilder: (context, index) {
                        final project = projects[index];
                        final color =
                            AppColors.projectColors[project.colorIndex];

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ProjectDetailsScreen(project: project),
                              ),
                            );
                          },
                          child: ProjectCard(
                            title: project.name,
                            subtitle:
                                "${(project.weeklyGoalMinutes / 60).toInt()}h weekly goal",
                            tag: project.category,
                            icon: Icons.work,
                            iconColor: color,
                            iconBgColor: color.withValues(alpha: 0.1),
                            streakCount: 0,
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const CreateProjectScreen()),
          );
        },
        backgroundColor: AppColors.primary,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
    );
  }
}