import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class ProjectCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String tag; // e.g., "DEV", "HABIT"
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final int streakCount;

  const ProjectCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.streakCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // 1. Icon Box
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 16),

          // 2. Title & Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Tag Pill
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 3. Streak Flame
          Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.local_fire_department, size: 18, color: AppColors.fire),
                  const SizedBox(width: 4),
                  Text(
                    "$streakCount",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.fire,
                    ),
                  ),
                ],
              ),
              // Dots decoration (Static for now)
              const SizedBox(height: 8),
              Row(
                children: List.generate(5, (index) => Padding(
                  padding: const EdgeInsets.only(left: 3),
                  child: CircleAvatar(
                    radius: 2.5,
                    backgroundColor: index < 3 ? AppColors.success : Colors.grey[300],
                  ),
                )),
              )
            ],
          ),
        ],
      ),
    );
  }
}