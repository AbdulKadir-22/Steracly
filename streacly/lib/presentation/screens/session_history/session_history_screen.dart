import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../widgets/session_card.dart';
import '../../../logic/session/session_notifier.dart';

class SessionHistoryScreen extends ConsumerWidget {
  const SessionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch sessions from Hive
    final sessions = ref.watch(sessionProvider);
    // Sort by date (newest first)
    final sortedSessions = [...sessions]..sort((a, b) => b.startTime.compareTo(a.startTime));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Session History", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24)),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: AppColors.primary),
            onPressed: () {}, // Filter logic for later
          ),
        ],
      ),
      body: Column(
        children: [
          // Subheader "All Sessions" with Folder Icon
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            child: Row(
              children: [
                const Icon(Icons.folder_open, color: AppColors.primary, size: 20),
                const SizedBox(width: 8),
                const Text(
                  "All Sessions",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                ),
                const Spacer(),
              ],
            ),
          ),
          
          const Divider(height: 1),

          // The List
          Expanded(
            child: sortedSessions.isEmpty 
            ? const Center(child: Text("No sessions recorded yet."))
            : ListView.builder(
                padding: const EdgeInsets.all(24),
                itemCount: sortedSessions.length,
                itemBuilder: (context, index) {
                  return SessionCard(session: sortedSessions[index]);
                },
              ),
          ),
        ],
      ),
    );
  }
}