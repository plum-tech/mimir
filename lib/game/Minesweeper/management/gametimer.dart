import 'dart:async';

class GameTimer{
  late final Timer _timer;
  final int timestart;
  late int timecnt;
  final Function refresh;

  GameTimer({required this.timestart, required this.refresh}){
    timecnt = timestart;
    _timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      if (timecnt > 0){
        timecnt -= 1;
      }else{
        timecnt = 0;
      }
      refresh();
    });
  }

  void stopTimer(){
    _timer.cancel();
  }

  String getTime(){
    int minute = (timecnt / 60).floor();
    int second = timecnt % 60;
    String min = minute < 10 ? '0$minute' : minute.toString();
    String sec = second < 10 ? '0$second' : second.toString();
    return ("$min:$sec");
  }

  String getWintime(){
    int time = timecnt;
    time = timestart - time;
    int minute = (time / 60).floor();
    int second = time % 60;
    String min = minute < 10 ? '0$minute' : minute.toString();
    String sec = second < 10 ? '0$second' : second.toString();
    return ("$min:$sec");
  }
}
