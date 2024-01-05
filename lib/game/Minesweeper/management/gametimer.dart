import 'dart:async';

class GameTimer{
  late final Timer _timer;
  late final int timestart;
  late var _timecnt;
  final Function refresh;

  GameTimer({required time, required this.refresh}){
    timestart = time;
    _timecnt = time;
    _timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      if (_timecnt > 0){
        _timecnt -= 1;
      }else{
        _timecnt = 0;
      }
      refresh();
    });
  }

  void stopTimer(){
    _timer.cancel();
  }

  String getTime(){
    int minute = (_timecnt / 60).floor();
    int second = _timecnt % 60;
    String min = minute < 10 ? '0$minute' : minute.toString();
    String sec = second < 10 ? '0$second' : second.toString();
    return ("$min:$sec");
  }

  String getWintime(){
    int time = _timecnt;
    time = timestart - time;
    int minute = (time / 60).floor();
    int second = time % 60;
    String min = minute < 10 ? '0$minute' : minute.toString();
    String sec = second < 10 ? '0$second' : second.toString();
    return ("$min:$sec");
  }
}