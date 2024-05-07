import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameTimer extends StateNotifier<Duration> {
  Timer? _timer;

  bool get timerStart => _timer != null;

  GameTimer() : super(Duration.zero);

  void startTimer() {
    assert(_timer == null, "Timer already started");
    _timer ??= Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      debugPrint("${timer.tick}");
      state = state + const Duration(milliseconds: 1000);
    });
  }

  void reset() {
    state = Duration.zero;
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  String getTimeCost() {
    int time = state.inSeconds;
    int minute = (time / 60).floor();
    int second = time % 60;
    String min = minute < 10 ? '0$minute' : minute.toString();
    String sec = second < 10 ? '0$second' : second.toString();
    return ("$min:$sec");
  }
}
