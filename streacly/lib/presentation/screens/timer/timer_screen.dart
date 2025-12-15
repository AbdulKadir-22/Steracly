import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          project.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (timerState.isRunning || timerState.elapsedSeconds > 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Stop the timer before leaving."),
                ),
              );
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ─────────────────────────────────────
          // Timer Circle
          // ─────────────────────────────────────
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 280,
                height: 280,
                child: CircularProgressIndicator(
                  value: 1.0,
                  strokeWidth: 20,
                  backgroundColor:
                      AppColors.primary.withOpacity(0.15),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.primary,
                  ),
                  strokeCap: StrokeCap.round,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatTime(timerState.elapsedSeconds),
                    style: const TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.w800,
                      fontFeatures: [
                        FontFeature.tabularFigures(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    timerState.isRunning ? "FOCUS" : "PAUSED",
                    style: const TextStyle(
                      letterSpacing: 2,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 80),

          // ─────────────────────────────────────
          // Play / Pause Button
          // ─────────────────────────────────────
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
                    color: AppColors.primary.withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Icon(
                timerState.isRunning
                    ? Icons.pause
                    : Icons.play_arrow,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),

          const SizedBox(height: 40),

          // ─────────────────────────────────────
          // Finish Session Button
          // ─────────────────────────────────────
          if (!timerState.isRunning &&
              timerState.elapsedSeconds > 0)
            TextButton.icon(
              icon: const Icon(
                Icons.stop_circle_outlined,
                color: Colors.red,
                size: 28,
              ),
              label: const Text(
                "Finish Session",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 18,
                ),
              ),
              onPressed: () async {
                final duration =
                    timerNotifier.stopTimer();

                final endTime = DateTime.now();
                final startTime = endTime.subtract(
                  Duration(seconds: duration),
                );

                await ref
                    .read(sessionProvider.notifier)
                    .addSession(
                      projectId: project.id,
                      startTime: startTime,
                      endTime: endTime,
                    );

                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Session saved. Well done. 🔥",
                      ),
                      backgroundColor: AppColors.success,
                    ),
                  );
                }
              },
            ),
        ],
      ),
    );
  }
}
