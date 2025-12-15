import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../../data/models/project_model.dart';

class ProjectNotifier extends StateNotifier<List<ProjectModel>> {
  ProjectNotifier() : super([]) {
    _loadProjects();
  }

  // Hive box reference
  Box<ProjectModel> get _box => Hive.box<ProjectModel>('projects');

  // Load all projects from Hive into Riverpod state
  void _loadProjects() {
    state = _box.values.toList();
  }

  // Add a new project
  Future<void> addProject({
    required String name,
    required String category,
    String? icon,
    required int colorIndex,
    int weeklyGoalMinutes = 360,
  }) async {
    final project = ProjectModel(
      id: const Uuid().v4(),
      name: name,
      category: category,
      icon: icon,
      colorIndex: colorIndex,
      weeklyGoalMinutes: weeklyGoalMinutes,
    );

    await _box.add(project);

    // Update state immutably
    state = [...state, project];
  }

  // Delete a project
  Future<void> deleteProject(ProjectModel project) async {
    await project.delete();
    _loadProjects();
  }
}

final projectProvider =
    StateNotifierProvider<ProjectNotifier, List<ProjectModel>>(
  (ref) => ProjectNotifier(),
);
