import 'dart:async';

class GameTimer {
  final void Function() refresh;
  late final Timer _timer;
  bool timerStart = false;
  late int cntNow;

  GameTimer({required this.refresh}) {
    cntNow = 0;
    timerStart = false;
  }

  void startTimer() {
    timerStart = true;
    _timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      if (cntNow >= 0 && cntNow < 60 * 60 - 1) {
        cntNow += 1;
      } else {
        cntNow = 0;
      }
      refresh();
    });
  }

  void stopTimer() {
    timerStart = false;
    _timer.cancel();
  }

  bool checkValueTime({required int val}){
    return cntNow > val;
  }

  int getTimerValue() {
    return cntNow;
  }

  String getTimeCost() {
    int time = cntNow;
    int minute = (time / 60).floor();
    int second = time % 60;
    String min = minute < 10 ? '0$minute' : minute.toString();
    String sec = second < 10 ? '0$second' : second.toString();
    return ("$min:$sec");
  }
}
