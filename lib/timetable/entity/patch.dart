import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part "patch.g.dart";

@JsonEnum(alwaysCreate: true)
enum TimetablePatchType {
  addLesson,
  removeLesson,
  replaceLesson,
  swapLesson,
  moveLesson,
  addDay,
  removeDay,
  replaceDay,
  swapDay,
  moveDay,
  ;
}

/// To opt-in [JsonSerializable], please specify `toJson` parameter to [TimetablePatch.toJson].
abstract class TimetablePatch {
  TimetablePatchType get type;
  const TimetablePatch();
  factory TimetablePatch.fromJson(Map<String, dynamic> json) {
    final type = $enumDecode(_$TimetablePatchTypeEnumMap, json["type"]);
    return switch (type) {
      TimetablePatchType.addLesson => TimetableAddLessonPatch.fromJson(json),
      TimetablePatchType.removeLesson => TimetableAddLessonPatch.fromJson(json),
      TimetablePatchType.replaceLesson => TimetableAddLessonPatch.fromJson(json),
      TimetablePatchType.swapLesson => TimetableAddLessonPatch.fromJson(json),
      TimetablePatchType.moveLesson => TimetableAddLessonPatch.fromJson(json),
      TimetablePatchType.addDay => TimetableAddLessonPatch.fromJson(json),
      TimetablePatchType.removeDay => TimetableAddLessonPatch.fromJson(json),
      TimetablePatchType.replaceDay => TimetableAddLessonPatch.fromJson(json),
      TimetablePatchType.swapDay => TimetableAddLessonPatch.fromJson(json),
      TimetablePatchType.moveDay => TimetableAddLessonPatch.fromJson(json),
    };
  }

  @mustCallSuper
  Map<String, dynamic> toJson() => _toJsonImpl()..["type"] = _$TimetablePatchTypeEnumMap[type];

  Map<String, dynamic> _toJsonImpl();
}

@JsonSerializable()
class TimetableAddLessonPatch extends TimetablePatch {
  @override
  final type = TimetablePatchType.removeLesson;

  const TimetableAddLessonPatch();

  factory TimetableAddLessonPatch.fromJson(Map<String, dynamic> json) => _$TimetableAddLessonPatchFromJson(json);

  @override
  Map<String, dynamic> _toJsonImpl() => _$TimetableAddLessonPatchToJson(this);
}

@JsonSerializable()
class TimetableRemoveLessonPatch extends TimetablePatch {
  @override
  final type = TimetablePatchType.removeLesson;

  const TimetableRemoveLessonPatch();

  factory TimetableRemoveLessonPatch.fromJson(Map<String, dynamic> json) => _$TimetableRemoveLessonPatchFromJson(json);

  @override
  Map<String, dynamic> _toJsonImpl() => _$TimetableRemoveLessonPatchToJson(this);
}

@JsonSerializable()
class TimetableRemoveDayPatch extends TimetablePatch {
  @override
  final type = TimetablePatchType.removeDay;

  const TimetableRemoveDayPatch();

  factory TimetableRemoveDayPatch.fromJson(Map<String, dynamic> json) => _$TimetableRemoveDayPatchFromJson(json);

  @override
  Map<String, dynamic> _toJsonImpl() => _$TimetableRemoveDayPatchToJson(this);
}

@JsonSerializable()
class TimetableMoveLessonPatch extends TimetablePatch {
  @override
  final type = TimetablePatchType.moveLesson;

  const TimetableMoveLessonPatch();

  factory TimetableMoveLessonPatch.fromJson(Map<String, dynamic> json) => _$TimetableMoveLessonPatchFromJson(json);

  @override
  Map<String, dynamic> _toJsonImpl() => _$TimetableMoveLessonPatchToJson(this);
}

@JsonSerializable()
class TimetableMoveDayPatch extends TimetablePatch {
  @override
  final type = TimetablePatchType.moveDay;

  const TimetableMoveDayPatch();

  factory TimetableMoveDayPatch.fromJson(Map<String, dynamic> json) => _$TimetableMoveDayPatchFromJson(json);

  @override
  Map<String, dynamic> _toJsonImpl() => _$TimetableMoveDayPatchToJson(this);
}

// factory .fromJson(Map<String, dynamic> json) => _$FromJson(json);
//
// Map<String, dynamic> toJson() => _$ToJson(this);
