import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/session_model.dart';
// import '../../data/models/project_model.dart';

class SessionNotifier extends StateNotifier<List<SessionModel>> {
  SessionNotifier() : super([]) {
    _loadSessions();
  }

  Box<SessionModel> get _box => Hive.box<SessionModel>('sessions');

  void _loadSessions() {
    state = _box.values.toList();
  }

  Future<void> addSession({
    required String projectId,
    required DateTime startTime,
    required DateTime endTime,
    String? notes,
  }) async {
    final durationSeconds = endTime.difference(startTime).inSeconds;

    final session = SessionModel(
      id: const Uuid().v4(),
      projectId: projectId,
      startTime: startTime,
      endTime: endTime,
      durationSeconds: durationSeconds,
      notes: notes,
    );

    await _box.add(session);
    state = [...state, session];
  }
}

final sessionProvider =
    StateNotifierProvider<SessionNotifier, List<SessionModel>>(
  (ref) => SessionNotifier(),
);
