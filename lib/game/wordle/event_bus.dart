import 'package:event_bus/event_bus.dart';

import 'entity/status.dart';

final wordleEventBus = EventBus();

class WordleResultEvent {
  final bool value;

  const WordleResultEvent(this.value);
}

class WordleValidationEndEvent {
  final bool value;

  const WordleValidationEndEvent(this.value);
}

class WordleValidationEvent {
  final Map<String, int> value;

  const WordleValidationEvent(this.value);
}

class WordleNewGameEvent {
  const WordleNewGameEvent();
}

class WordleAttemptEvent {
  final List<LetterStatus> validation;

  const WordleAttemptEvent(this.validation);
}

class WordleAnimationStopEvent {
  const WordleAnimationStopEvent();
}
