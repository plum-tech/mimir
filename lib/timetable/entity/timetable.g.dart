// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timetable.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SitTimetableCWProxy {
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// SitTimetable(...).copyWith(id: 12, name: "My name")
  /// ````
  SitTimetable call({
    Map<String, SitCourse>? courses,
    int? lastCourseKey,
    String? name,
    DateTime? startDate,
    int? schoolYear,
    Semester? semester,
    String? signature,
    int? version,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSitTimetable.copyWith(...)`.
class _$SitTimetableCWProxyImpl implements _$SitTimetableCWProxy {
  const _$SitTimetableCWProxyImpl(this._value);

  final SitTimetable _value;

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// SitTimetable(...).copyWith(id: 12, name: "My name")
  /// ````
  SitTimetable call({
    Object? courses = const $CopyWithPlaceholder(),
    Object? lastCourseKey = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? startDate = const $CopyWithPlaceholder(),
    Object? schoolYear = const $CopyWithPlaceholder(),
    Object? semester = const $CopyWithPlaceholder(),
    Object? signature = const $CopyWithPlaceholder(),
    Object? version = const $CopyWithPlaceholder(),
  }) {
    return SitTimetable(
      courses: courses == const $CopyWithPlaceholder() || courses == null
          ? _value.courses
          // ignore: cast_nullable_to_non_nullable
          : courses as Map<String, SitCourse>,
      lastCourseKey: lastCourseKey == const $CopyWithPlaceholder() || lastCourseKey == null
          ? _value.lastCourseKey
          // ignore: cast_nullable_to_non_nullable
          : lastCourseKey as int,
      name: name == const $CopyWithPlaceholder() || name == null
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      startDate: startDate == const $CopyWithPlaceholder() || startDate == null
          ? _value.startDate
          // ignore: cast_nullable_to_non_nullable
          : startDate as DateTime,
      schoolYear: schoolYear == const $CopyWithPlaceholder() || schoolYear == null
          ? _value.schoolYear
          // ignore: cast_nullable_to_non_nullable
          : schoolYear as int,
      semester: semester == const $CopyWithPlaceholder() || semester == null
          ? _value.semester
          // ignore: cast_nullable_to_non_nullable
          : semester as Semester,
      signature: signature == const $CopyWithPlaceholder() || signature == null
          ? _value.signature
          // ignore: cast_nullable_to_non_nullable
          : signature as String,
      version: version == const $CopyWithPlaceholder() || version == null
          ? _value.version
          // ignore: cast_nullable_to_non_nullable
          : version as int,
    );
  }
}

extension $SitTimetableCopyWith on SitTimetable {
  /// Returns a callable class that can be used as follows: `instanceOfSitTimetable.copyWith(...)`.
  // ignore: library_private_types_in_public_api
  _$SitTimetableCWProxy get copyWith => _$SitTimetableCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SitTimetable _$SitTimetableFromJson(Map<String, dynamic> json) => SitTimetable(
      courses: (json['courses'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, SitCourse.fromJson(e as Map<String, dynamic>)),
      ),
      lastCourseKey: json['lastCourseKey'] as int,
      name: json['name'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      schoolYear: json['schoolYear'] as int,
      semester: $enumDecode(_$SemesterEnumMap, json['semester']),
      signature: json['signature'] as String? ?? "",
      version: json['version'] as int? ?? 1,
    );

Map<String, dynamic> _$SitTimetableToJson(SitTimetable instance) => <String, dynamic>{
      'name': instance.name,
      'startDate': instance.startDate.toIso8601String(),
      'schoolYear': instance.schoolYear,
      'semester': _$SemesterEnumMap[instance.semester]!,
      'lastCourseKey': instance.lastCourseKey,
      'signature': instance.signature,
      'courses': instance.courses,
      'version': instance.version,
    };

const _$SemesterEnumMap = {
  Semester.all: 'all',
  Semester.term1: 'term1',
  Semester.term2: 'term2',
};

SitCourse _$SitCourseFromJson(Map<String, dynamic> json) => SitCourse(
      courseKey: json['courseKey'] as int,
      courseName: json['courseName'] as String,
      courseCode: json['courseCode'] as String,
      classCode: json['classCode'] as String,
      campus: $enumDecode(_$CampusEnumMap, json['campus'], unknownValue: Campus.fengxian),
      place: json['place'] as String,
      weekIndices: TimetableWeekIndices.fromJson(json['weekIndices'] as Map<String, dynamic>),
      timeslots: _$recordConvert(
        json['timeslots'],
        ($jsonValue) => (
          end: $jsonValue['end'] as int,
          start: $jsonValue['start'] as int,
        ),
      ),
      courseCredit: (json['courseCredit'] as num).toDouble(),
      dayIndex: json['dayIndex'] as int,
      teachers: (json['teachers'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$SitCourseToJson(SitCourse instance) => <String, dynamic>{
      'courseKey': instance.courseKey,
      'courseName': instance.courseName,
      'courseCode': instance.courseCode,
      'classCode': instance.classCode,
      'campus': _$CampusEnumMap[instance.campus]!,
      'place': instance.place,
      'weekIndices': instance.weekIndices,
      'timeslots': {
        'end': instance.timeslots.end,
        'start': instance.timeslots.start,
      },
      'courseCredit': instance.courseCredit,
      'dayIndex': instance.dayIndex,
      'teachers': instance.teachers,
    };

const _$CampusEnumMap = {
  Campus.fengxian: 'fengxian',
  Campus.xuhui: 'xuhui',
};

$Rec _$recordConvert<$Rec>(
  Object? value,
  $Rec Function(Map) convert,
) =>
    convert(value as Map<String, dynamic>);

TimetableWeekIndex _$TimetableWeekIndexFromJson(Map<String, dynamic> json) => TimetableWeekIndex(
      type: $enumDecode(_$TimetableWeekIndexTypeEnumMap, json['type']),
      range: _$recordConvert(
        json['range'],
        ($jsonValue) => (
          end: $jsonValue['end'] as int,
          start: $jsonValue['start'] as int,
        ),
      ),
    );

Map<String, dynamic> _$TimetableWeekIndexToJson(TimetableWeekIndex instance) => <String, dynamic>{
      'type': _$TimetableWeekIndexTypeEnumMap[instance.type]!,
      'range': {
        'end': instance.range.end,
        'start': instance.range.start,
      },
    };

const _$TimetableWeekIndexTypeEnumMap = {
  TimetableWeekIndexType.all: 'all',
  TimetableWeekIndexType.odd: 'odd',
  TimetableWeekIndexType.even: 'even',
};

TimetableWeekIndices _$TimetableWeekIndicesFromJson(Map<String, dynamic> json) => TimetableWeekIndices(
      (json['indices'] as List<dynamic>).map((e) => TimetableWeekIndex.fromJson(e as Map<String, dynamic>)).toList(),
    );

Map<String, dynamic> _$TimetableWeekIndicesToJson(TimetableWeekIndices instance) => <String, dynamic>{
      'indices': instance.indices,
    };
