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
  }

  void addAlarmAudio({
    required DateTime triggerDate,
    ({int repeat, Duration duration})? repeating,
  }) {
    final alarm = VAlarm(parent: _root);
    alarm
      ..triggerDate = triggerDate
      ..action = AlarmAction.audio;
    if (repeating != null) {
      alarm
        ..repeat = repeating.repeat
        ..duration = repeating.duration.toIso();
    }
    _root.children.add(alarm);
  }

  void addAlarmDisplay({
    required DateTime triggerDate,
    required String description,
    ({int repeat, Duration duration})? repeating,
  }) {
    final alarm = VAlarm(parent: _root);
    alarm
      ..triggerDate = triggerDate
      ..action = AlarmAction.display
      ..description = description;
    if (repeating != null) {
      alarm
        ..repeat = repeating.repeat
        ..duration = repeating.duration.toIso();
    }
    _root.children.add(alarm);
  }

  String build() {
    return _root.toString();
  }
}

extension DurationX on Duration {
  IsoDuration toIso() {
    final isNegativeDuration = isNegative;

    // Convert the absolute value of each duration component
    final years = inDays ~/ 365;
    final months = (inDays % 365) ~/ 30;
    final weeks = ((inDays % 365) % 30) ~/ 7;
    final days = ((inDays % 365) % 30) % 7;
    final hours = inHours % 24;
    final minutes = inMinutes % 60;
    final seconds = inSeconds % 60;

    return IsoDuration(
      years: years,
      months: months,
      weeks: weeks,
      days: days,
      hours: hours,
      minutes: minutes,
      seconds: seconds,
      isNegativeDuration: isNegativeDuration,
    );
  }
}
