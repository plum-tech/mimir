import 'package:event_bus/event_bus.dart';

import 'widgets/interface.dart';

EventBus eventBus = EventBus();

class CurrentTimetableChangeEvent {
  String? selected;

  CurrentTimetableChangeEvent({this.selected});
}

class TimetableStyleChangeEvent {}

class JumpToPosEvent {
  final TimetablePos where;

  JumpToPosEvent(this.where);
}
