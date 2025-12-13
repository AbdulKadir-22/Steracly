import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import '../models/project_model.dart';
import '../models/session_model.dart';

class HiveInit {
  static Future<void> init() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocumentDir.path);

    Hive.registerAdapter(ProjectModelAdapter());
    Hive.registerAdapter(SessionModelAdapter());

    await Hive.openBox<ProjectModel>('projects');
    await Hive.openBox<SessionModel>('sessions');
  }
}