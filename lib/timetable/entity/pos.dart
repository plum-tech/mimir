import 'package:quiver/core.dart';

import 'timetable.dart';

class TimetablePos {
  /// starts with 0
  final int weekIndex;

  /// starts with 0
  final int dayIndex;

  const TimetablePos({
    required this.weekIndex,
    required this.dayIndex,
  });

  static const initial = TimetablePos(weekIndex: 0, dayIndex: 0);

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
      return TimetablePos(weekIndex: week - 1, dayIndex: day - 1);
    } else {
      // if out of range, fallback will be return.
      return fallback ?? initial;
    }
  }

  TimetablePos copyWith({
    int? weekIndex,
    int? dayIndex,
  }) =>
      TimetablePos(
        weekIndex: weekIndex ?? this.weekIndex,
        dayIndex: dayIndex ?? this.dayIndex,
      );

  @override
  bool operator ==(Object other) {
    return other is TimetablePos &&
        runtimeType == other.runtimeType &&
        weekIndex == other.weekIndex &&
        dayIndex == other.dayIndex;
  }

  @override
  int get hashCode => hash2(weekIndex, dayIndex);

  @override
  String toString() {
    return (week: weekIndex, day: dayIndex).toString();
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
