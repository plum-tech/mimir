import 'dart:async';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/adaptive/foundation.dart';

import '../widgets/patch/move_day.dart';
import '../widgets/patch/remove_day.dart';
import 'loc.dart';
import 'timetable.dart';

part "patch.g.dart";

@JsonEnum(alwaysCreate: true)
enum TimetablePatchType {
  // addLesson,
  // removeLesson,
  // replaceLesson,
  // swapLesson,
  // moveLesson,
  // addDay,
  moveDay(TimetableMoveDayPatch.onCreate),
  removeDay(TimetableRemoveDayPatch.onCreate),
  copyDay(TimetableCopyDayPatch.onCreate),
  swapDay(TimetableSwapDayPatch.onCreate),
  ;

  final FutureOr<TimetablePatch?> Function(BuildContext context, SitTimetable timetable) onCreate;

  const TimetablePatchType(this.onCreate);

  String l10n() => name;
}

/// To opt-in [JsonSerializable], please specify `toJson` parameter to [TimetablePatch.toJson].
sealed class TimetablePatch {
  TimetablePatchType get type;

  const TimetablePatch();

  factory TimetablePatch.fromJson(Map<String, dynamic> json) {
    final type = $enumDecode(_$TimetablePatchTypeEnumMap, json["type"]);
    return switch (type) {
      // TimetablePatchType.addLesson => TimetableAddLessonPatch.fromJson(json),
      // TimetablePatchType.removeLesson => TimetableAddLessonPatch.fromJson(json),
      // TimetablePatchType.replaceLesson => TimetableAddLessonPatch.fromJson(json),
      // TimetablePatchType.swapLesson => TimetableAddLessonPatch.fromJson(json),
      // TimetablePatchType.moveLesson => TimetableAddLessonPatch.fromJson(json),
      // TimetablePatchType.addDay => TimetableAddLessonPatch.fromJson(json),
      TimetablePatchType.removeDay => TimetableRemoveDayPatch.fromJson(json),
      TimetablePatchType.swapDay => TimetableSwapDayPatch.fromJson(json),
      TimetablePatchType.moveDay => TimetableMoveDayPatch.fromJson(json),
      TimetablePatchType.copyDay => TimetableCopyDayPatch.fromJson(json),
    };
  }

  @mustCallSuper
  Map<String, dynamic> toJson() => _toJsonImpl()..["type"] = _$TimetablePatchTypeEnumMap[type];

  Map<String, dynamic> _toJsonImpl();

  Widget build(BuildContext context, SitTimetable timetable, ValueChanged<TimetablePatch> onChanged);
}

//
// @JsonSerializable()
// class TimetableAddLessonPatch extends TimetablePatch {
//   @override
//   final type = TimetablePatchType.addLesson;
//
//   const TimetableAddLessonPatch();
//
//   factory TimetableAddLessonPatch.fromJson(Map<String, dynamic> json) => _$TimetableAddLessonPatchFromJson(json);
//
//   @override
//   Map<String, dynamic> _toJsonImpl() => _$TimetableAddLessonPatchToJson(this);
// }

// @JsonSerializable()
// class TimetableRemoveLessonPatch extends TimetablePatch {
//   @override
//   final type = TimetablePatchType.removeLesson;
//
//   const TimetableRemoveLessonPatch();
//
//   factory TimetableRemoveLessonPatch.fromJson(Map<String, dynamic> json) => _$TimetableRemoveLessonPatchFromJson(json);
//
//   @override
//   Map<String, dynamic> _toJsonImpl() => _$TimetableRemoveLessonPatchToJson(this);
// }
//
// @JsonSerializable()
// class TimetableMoveLessonPatch extends TimetablePatch {
//   @override
//   final type = TimetablePatchType.moveLesson;
//
//   const TimetableMoveLessonPatch();
//
//   factory TimetableMoveLessonPatch.fromJson(Map<String, dynamic> json) => _$TimetableMoveLessonPatchFromJson(json);
//
//   @override
//   Map<String, dynamic> _toJsonImpl() => _$TimetableMoveLessonPatchToJson(this);
// }

@JsonSerializable()
class TimetableRemoveDayPatch extends TimetablePatch {
  @override
  TimetablePatchType get type => TimetablePatchType.removeDay;

  @JsonKey()
  final TimetableDayLoc loc;

  const TimetableRemoveDayPatch({
    required this.loc,
  });

  factory TimetableRemoveDayPatch.fromJson(Map<String, dynamic> json) => _$TimetableRemoveDayPatchFromJson(json);

  @override
  Map<String, dynamic> _toJsonImpl() => _$TimetableRemoveDayPatchToJson(this);

  @override
  Widget build(BuildContext context, SitTimetable timetable, ValueChanged<TimetableRemoveDayPatch> onChanged) {
    return TimetableRemoveDayPatchWidget(
      patch: this,
      timetable: timetable,
      onChanged: onChanged,
    );
  }

  static Future<TimetableRemoveDayPatch?> onCreate(BuildContext context, SitTimetable timetable) async {
    final patch = await context.show$Sheet$(
      (ctx) => TimetableRemoveDayPatchSheet(
        timetable: timetable,
        patch: null,
      ),
    );
    return patch;
  }
}

@JsonSerializable()
class TimetableMoveDayPatch extends TimetablePatch {
  @override
  TimetablePatchType get type => TimetablePatchType.moveDay;
  @JsonKey()
  final TimetableDayLoc source;
  @JsonKey()
  final TimetableDayLoc target;

  const TimetableMoveDayPatch({
    required this.source,
    required this.target,
  });

  factory TimetableMoveDayPatch.fromJson(Map<String, dynamic> json) => _$TimetableMoveDayPatchFromJson(json);

  @override
  Map<String, dynamic> _toJsonImpl() => _$TimetableMoveDayPatchToJson(this);

  @override
  Widget build(BuildContext context, SitTimetable timetable, ValueChanged<TimetableMoveDayPatch> onChanged) {
    return TimetableMoveDayPatchWidget(
      patch: this,
      timetable: timetable,
      onChanged: onChanged,
    );
  }

  static Future<TimetableMoveDayPatch?> onCreate(BuildContext context, SitTimetable timetable) async {
    final patch = await context.show$Sheet$(
      (ctx) => TimetableMoveDayPatchSheet(
        timetable: timetable,
        patch: null,
      ),
    );
    return patch;
  }
}

@JsonSerializable()
class TimetableSwapDayPatch extends TimetablePatch {
  @override
  TimetablePatchType get type => TimetablePatchType.swapDay;
  @JsonKey()
  final TimetableDayLoc a;
  @JsonKey()
  final TimetableDayLoc b;

  const TimetableSwapDayPatch({
    required this.a,
    required this.b,
  });

  factory TimetableSwapDayPatch.fromJson(Map<String, dynamic> json) => _$TimetableSwapDayPatchFromJson(json);

  @override
  Map<String, dynamic> _toJsonImpl() => _$TimetableSwapDayPatchToJson(this);

  @override
  Widget build(BuildContext context, SitTimetable timetable, ValueChanged<TimetableSwapDayPatch> onChanged) {
    return Card.filled(
      child: ListTile(
        title: "Swap day".text(),
      ),
    );
  }

  static Future<TimetableSwapDayPatch?> onCreate(BuildContext context, SitTimetable timetable) async {}
}

@JsonSerializable()
class TimetableCopyDayPatch extends TimetablePatch {
  @override
  TimetablePatchType get type => TimetablePatchType.copyDay;
  @JsonKey()
  final TimetableDayLoc source;
  @JsonKey()
  final TimetableDayLoc target;

  const TimetableCopyDayPatch({
    required this.source,
    required this.target,
  });

  factory TimetableCopyDayPatch.fromJson(Map<String, dynamic> json) => _$TimetableCopyDayPatchFromJson(json);

  @override
  Map<String, dynamic> _toJsonImpl() => _$TimetableCopyDayPatchToJson(this);

  @override
  Widget build(BuildContext context, SitTimetable timetable, ValueChanged<TimetableCopyDayPatch> onChanged) {
    return Card.filled(
      child: ListTile(
        title: "Copy day".text(),
      ),
    );
  }

  static Future<TimetableCopyDayPatch?> onCreate(BuildContext context, SitTimetable timetable) async {}
}

// factory .fromJson(Map<String, dynamic> json) => _$FromJson(json);
//
// Map<String, dynamic> toJson() => _$ToJson(this);
