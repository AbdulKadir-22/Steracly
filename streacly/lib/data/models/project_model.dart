import 'package:hive/hive.dart';


part 'project_model.g.dart';

@HiveType(typeId: 0)
class ProjectModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String? icon; // e.g., emoji or asset path

  @HiveField(3)
  String category; // e.g., 'DEV', 'WORK', 'HABIT'

  @HiveField(4)
  int colorIndex; // for custom colors

  @HiveField(5)
  int weeklyGoalMinutes; // default 6 hours = 360 minutes

  ProjectModel({
    required this.id,
    required this.name,
    this.icon,
    required this.category,
    required this.colorIndex,
    this.weeklyGoalMinutes = 360,
  });
}