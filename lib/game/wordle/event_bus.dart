import 'package:event_bus/event_bus.dart' as e;

final wordleEventBus = e.EventBus();

class WordleResultEvent {
  final bool value;

  const WordleResultEvent(this.value);
}

class WordleValidationEndEvent {
  final bool value;

  const WordleValidationEndEvent(this.value);
}

class WordleValidationEvent {
  final bool value;

  const WordleValidationEvent(this.value);
}

class WordleNewGameEvent {
  const WordleNewGameEvent();
}

class WordleAttemptEvent {
  final List<int> validation;

  const WordleAttemptEvent(this.validation);
}

class WordleAnimationStopEvent {
  const WordleAnimationStopEvent();
}

typedef EventCallBack = void Function(dynamic args);

final mainBus = EventBus();

class EventBus {
  EventBus._internal();
  static final EventBus _bus = EventBus._internal();
  factory EventBus() => _bus;

  final _eventMap = <String, List<EventCallBack>>{};

  void on({required String event, required EventCallBack onEvent}) {
    _eventMap[event] ??= <EventCallBack>[];
    _eventMap[event]!.add(onEvent);
  }

  void off({required String event, EventCallBack? callBack}) {
    if (callBack == null) {
      _eventMap.remove(event);
    } else {
      _eventMap[event]?.remove(callBack);
    }
  }

  void emit({required String event, dynamic args}) {
    // _eventMap[event]?.forEach((func) {
    //   func(args);
    // });
    if (_eventMap[event] != null) {
      for (int i = _eventMap[event]!.length - 1; i >= 0; i--) {
        _eventMap[event]![i](args);
      }
    }
  }
}
