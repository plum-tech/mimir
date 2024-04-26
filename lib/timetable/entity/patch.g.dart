// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimetableRemoveDayPatch _$TimetableRemoveDayPatchFromJson(Map<String, dynamic> json) => TimetableRemoveDayPatch(
      loc: TimetableDayLoc.fromJson(json['loc'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TimetableRemoveDayPatchToJson(TimetableRemoveDayPatch instance) => <String, dynamic>{
      'loc': instance.loc,
    };

TimetableMoveDayPatch _$TimetableMoveDayPatchFromJson(Map<String, dynamic> json) => TimetableMoveDayPatch(
      source: TimetableDayLoc.fromJson(json['source'] as Map<String, dynamic>),
      target: TimetableDayLoc.fromJson(json['target'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TimetableMoveDayPatchToJson(TimetableMoveDayPatch instance) => <String, dynamic>{
      'source': instance.source,
      'target': instance.target,
    };

TimetableSwapDayPatch _$TimetableSwapDayPatchFromJson(Map<String, dynamic> json) => TimetableSwapDayPatch(
      a: TimetableDayLoc.fromJson(json['a'] as Map<String, dynamic>),
      b: TimetableDayLoc.fromJson(json['b'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TimetableSwapDayPatchToJson(TimetableSwapDayPatch instance) => <String, dynamic>{
      'a': instance.a,
      'b': instance.b,
    };

TimetableCopyDayPatch _$TimetableCopyDayPatchFromJson(Map<String, dynamic> json) => TimetableCopyDayPatch(
      source: TimetableDayLoc.fromJson(json['source'] as Map<String, dynamic>),
      target: TimetableDayLoc.fromJson(json['target'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TimetableCopyDayPatchToJson(TimetableCopyDayPatch instance) => <String, dynamic>{
      'source': instance.source,
      'target': instance.target,
    };

const _$TimetablePatchTypeEnumMap = {
  TimetablePatchType.moveDay: 'moveDay',
  TimetablePatchType.removeDay: 'removeDay',
  TimetablePatchType.copyDay: 'copyDay',
  TimetablePatchType.swapDay: 'swapDay',
};
