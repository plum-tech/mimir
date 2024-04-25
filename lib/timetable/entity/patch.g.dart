// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimetableRemoveDayPatch _$TimetableRemoveDayPatchFromJson(Map<String, dynamic> json) => TimetableRemoveDayPatch(
      loc: TimetableLoc.fromJson(json['loc'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TimetableRemoveDayPatchToJson(TimetableRemoveDayPatch instance) => <String, dynamic>{
      'loc': instance.loc,
    };

TimetableMoveDayPatch _$TimetableMoveDayPatchFromJson(Map<String, dynamic> json) => TimetableMoveDayPatch();

Map<String, dynamic> _$TimetableMoveDayPatchToJson(TimetableMoveDayPatch instance) => <String, dynamic>{};

TimetableSwapDayPatch _$TimetableSwapDayPatchFromJson(Map<String, dynamic> json) => TimetableSwapDayPatch();

Map<String, dynamic> _$TimetableSwapDayPatchToJson(TimetableSwapDayPatch instance) => <String, dynamic>{};

TimetableCopyDayPatch _$TimetableCopyDayPatchFromJson(Map<String, dynamic> json) => TimetableCopyDayPatch();

Map<String, dynamic> _$TimetableCopyDayPatchToJson(TimetableCopyDayPatch instance) => <String, dynamic>{};

const _$TimetablePatchTypeEnumMap = {
  TimetablePatchType.moveDay: 'moveDay',
  TimetablePatchType.removeDay: 'removeDay',
  TimetablePatchType.copyDay: 'copyDay',
  TimetablePatchType.swapDay: 'swapDay',
};
