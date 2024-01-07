import 'dart:async';

class GameTimer {
  late final Timer _timer;
  final int timeStart;
  late int timeCnt;
  final void Function() reFresh;

  GameTimer({required this.timeStart, required this.reFresh}) {
    timeCnt = timeStart;
    _timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      if (timeCnt > 0) {
        timeCnt -= 1;
      } else {
        timeCnt = 0;
      }
      reFresh();
    });
  }

  void stopTimer() {
    _timer.cancel();
  }

  bool checkHalfTime(){
    return timeCnt < timeStart/2;
  }

  String getTime() {
    int minute = (timeCnt / 60).floor();
    int second = timeCnt % 60;
    String min = minute < 10 ? '0$minute' : minute.toString();
    String sec = second < 10 ? '0$second' : second.toString();
    return ("$min:$sec");
  }

  String getTimeCost() {
    int time = timeCnt;
    time = timeStart - time;
    int minute = (time / 60).floor();
    int second = time % 60;
    String min = minute < 10 ? '0$minute' : minute.toString();
    String sec = second < 10 ? '0$second' : second.toString();
    return ("$min:$sec");
  }
}
