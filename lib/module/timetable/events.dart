import 'package:event_bus/event_bus.dart';

import 'user_widget/interface.dart';

EventBus eventBus = EventBus();

class CurrentTimetableChangeEvent {
  String? selected;

  CurrentTimetableChangeEvent({this.selected});
}

class TimetableStyleChangeEvent {}

class JumpToPosEvent {
  final TimetablePosition where;

  JumpToPosEvent(this.where);
}
