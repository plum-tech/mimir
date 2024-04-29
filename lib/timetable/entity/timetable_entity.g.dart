// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timetable_entity.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SitTimetableLessonSlotCWProxy {
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// SitTimetableLessonSlot(...).copyWith(id: 12, name: "My name")
  /// ````
  SitTimetableLessonSlot call({
    List<SitTimetableLessonPart>? lessons,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSitTimetableLessonSlot.copyWith(...)`.
class _$SitTimetableLessonSlotCWProxyImpl implements _$SitTimetableLessonSlotCWProxy {
  const _$SitTimetableLessonSlotCWProxyImpl(this._value);

  final SitTimetableLessonSlot _value;

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// SitTimetableLessonSlot(...).copyWith(id: 12, name: "My name")
  /// ````
  SitTimetableLessonSlot call({
    Object? lessons = const $CopyWithPlaceholder(),
  }) {
    return SitTimetableLessonSlot(
      lessons: lessons == const $CopyWithPlaceholder() || lessons == null
          ? _value.lessons
          // ignore: cast_nullable_to_non_nullable
          : lessons as List<SitTimetableLessonPart>,
    );
  }
}

extension $SitTimetableLessonSlotCopyWith on SitTimetableLessonSlot {
  /// Returns a callable class that can be used as follows: `instanceOfSitTimetableLessonSlot.copyWith(...)`.
  // ignore: library_private_types_in_public_api
  _$SitTimetableLessonSlotCWProxy get copyWith => _$SitTimetableLessonSlotCWProxyImpl(this);
}

abstract class _$SitTimetableLessonPartCWProxy {
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// SitTimetableLessonPart(...).copyWith(id: 12, name: "My name")
  /// ````
  SitTimetableLessonPart call({
    SitTimetableLesson? type,
    int? index,
    DateTime? startTime,
    DateTime? endTime,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSitTimetableLessonPart.copyWith(...)`.
class _$SitTimetableLessonPartCWProxyImpl implements _$SitTimetableLessonPartCWProxy {
  const _$SitTimetableLessonPartCWProxyImpl(this._value);

  final SitTimetableLessonPart _value;

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// SitTimetableLessonPart(...).copyWith(id: 12, name: "My name")
  /// ````
  SitTimetableLessonPart call({
    Object? type = const $CopyWithPlaceholder(),
    Object? index = const $CopyWithPlaceholder(),
    Object? startTime = const $CopyWithPlaceholder(),
    Object? endTime = const $CopyWithPlaceholder(),
  }) {
    return SitTimetableLessonPart(
      type: type == const $CopyWithPlaceholder() || type == null
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as SitTimetableLesson,
      index: index == const $CopyWithPlaceholder() || index == null
          ? _value.index
          // ignore: cast_nullable_to_non_nullable
          : index as int,
      startTime: startTime == const $CopyWithPlaceholder() || startTime == null
          ? _value.startTime
          // ignore: cast_nullable_to_non_nullable
          : startTime as DateTime,
      endTime: endTime == const $CopyWithPlaceholder() || endTime == null
          ? _value.endTime
          // ignore: cast_nullable_to_non_nullable
          : endTime as DateTime,
    );
  }
}

extension $SitTimetableLessonPartCopyWith on SitTimetableLessonPart {
  /// Returns a callable class that can be used as follows: `instanceOfSitTimetableLessonPart.copyWith(...)`.
  // ignore: library_private_types_in_public_api
  _$SitTimetableLessonPartCWProxy get copyWith => _$SitTimetableLessonPartCWProxyImpl(this);
}
