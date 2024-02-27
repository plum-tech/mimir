import 'package:enough_icalendar/enough_icalendar.dart';

class ICal {
  final VCalendar _root;

  ICal({
    required String company,
    required String product,
    required String lang,
  }) : _root = VCalendar()
          ..productId = "$company//$product//$lang"
          ..version = "2.0";

  IEvent addEvent({
    required String uid,
    required DateTime start,
    DateTime? end,
    String? summary,
    String? description,
    String? comment,
    String? location,
    GeoLocation? geoLocation,
    bool? allDayEvent,
  }) {
    final event = VEvent(parent: _root);
    event
      ..start = start
      ..end = end
      ..description = description
      ..location = location
      ..geoLocation = geoLocation
      ..isAllDayEvent = allDayEvent
      ..summary = summary
      ..uid = uid;
    _root.children.add(event);
    return IEvent(event);
  }

  String build() {
    return _root.toString();
  }
}

class IEvent {
  final VEvent _event;

  const IEvent(this._event);

  VAlarm addAlarmAudio({
    required DateTime triggerDate,
    ({int repeat, Duration duration})? repeating,
  }) {
    final alarm = VAlarm(parent: _event);
    alarm
      ..triggerDate = triggerDate
      ..action = AlarmAction.audio;
    if (repeating != null) {
      alarm
        ..repeat = repeating.repeat
        ..duration = repeating.duration.toIso();
    }
    _event.children.add(alarm);
    return alarm;
  }

  void addAlarmDisplay({
    required DateTime triggerDate,
    required String description,
    ({int repeat, Duration duration})? repeating,
  }) {
    final alarm = VAlarm(parent: _event);
    alarm
      ..triggerDate = triggerDate
      ..action = AlarmAction.display
      ..description = description;
    if (repeating != null) {
      alarm
        ..repeat = repeating.repeat
        ..duration = repeating.duration.toIso();
    }
    _event.children.add(alarm);
  }
}
