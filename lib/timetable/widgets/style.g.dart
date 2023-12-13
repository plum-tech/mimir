// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'style.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CourseCellStyleCWProxy {
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// CourseCellStyle(...).copyWith(id: 12, name: "My name")
  /// ````
  CourseCellStyle call({
    bool? showTeachers,
    bool? grayOutTakenLessons,
    bool? harmonizeWithThemeColor,
    double? alpha,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCourseCellStyle.copyWith(...)`.
class _$CourseCellStyleCWProxyImpl implements _$CourseCellStyleCWProxy {
  const _$CourseCellStyleCWProxyImpl(this._value);

  final CourseCellStyle _value;

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// CourseCellStyle(...).copyWith(id: 12, name: "My name")
  /// ````
  CourseCellStyle call({
    Object? showTeachers = const $CopyWithPlaceholder(),
    Object? grayOutTakenLessons = const $CopyWithPlaceholder(),
    Object? harmonizeWithThemeColor = const $CopyWithPlaceholder(),
    Object? alpha = const $CopyWithPlaceholder(),
  }) {
    return CourseCellStyle(
      showTeachers: showTeachers == const $CopyWithPlaceholder() || showTeachers == null
          ? _value.showTeachers
          // ignore: cast_nullable_to_non_nullable
          : showTeachers as bool,
      grayOutTakenLessons: grayOutTakenLessons == const $CopyWithPlaceholder() || grayOutTakenLessons == null
          ? _value.grayOutTakenLessons
          // ignore: cast_nullable_to_non_nullable
          : grayOutTakenLessons as bool,
      harmonizeWithThemeColor:
          harmonizeWithThemeColor == const $CopyWithPlaceholder() || harmonizeWithThemeColor == null
              ? _value.harmonizeWithThemeColor
              // ignore: cast_nullable_to_non_nullable
              : harmonizeWithThemeColor as bool,
      alpha: alpha == const $CopyWithPlaceholder() || alpha == null
          ? _value.alpha
          // ignore: cast_nullable_to_non_nullable
          : alpha as double,
    );
  }
}

extension $CourseCellStyleCopyWith on CourseCellStyle {
  /// Returns a callable class that can be used as follows: `instanceOfCourseCellStyle.copyWith(...)`.
  // ignore: library_private_types_in_public_api
  _$CourseCellStyleCWProxy get copyWith => _$CourseCellStyleCWProxyImpl(this);
}

abstract class _$TimetableStyleDataCWProxy {
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// TimetableStyleData(...).copyWith(id: 12, name: "My name")
  /// ````
  TimetableStyleData call({
    TimetablePalette? platte,
    CourseCellStyle? cellStyle,
    BackgroundImage? background,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfTimetableStyleData.copyWith(...)`.
class _$TimetableStyleDataCWProxyImpl implements _$TimetableStyleDataCWProxy {
  const _$TimetableStyleDataCWProxyImpl(this._value);

  final TimetableStyleData _value;

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// TimetableStyleData(...).copyWith(id: 12, name: "My name")
  /// ````
  TimetableStyleData call({
    Object? platte = const $CopyWithPlaceholder(),
    Object? cellStyle = const $CopyWithPlaceholder(),
    Object? background = const $CopyWithPlaceholder(),
  }) {
    return TimetableStyleData(
      platte: platte == const $CopyWithPlaceholder() || platte == null
          ? _value.platte
          // ignore: cast_nullable_to_non_nullable
          : platte as TimetablePalette,
      cellStyle: cellStyle == const $CopyWithPlaceholder() || cellStyle == null
          ? _value.cellStyle
          // ignore: cast_nullable_to_non_nullable
          : cellStyle as CourseCellStyle,
      background: background == const $CopyWithPlaceholder() || background == null
          ? _value.background
          // ignore: cast_nullable_to_non_nullable
          : background as BackgroundImage,
    );
  }
}

extension $TimetableStyleDataCopyWith on TimetableStyleData {
  /// Returns a callable class that can be used as follows: `instanceOfTimetableStyleData.copyWith(...)`.
  // ignore: library_private_types_in_public_api
  _$TimetableStyleDataCWProxy get copyWith => _$TimetableStyleDataCWProxyImpl(this);
}
