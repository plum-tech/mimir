import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pausable_timer/pausable_timer.dart';

class GameTimer extends StateNotifier<Duration> {
  PausableTimer? _timer;

  bool get timerStart => _timer != null;

  GameTimer({
    Duration initial = Duration.zero,
  }) : super(initial);

  void startTimer() {
    assert(_timer == null, "Timer already started");
    _timer ??= PausableTimer.periodic(const Duration(milliseconds: 1000), () {
      state = state + const Duration(milliseconds: 1000);
    })
      ..start();
  }

  @override
  Duration get state => super.state;

  @override
  set state(Duration state) => super.state = state;

  void reset() {
    _timer?.reset();
    state = Duration.zero;
  }

  void pause() {
    _timer?.pause();
  }

  void resume() {
    _timer?.start();
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
