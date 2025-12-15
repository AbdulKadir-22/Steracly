import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart'; // Or Navigator
import '../../../core/constants/app_colors.dart';
import '../../widgets/primary_button.dart';
import '../../../logic/project/project_notifier.dart';

class CreateProjectScreen extends ConsumerStatefulWidget {
  const CreateProjectScreen({super.key});

  @override
  ConsumerState<CreateProjectScreen> createState() =>
      _CreateProjectScreenState();
}

class _CreateProjectScreenState extends ConsumerState<CreateProjectScreen> {
  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController(); // e.g., "Work", "Dev"
  double _weeklyGoal = 5.0; // Default 5 hours

  // Simple Color Picker Data
  final List<String> _colors = [
    "0xFF5D5FEF", // Purple
    "0xFFFF7E5F", // Orange
    "0xFF4ADE80", // Green
    "0xFF3B82F6", // Blue
    "0xFFF43F5E", // Red
  ];
  String _selectedColor = "0xFF5D5FEF";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Project",
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Project Name
            const Text("Project Name",
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: "e.g., Learn Flutter",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 2. Tag / Subtitle
            const Text("Tag / Category",
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(
              controller: _subtitleController,
              decoration: InputDecoration(
                hintText: "e.g., DEV, WORK, HEALTH",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 3. Weekly Goal Slider
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Weekly Goal",
                    style: TextStyle(fontWeight: FontWeight.w600)),
                Text("${_weeklyGoal.toInt()} hrs",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: AppColors.primary)),
              ],
            ),
            Slider(
              value: _weeklyGoal,
              min: 1,
              max: 40,
              divisions: 39,
              activeColor: AppColors.primary,
              onChanged: (val) => setState(() => _weeklyGoal = val),
            ),

            const SizedBox(height: 24),

            // 4. Color Picker
            const Text("Project Color",
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _colors.map((color) {
                final isSelected = _selectedColor == color;
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = color),
                  child: Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Color(int.parse(color)),
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(color: Colors.black, width: 3)
                          : null,
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white)
                        : null,
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 48),

            // 5. Create Button
            PrimaryButton(
              text: "Create Project",
              onPressed: () {
                if (_titleController.text.isEmpty) return;

                // Call the Notifier to save to Hive
                ref.read(projectProvider.notifier).addProject(
                      name: _titleController.text,
                      category: _subtitleController.text.toUpperCase(),
                      icon: 'code', // emoji or identifier, fine for now
                      colorIndex: _colors.indexOf(_selectedColor),
                      weeklyGoalMinutes: (_weeklyGoal * 60).toInt(),
                    );
                Navigator.pop(context); // Go back to Home
              },
            ),
          ],
        ),
      ),
    );
  }
}
