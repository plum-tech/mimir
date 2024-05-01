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
