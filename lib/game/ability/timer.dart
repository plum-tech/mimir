import '../entity/timer.dart';
import 'ability.dart';

class TimerWidgetAbility extends GameWidgetAbility {
  late final GameTimer timer;

  @override
  void initState() {
    super.initState();
    timer = GameTimer();
  }

  @override
  void dispose() {
    timer.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    timer.stopTimer();
    super.deactivate();
  }

  @override
  void onAppInactive() {
    timer.pause();
  }

  @override
  void onAppResumed() {
    timer.resume();
  }
}
