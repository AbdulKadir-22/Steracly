import 'package:hive/hive.dart';


part 'session_model.g.dart';

@HiveType(typeId: 1)
class SessionModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String projectId;

  @HiveField(2)
  DateTime startTime;

  @HiveField(3)
  DateTime endTime;

  @HiveField(4)
  int durationSeconds;

  @HiveField(5)
  String? notes;

  SessionModel({
    required this.id,
    required this.projectId,
    required this.startTime,
    required this.endTime,
    required this.durationSeconds,
    this.notes,
  });
}