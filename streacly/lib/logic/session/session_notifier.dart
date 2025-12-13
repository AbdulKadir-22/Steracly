import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/session_model.dart';

class SessionNotifier extends StateNotifier<List<SessionModel>> {
  SessionNotifier() : super([]);

  // Methods later
}

final sessionProvider = StateNotifierProvider<SessionNotifier, List<SessionModel>>((ref) {
  return SessionNotifier();
});