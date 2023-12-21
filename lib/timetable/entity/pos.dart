import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:sit/l10n/time.dart';

import 'timetable.dart';

part "pos.g.dart";

@CopyWith(skipFields: true)
class TimetablePos {
  /// starts with 0
  final int weekIndex;

  /// starts with 0
  final Weekday weekday;

  const TimetablePos({
    required this.weekIndex,
    required this.weekday,
  });

  static const initial = TimetablePos(weekIndex: 0, weekday: Weekday.monday);

  static TimetablePos locate(
    DateTime current, {
    required DateTime relativeTo,
    TimetablePos? fallback,
  }) {
    // calculate how many days have passed.
    int totalDays = current.clearTime().difference(relativeTo.clearTime()).inDays;

    int week = totalDays ~/ 7 + 1;
    int day = totalDays % 7 + 1;
    if (totalDays >= 0 && 1 <= week && week <= 20 && 1 <= day && day <= 7) {
      return TimetablePos(weekIndex: week - 1, weekday: Weekday.fromIndex(day - 1));
    } else {
      // if out of range, fallback will be return.
      return fallback ?? initial;
    }
  }

  @override
  bool operator ==(Object other) {
    return other is TimetablePos &&
        runtimeType == other.runtimeType &&
        weekIndex == other.weekIndex &&
        weekday == other.weekday;
  }

  @override
  int get hashCode => Object.hash(weekIndex, weekday);

  @override
  String toString() {
    return (week: weekIndex, day: weekday).toString();
  }
}

extension _DateTimeX on DateTime {
  DateTime clearTime([int hour = 0, int minute = 0, int second = 0]) {
    return DateTime(year, month, day, hour, minute, second);
  }
}

extension TimetableX on SitTimetable {
  TimetablePos locate(DateTime current) {
    return TimetablePos.locate(current, relativeTo: startDate);
  }
}
