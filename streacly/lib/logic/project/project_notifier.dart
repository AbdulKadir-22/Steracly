import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/project_model.dart';

class ProjectNotifier extends StateNotifier<List<ProjectModel>> {
  ProjectNotifier() : super([]);

  // Add methods later: addProject, updateProject, deleteProject, loadFromHive, etc.
}

final projectProvider = StateNotifierProvider<ProjectNotifier, List<ProjectModel>>((ref) {
  return ProjectNotifier();
});