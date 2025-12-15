import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../widgets/project_card.dart';
import '../../../logic/project/project_notifier.dart';
import '../create_project/create_project_screen.dart';
import '../project_details/project_details_screen.dart';
import '../session_history/session_history_screen.dart';

class HomeScreen extends ConsumerWidget {
  // Changed to ConsumerWidget
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the project list
    final projects = ref.watch(projectProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ... [Keep Header and Focus Time Card from Day 2] ...
              // (I will omit them here for brevity, but keep them in your code)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left side: Greeting
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "WEDNESDAY, OCT 24",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                            letterSpacing: 1.0),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Hello, Alex",
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
                      // --- NEW TEMPORARY HISTORY BUTTON ---
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

                      // Existing Notification Icon
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
                  color: const Color(0xFFE0E1FF), // Light purple bg from design
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
                      text: const TextSpan(
                        style: TextStyle(color: Color(0xFF1A1C24), height: 1),
                        children: [
                          TextSpan(text: "5", style: TextStyle(fontSize: 64, fontWeight: FontWeight.bold)),
                          TextSpan(text: "h ", style: TextStyle(fontSize: 32, fontWeight: FontWeight.w500)),
                          TextSpan(text: "12", style: TextStyle(fontSize: 64, fontWeight: FontWeight.bold)),
                          TextSpan(text: "m", style: TextStyle(fontSize: 32, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.trending_up, size: 16, color: AppColors.primary),
                          SizedBox(width: 8),
                          Text(
                            "Daily Goal: 6h 00m",
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF5A5C75)),
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
                            iconBgColor: color.withOpacity(0.1),
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
          // Navigate to Create Project Screen
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
