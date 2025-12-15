import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/session_model.dart';

class SessionCard extends StatelessWidget {
  final SessionModel session;

  const SessionCard({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    final endTime = session.endTime;

    // Format Duration Text (e.g., "45m 20s" or "1h 30m")
    String durationText = "";
    final int hours = session.durationSeconds ~/ 3600;
    final int minutes = (session.durationSeconds % 3600) ~/ 60;
    final int seconds = session.durationSeconds % 60;

    if (hours > 0) durationText += "${hours}h ";
    if (minutes > 0) durationText += "${minutes}m ";
    if (seconds > 0 && hours == 0)
      durationText += "${seconds}s"; // Only show seconds if short

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FE), // Very light blue/grey from image
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left Side: Tag + Details
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Tag (Timer/Manual)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E1FF),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  "Session",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // 2. Duration (Big Text)
              Text(
                durationText,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary),
              ),

              const SizedBox(height: 4),

              // 3. Date & Time Range
              Row(
                children: [
                  const Icon(Icons.calendar_today,
                      size: 12, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    "${DateFormat('MMM d').format(session.startTime)} · ${DateFormat('h:mm a').format(session.startTime)} - ${DateFormat('h:mm a').format(endTime)}",
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ],
          ),

          // Right Side: Icon
          CircleAvatar(
            radius: 20,
            backgroundColor: const Color(0xFFE0E1FF),
            child: const Icon(
              Icons.timer,
              color: AppColors.primary,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
