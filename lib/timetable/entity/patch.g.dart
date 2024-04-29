// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimetableUnknownPatch _$TimetableUnknownPatchFromJson(Map<String, dynamic> json) => TimetableUnknownPatch(
      legacy: json['legacy'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$TimetableUnknownPatchToJson(TimetableUnknownPatch instance) => <String, dynamic>{
      'legacy': instance.legacy,
    };

TimetableRemoveDayPatch _$TimetableRemoveDayPatchFromJson(Map<String, dynamic> json) => TimetableRemoveDayPatch(
      all: (json['all'] as List<dynamic>).map((e) => TimetableDayLoc.fromJson(e as Map<String, dynamic>)).toList(),
    );

Map<String, dynamic> _$TimetableRemoveDayPatchToJson(TimetableRemoveDayPatch instance) => <String, dynamic>{
      'all': instance.all,
    };

TimetableMoveDayPatch _$TimetableMoveDayPatchFromJson(Map<String, dynamic> json) => TimetableMoveDayPatch(
      source: TimetableDayLoc.fromJson(json['source'] as Map<String, dynamic>),
      target: TimetableDayLoc.fromJson(json['target'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TimetableMoveDayPatchToJson(TimetableMoveDayPatch instance) => <String, dynamic>{
      'source': instance.source,
      'target': instance.target,
    };

TimetableCopyDayPatch _$TimetableCopyDayPatchFromJson(Map<String, dynamic> json) => TimetableCopyDayPatch(
      source: TimetableDayLoc.fromJson(json['source'] as Map<String, dynamic>),
      target: TimetableDayLoc.fromJson(json['target'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TimetableCopyDayPatchToJson(TimetableCopyDayPatch instance) => <String, dynamic>{
      'source': instance.source,
      'target': instance.target,
    };

TimetableSwapDaysPatch _$TimetableSwapDaysPatchFromJson(Map<String, dynamic> json) => TimetableSwapDaysPatch(
      a: TimetableDayLoc.fromJson(json['a'] as Map<String, dynamic>),
      b: TimetableDayLoc.fromJson(json['b'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TimetableSwapDaysPatchToJson(TimetableSwapDaysPatch instance) => <String, dynamic>{
      'a': instance.a,
      'b': instance.b,
    };

const _$TimetablePatchTypeEnumMap = {
  TimetablePatchType.moveDay: 'moveDay',
  TimetablePatchType.removeDay: 'removeDay',
  TimetablePatchType.copyDay: 'copyDay',
  TimetablePatchType.swapDays: 'swapDays',
  TimetablePatchType.unknown: 'unknown',
};
