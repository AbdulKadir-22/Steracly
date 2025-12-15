import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/project_model.dart';
import '../../../logic/session/session_notifier.dart';
import '../../widgets/primary_button.dart';

class ManualEntryScreen extends ConsumerStatefulWidget {
  final ProjectModel project;

  const ManualEntryScreen({super.key, required this.project});

  @override
  ConsumerState<ManualEntryScreen> createState() => _ManualEntryScreenState();
}

class _ManualEntryScreenState extends ConsumerState<ManualEntryScreen> {
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _hoursController = TextEditingController(text: "00");
  final TextEditingController _minutesController = TextEditingController(text: "00");
  final TextEditingController _notesController = TextEditingController();

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Add Manual Entry", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Date Picker
            const Text("Date", style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF5A5C75))),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30), // Rounded capsule
                  border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      // Logic to show "Today" if selected date is today
                      isSameDay(_selectedDate, DateTime.now()) 
                          ? "Today, ${DateFormat('MMM d').format(_selectedDate)}"
                          : DateFormat('EEE, MMM d, y').format(_selectedDate),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const Icon(Icons.calendar_today_outlined, color: AppColors.primary, size: 20),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 2. Duration Inputs (Hours & Minutes)
            Row(
              children: [
                Expanded(child: _buildTimeInput("Hours", "HRS", _hoursController)),
                const SizedBox(width: 16),
                Expanded(child: _buildTimeInput("Minutes", "MIN", _minutesController)),
              ],
            ),

            const SizedBox(height: 24),

            // 3. Notes Area
            const Text("Notes", style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF5A5C75))),
            const SizedBox(height: 8),
            Container(
              height: 150,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF2F4F7), // Light blue-grey form background
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _notesController,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: "What did you work on? Add some details about your session...",
                  hintStyle: TextStyle(color: Color(0xFFA0A3BD)),
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 80), // Spacing for button

            // 4. Helper Text
            const Center(
              child: Text(
                "Manual entries help keep your streak consistent\nwhen you forget to start the timer.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: AppColors.primary, height: 1.5),
              ),
            ),
            
            const SizedBox(height: 24),

            // 5. Save Button
            PrimaryButton(
              text: "Save Entry",
              onPressed: _saveEntry,
              backgroundColor: AppColors.primary,
              textColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget for Hour/Min inputs
  Widget _buildTimeInput(String label, String unit, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF5A5C75))),
        const SizedBox(height: 8),
        Container(
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: AppColors.primary.withOpacity(0.2)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 50,
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primaryLight),
                  decoration: const InputDecoration(border: InputBorder.none),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(unit, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
              ),
            ],
          ),
        )
      ],
    );
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void _saveEntry() {
  final int hours = int.tryParse(_hoursController.text) ?? 0;
  final int minutes = int.tryParse(_minutesController.text) ?? 0;

  final int totalSeconds = (hours * 3600) + (minutes * 60);
  if (totalSeconds == 0) return;

  final startTime = DateTime(
    _selectedDate.year,
    _selectedDate.month,
    _selectedDate.day,
  );

  final endTime = startTime.add(
    Duration(seconds: totalSeconds),
  );

  ref.read(sessionProvider.notifier).addSession(
    projectId: widget.project.id,
    startTime: startTime,
    endTime: endTime,
    notes: _notesController.text.isEmpty
        ? null
        : _notesController.text,
  );

  Navigator.pop(context);
}

}