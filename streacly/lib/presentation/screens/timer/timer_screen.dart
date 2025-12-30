import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart'; // Ensure you have intl package for time formatting

import '../../../core/constants/app_colors.dart';
import '../../../data/models/project_model.dart';
import '../../../logic/timer/timer_notifier.dart';
import '../../../logic/session/session_notifier.dart';

class TimerScreen extends ConsumerWidget {
  final ProjectModel project;

  const TimerScreen({super.key, required this.project});

  String _formatTime(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(timerProvider);
    final timerNotifier = ref.read(timerProvider.notifier);

    // Calculate start time for the footer (Mock logic or real if you track it)
    // For now, using current time minus elapsed if running, or just "10:00 AM" placeholder logic
    final startTime =
        DateTime.now().subtract(Duration(seconds: timerState.elapsedSeconds));
    final startTimeString = DateFormat('h:mm a').format(startTime);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () {
            if (timerState.isRunning || timerState.elapsedSeconds > 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Stop the timer before leaving.")),
              );
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: Text(
          project.name,
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Colors.black),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: [
          const Spacer(flex: 2),

          // ─────────────────────────────────────
          // 1. Timer Circle & Text
          // ─────────────────────────────────────
          Stack(
            alignment: Alignment.center,
            children: [
              // Background Ring
              SizedBox(
                width: 280,
                height: 280,
                child: CircularProgressIndicator(
                  value: 1.0,
                  strokeWidth: 20,
                  color: const Color(0xFFF2F4F7), // Very subtle grey/blue
                  strokeCap: StrokeCap.round,
                ),
              ),
              // Progress Ring
              SizedBox(
                width: 280,
                height: 280,
                child: CircularProgressIndicator(
                  value: 1.0, // Or calculate actual progress based on a goal
                  strokeWidth: 20,
                  color: AppColors.primary.withValues(alpha: 0.8),
                  strokeCap: StrokeCap.round,
                ),
              ),
              // Center Text
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatTime(timerState.elapsedSeconds),
                    style: const TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                      height: 1.0,
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    timerState.isRunning ? "FOCUS" : "PAUSED",
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4.0, // Wide spacing matching design
                    ),
                  ),
                ],
              ),
            ],
          ),

          const Spacer(flex: 3),

          // ─────────────────────────────────────
          // 2. Control Buttons Row
          // ─────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // --- Left: Pause / Finish ---
                _buildSmallControl(
                  icon: Icons.pause,
                  label: "Pause",
                  onTap: () {
                    // Logic: If running, pause. If paused, maybe show "Finish"?
                    timerNotifier.pauseTimer();
                  },
                  isActive: !timerState.isRunning &&
                      timerState.elapsedSeconds > 0, // Highlight if paused
                ),

                // --- Center: Play / Toggle ---
                GestureDetector(
                  onTap: () {
                    if (timerState.isRunning) {
                      timerNotifier.pauseTimer();
                    } else {
                      timerNotifier.startTimer();
                    }
                  },
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: .3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Icon(
                      timerState.isRunning
                          ? Icons.pause
                          : Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 44,
                    ),
                  ),
                ),

                // --- Right: Reset / Finish ---
                // If paused, show "Finish" icon instead of Reset to allow saving
                timerState.elapsedSeconds > 0 && !timerState.isRunning
                    ? _buildSmallControl(
                        icon: Icons.check,
                        label: "Finish",
                        color: AppColors.success,
                        onTap: () async {
                          final startTime = timerState.startedAt!;
                          final endTime = DateTime.now();

                          timerNotifier.stopTimer();

                          await ref.read(sessionProvider.notifier).addSession(
                                projectId: project.id,
                                startTime: startTime,
                                endTime: endTime,
                              );

                          if (context.mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Session saved! 🔥"),
                                backgroundColor: AppColors.success,
                              ),
                            );
                          }
                        },
                      )
                    : _buildSmallControl(
                        icon: Icons.refresh,
                        label: "Reset",
                        onTap: () {
                          timerNotifier
                              .stopTimer(); // Just reset without saving
                        },
                      ),
              ],
            ),
          ),

          const Spacer(flex: 2),

          // ─────────────────────────────────────
          // 3. Footer Text
          // ─────────────────────────────────────
          Text(
            "Current session started at $startTimeString",
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 40), // Bottom padding
        ],
      ),
    );
  }

  Widget _buildSmallControl({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color color = AppColors.primary,
    bool isActive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color:
                  isActive ? color.withValues(alpha: 0.1) : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Icon(icon,
                color: isActive ? color : Colors.grey.shade400, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
                fontSize: 12,
                color: isActive ? color : Colors.grey.shade400,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
