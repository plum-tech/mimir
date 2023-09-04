import 'package:event_bus/event_bus.dart';

import 'entity/pos.dart';

EventBus eventBus = EventBus();

class JumpToPosEvent {
  final TimetablePos where;

  JumpToPosEvent(this.where);
}
