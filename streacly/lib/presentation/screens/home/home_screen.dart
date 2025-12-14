import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../widgets/project_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.notifications_none, color: AppColors.textPrimary),
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

              // 3. Active Projects Section
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Active Projects",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "View All",
                    style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 4. Project List (Using our Widget)
              const ProjectCard(
                title: "Learn SwiftUI",
                subtitle: "12h this week",
                tag: "DEV",
                icon: Icons.code,
                iconColor: Colors.blue,
                iconBgColor: Color(0xFFE8F1FF),
                streakCount: 5,
              ),
              const ProjectCard(
                title: "Design Portfolio",
                subtitle: "4h this week",
                tag: "WORK",
                icon: Icons.brush,
                iconColor: Colors.purple,
                iconBgColor: Color(0xFFF3E8FF),
                streakCount: 2,
              ),
               const ProjectCard(
                title: "Reading",
                subtitle: "1h this week",
                tag: "HABIT",
                icon: Icons.book,
                iconColor: Colors.orange,
                iconBgColor: Color(0xFFFFF4E5),
                streakCount: 12,
              ),
            ],
          ),
        ),
      ),
      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
    );
  }
}