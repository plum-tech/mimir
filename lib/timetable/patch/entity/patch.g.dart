// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patch.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$TimetablePatchSetCWProxy {
  TimetablePatchSet name(String name);

  TimetablePatchSet patches(List<TimetablePatch> patches);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TimetablePatchSet(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TimetablePatchSet(...).copyWith(id: 12, name: "My name")
  /// ````
  TimetablePatchSet call({
    String? name,
    List<TimetablePatch>? patches,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfTimetablePatchSet.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfTimetablePatchSet.copyWith.fieldName(...)`
class _$TimetablePatchSetCWProxyImpl implements _$TimetablePatchSetCWProxy {
  const _$TimetablePatchSetCWProxyImpl(this._value);

  final TimetablePatchSet _value;

  @override
  TimetablePatchSet name(String name) => this(name: name);

  @override
  TimetablePatchSet patches(List<TimetablePatch> patches) => this(patches: patches);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TimetablePatchSet(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TimetablePatchSet(...).copyWith(id: 12, name: "My name")
  /// ````
  TimetablePatchSet call({
    Object? name = const $CopyWithPlaceholder(),
    Object? patches = const $CopyWithPlaceholder(),
  }) {
    return TimetablePatchSet(
      name: name == const $CopyWithPlaceholder() || name == null
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      patches: patches == const $CopyWithPlaceholder() || patches == null
          ? _value.patches
          // ignore: cast_nullable_to_non_nullable
          : patches as List<TimetablePatch>,
    );
  }
}

extension $TimetablePatchSetCopyWith on TimetablePatchSet {
  /// Returns a callable class that can be used as follows: `instanceOfTimetablePatchSet.copyWith(...)` or like so:`instanceOfTimetablePatchSet.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$TimetablePatchSetCWProxy get copyWith => _$TimetablePatchSetCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimetablePatchSet _$TimetablePatchSetFromJson(Map<String, dynamic> json) => TimetablePatchSet(
      name: json['name'] as String,
      patches:
          (json['patches'] as List<dynamic>).map((e) => TimetablePatch.fromJson(e as Map<String, dynamic>)).toList(),
    );

Map<String, dynamic> _$TimetablePatchSetToJson(TimetablePatchSet instance) => <String, dynamic>{
      'name': instance.name,
      'patches': instance.patches,
    };

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
  TimetablePatchType.unknown: 'unknown',
  TimetablePatchType.moveDay: 'moveDay',
  TimetablePatchType.removeDay: 'removeDay',
  TimetablePatchType.copyDay: 'copyDay',
  TimetablePatchType.swapDays: 'swapDays',
};
