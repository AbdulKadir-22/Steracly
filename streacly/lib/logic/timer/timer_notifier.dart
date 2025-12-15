import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Simple state class for the Timer
class TimerState {
  final int elapsedSeconds;
  final bool isRunning;
  final bool isPaused;

  TimerState({
    this.elapsedSeconds = 0,
    this.isRunning = false,
    this.isPaused = false,
  });

  TimerState copyWith({int? elapsedSeconds, bool? isRunning, bool? isPaused}) {
    return TimerState(
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      isRunning: isRunning ?? this.isRunning,
      isPaused: isPaused ?? this.isPaused,
    );
  }
}

class TimerNotifier extends StateNotifier<TimerState> {
  TimerNotifier() : super(TimerState());

  Timer? _ticker;

  // Start the timer
  void startTimer() {
    if (state.isRunning) return;

    state = state.copyWith(isRunning: true, isPaused: false);
    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      state = state.copyWith(elapsedSeconds: state.elapsedSeconds + 1);
    });
  }

  // Pause
  void pauseTimer() {
    _ticker?.cancel();
    state = state.copyWith(isRunning: false, isPaused: true);
  }

  // Stop & Reset (Returns total seconds tracked)
  int stopTimer() {
    _ticker?.cancel();
    final totalTime = state.elapsedSeconds;
    state = TimerState(); // Reset state to 0
    return totalTime;
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}

final timerProvider = StateNotifierProvider<TimerNotifier, TimerState>((ref) {
  return TimerNotifier();
});