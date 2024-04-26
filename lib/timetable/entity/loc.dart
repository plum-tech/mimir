import 'package:json_annotation/json_annotation.dart';
import 'package:sit/l10n/extension.dart';
import 'package:sit/lifecycle.dart';
import 'pos.dart';
import 'timetable_entity.dart';

part "loc.g.dart";

@JsonEnum()
enum TimetableDayLocMode {
  pos,
  date,
  ;

  String l10n() => name;
}

@JsonSerializable(ignoreUnannotated: true)
class TimetableDayLoc {
  @JsonKey()
  final TimetableDayLocMode mode;

  @JsonKey(name: "pos", includeIfNull: false)
  final TimetablePos? posInternal;

  /// starts with 0
  @JsonKey(name: "date", includeIfNull: false)
  final DateTime? dateInternal;

  const TimetableDayLoc({
    required this.mode,
    required this.posInternal,
    required this.dateInternal,
  });

  const TimetableDayLoc.pos(TimetablePos pos)
      : posInternal = pos,
        dateInternal = null,
        mode = TimetableDayLocMode.pos;

  const TimetableDayLoc.date(DateTime date)  : posInternal = null,
        dateInternal = date,
        mode = TimetableDayLocMode.date;

  TimetablePos get pos => posInternal!;

  DateTime get date => dateInternal!;

  String l10n() {
    return switch(mode){
      TimetableDayLocMode.pos => pos.l10n(),
      TimetableDayLocMode.date => $key.currentContext!.formatYmdWeekText(date),
    };
  }
  Map<String, dynamic> toJson() => _$TimetableDayLocToJson(this);

  factory TimetableDayLoc.fromJson(Map<String, dynamic> json) => _$TimetableDayLocFromJson(json);

  SitTimetableDay? resolveDay(SitTimetableEntity entity) {
    return switch(mode){
      TimetableDayLocMode.pos => entity.weeks[pos.weekIndex].days[pos.weekday.index],
      TimetableDayLocMode.date => entity.getDayOn(date),
    };
  }

  @override
  bool operator ==(Object other) {
    return other is TimetableDayLoc &&
        runtimeType == other.runtimeType &&
        mode == other.mode &&
        dateInternal == other.dateInternal &&
        posInternal == other.posInternal;
  }

  @override
  int get hashCode => Object.hash(mode, pos, dateInternal);

  @override
  String toString() {
    return switch (mode) {
      TimetableDayLocMode.pos => pos,
      TimetableDayLocMode.date => date,
    }
        .toString();
  }
}
