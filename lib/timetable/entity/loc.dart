import 'package:json_annotation/json_annotation.dart';
import 'package:sit/l10n/time.dart';

import 'pos.dart';
import 'timetable_entity.dart';

part "loc.g.dart";

@JsonEnum()
enum TimetableDayLocMode {
  pos,
  date,
  ;
}

@JsonSerializable(ignoreUnannotated: true)
class TimetableDayLoc implements TimetablePos {
  @JsonKey()
  final TimetableDayLocMode mode;

  /// starts with 0
  @JsonKey(name: "weekIndex", includeIfNull: false)
  final int? weekIndexInternal;

  /// starts with 0
  @JsonKey(name: "weekday", includeIfNull: false)
  final Weekday? weekdayInternal;

  /// starts with 0
  @JsonKey(name: "date", includeIfNull: false)
  final DateTime? dateInternal;

  const TimetableDayLoc({
    required this.mode,
    required this.weekIndexInternal,
    required this.weekdayInternal,
    required this.dateInternal,
  });

  const TimetableDayLoc.pos({
    required int weekIndex,
    required Weekday weekday,
  })  : weekdayInternal = weekday,
        weekIndexInternal = weekIndex,
        dateInternal = null,
        mode = TimetableDayLocMode.pos;

  const TimetableDayLoc.date({
    required DateTime date,
  })  : weekdayInternal = null,
        weekIndexInternal = null,
        dateInternal = date,
        mode = TimetableDayLocMode.date;

  @override
  int get weekIndex => weekIndexInternal!;

  @override
  Weekday get weekday => weekdayInternal!;

  DateTime get date => dateInternal!;

  @override
  Map<String, dynamic> toJson() => _$TimetableDayLocToJson(this);

  factory TimetableDayLoc.fromJson(Map<String, dynamic> json) => _$TimetableDayLocFromJson(json);

  TimetablePos asPos() => TimetablePos(weekIndex: weekIndex, weekday: weekday);

  SitTimetableDay? resolveDay(SitTimetableEntity entity) {
    if (mode == TimetableDayLocMode.pos) {
      final day = entity.weeks[weekIndex].days[weekday.index];
      return day;
    } else {
      return null;
    }
  }

  @override
  bool operator ==(Object other) {
    return other is TimetableDayLoc &&
        runtimeType == other.runtimeType &&
        mode == other.mode &&
        dateInternal == other.dateInternal &&
        weekIndexInternal == other.weekIndexInternal &&
        weekdayInternal == other.weekdayInternal;
  }

  @override
  int get hashCode => Object.hash(mode, weekIndexInternal, weekdayInternal, dateInternal);

  @override
  String toString() {
    return switch (mode) {
      TimetableDayLocMode.pos => (week: weekIndexInternal, day: weekdayInternal),
      TimetableDayLocMode.date => date,
    }
        .toString();
  }
}
