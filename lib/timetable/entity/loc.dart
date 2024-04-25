import 'package:json_annotation/json_annotation.dart';
import 'package:sit/l10n/time.dart';

import 'pos.dart';
import 'timetable_entity.dart';

part "loc.g.dart";

@JsonSerializable(ignoreUnannotated: true)
class TimetableLoc implements TimetablePos {
  /// starts with 0
  @JsonKey(name: "weekIndex", includeIfNull: false)
  final int? weekIndexInternal;

  /// starts with 0
  @JsonKey(name: "weekday", includeIfNull: false)
  final Weekday? weekdayInternal;

  const TimetableLoc({
    required this.weekIndexInternal,
    required this.weekdayInternal,
  });

  const TimetableLoc.pos({
    required int weekIndex,
    required Weekday weekday,
  })  : weekdayInternal = weekday,
        weekIndexInternal = weekIndex;

  @override
  int get weekIndex => weekIndexInternal!;

  @override
  Weekday get weekday => weekdayInternal!;

  @override
  Map<String, dynamic> toJson() => _$TimetableLocToJson(this);

  factory TimetableLoc.fromJson(Map<String, dynamic> json) => _$TimetableLocFromJson(json);

  TimetablePos asPos() => TimetablePos(weekIndex: weekIndex, weekday: weekday);

  SitTimetableDay? resolveDay(SitTimetableEntity entity) {
    final day = entity.weeks[weekIndex].days[weekday.index];
    return day;
  }

  @override
  bool operator ==(Object other) {
    return other is TimetableLoc &&
        runtimeType == other.runtimeType &&
        weekIndexInternal == other.weekIndexInternal &&
        weekdayInternal == other.weekdayInternal;
  }

  @override
  int get hashCode => Object.hash(weekIndexInternal, weekdayInternal);

  @override
  String toString() {
    return (week: weekIndexInternal, day: weekdayInternal).toString();
  }
}
