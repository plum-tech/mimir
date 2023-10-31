// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timetable.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SitTimetable _$SitTimetableFromJson(Map<String, dynamic> json) => SitTimetable(
      courseKey2Entity: (json['courseKey2Entity'] as List<dynamic>)
          .map((e) => SitCourse.fromJson(e as Map<String, dynamic>))
          .toList(),
      courseKeyCounter: json['courseKeyCounter'] as int,
      name: json['name'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      schoolYear: json['schoolYear'] as int,
      semester: $enumDecode(_$SemesterEnumMap, json['semester']),
    );

Map<String, dynamic> _$SitTimetableToJson(SitTimetable instance) => <String, dynamic>{
      'name': instance.name,
      'startDate': instance.startDate.toIso8601String(),
      'schoolYear': instance.schoolYear,
      'semester': _$SemesterEnumMap[instance.semester]!,
      'courseKeyCounter': instance.courseKeyCounter,
      'courseKey2Entity': instance.courseKey2Entity,
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
      weekIndices: _weekIndicesFromJson(json['weekIndices'] as List),
      timeslots: rangeFromString(json['timeslots'] as String),
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
      'weekIndices': _weekIndicesToJson(instance.weekIndices),
      'timeslots': rangeToString(instance.timeslots),
      'courseCredit': instance.courseCredit,
      'dayIndex': instance.dayIndex,
      'teachers': instance.teachers,
    };

const _$CampusEnumMap = {
  Campus.fengxian: 'fengxian',
  Campus.xuhui: 'xuhui',
};
