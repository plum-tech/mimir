import 'package:enough_icalendar/enough_icalendar.dart';

class ICal {
  final VCalendar _root;

  ICal({
    required String company,
    required String product,
    required String lang,
  }) : _root = VCalendar()..productId = "$company//$product//$lang";

  void addEvent({
    required String uid,
    String? summary,
    required DateTime start,
    DateTime? end,
    String? description,
    String? location,
    GeoLocation? geoLocation,
    bool? allDayEvent,
  }) {
    final event = VEvent(parent: _root);
    event
      ..start = start
      ..end = end
      ..location = location
      ..geoLocation = geoLocation
      ..isAllDayEvent = allDayEvent
      ..description = description
      ..summary = summary
      ..uid = uid;
  }

  void addAlarmAudio({
    required DateTime triggerDate,
    // TODO: convert Duration to IsoDuration
    required ({int repeat, IsoDuration duration}) repeating,
  }) {
    final alarm = VAlarm(parent: _root);
    alarm
      ..triggerDate = triggerDate
      ..action = AlarmAction.audio
      ..repeat = repeating.repeat
      ..duration = repeating.duration;
  }
  void addAlarmDisplay({
    required DateTime triggerDate,
    required String description,
    // TODO: convert Duration to IsoDuration
    required ({int repeat, IsoDuration duration}) repeating,
  }) {
    final alarm = VAlarm(parent: _root);
    alarm
      ..triggerDate = triggerDate
      ..action = AlarmAction.display
      ..repeat = repeating.repeat
      ..description = description
      ..duration = repeating.duration;
  }

  String build() {
    return _root.toString();
  }
}
