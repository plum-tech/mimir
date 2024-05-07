import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pausable_timer/pausable_timer.dart';

class GameTimer extends StateNotifier<Duration> {
  PausableTimer? _timer;

  bool get timerStart => _timer != null;

  GameTimer() : super(Duration.zero);

  void startTimer() {
    assert(_timer == null, "Timer already started");
    _timer ??= PausableTimer.periodic(const Duration(milliseconds: 1000), () {
      state = state + const Duration(milliseconds: 1000);
    })
      ..start();
  }

  void reset() {
    _timer?.reset();
    state = Duration.zero;
  }

  void pause() {
    _timer?.pause();
  }

  void resume() {
    assert(_timer!.isPaused, "Timer not yet paused");
    _timer?.start();
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  String getTimeCost() {
    final min = state.inMinutes.toString();
    final sec = state.inSeconds.remainder(60).toString();
    return '${min.padLeft(2, "0")}:${sec.padLeft(2, "0")}';
  }
}
