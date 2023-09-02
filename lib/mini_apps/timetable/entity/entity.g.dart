// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SitTimetable _$SitTimetableFromJson(Map<String, dynamic> json) => SitTimetable(
      (json['weeks'] as List<dynamic>)
          .map((e) => e == null
              ? null
              : SitTimetableWeek.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['courseKey2Entity'] as List<dynamic>)
          .map((e) => SitCourse.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['courseKeyCounter'] as int,
    )
      ..id = json['id'] as String
      ..name = json['name'] as String
      ..description = json['description'] as String
      ..startDate = DateTime.parse(json['startDate'] as String)
      ..schoolYear = json['schoolYear'] as int
      ..semester = json['semester'] as int;

Map<String, dynamic> _$SitTimetableToJson(SitTimetable instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'startDate': instance.startDate.toIso8601String(),
      'schoolYear': instance.schoolYear,
      'semester': instance.semester,
      'weeks': instance.weeks,
      'courseKey2Entity': instance.courseKey2Entity,
      'courseKeyCounter': instance.courseKeyCounter,
    };

SitTimetableWeek _$SitTimetableWeekFromJson(Map<String, dynamic> json) =>
    SitTimetableWeek(
      (json['days'] as List<dynamic>)
          .map((e) => SitTimetableDay.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SitTimetableWeekToJson(SitTimetableWeek instance) =>
    <String, dynamic>{
      'days': instance.days,
    };

SitTimetableDay _$SitTimetableDayFromJson(Map<String, dynamic> json) =>
    SitTimetableDay(
      (json['timeslots2Lessons'] as List<dynamic>)
          .map((e) => (e as List<dynamic>)
              .map(
                  (e) => SitTimetableLesson.fromJson(e as Map<String, dynamic>))
              .toList())
          .toList(),
    );

Map<String, dynamic> _$SitTimetableDayToJson(SitTimetableDay instance) =>
    <String, dynamic>{
      'timeslots2Lessons': instance.timeslots2Lessons,
    };

SitTimetableLesson _$SitTimetableLessonFromJson(Map<String, dynamic> json) =>
    SitTimetableLesson(
      json['startIndex'] as int,
      json['endIndex'] as int,
      json['courseKey'] as int,
    );

Map<String, dynamic> _$SitTimetableLessonToJson(SitTimetableLesson instance) =>
    <String, dynamic>{
      'startIndex': instance.startIndex,
      'endIndex': instance.endIndex,
      'courseKey': instance.courseKey,
    };

SitCourse _$SitCourseFromJson(Map<String, dynamic> json) => SitCourse(
      json['courseKey'] as int,
      json['courseName'] as String,
      json['courseCode'] as String,
      json['classCode'] as String,
      json['campus'] as String,
      json['place'] as String,
      json['iconName'] as String,
      (json['rangedWeekNumbers'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      json['timeslots'] as String,
      (json['courseCredit'] as num).toDouble(),
      json['creditHour'] as int,
      json['dayIndex'] as int,
      (json['teachers'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$SitCourseToJson(SitCourse instance) => <String, dynamic>{
      'courseKey': instance.courseKey,
      'courseName': instance.courseName,
      'courseCode': instance.courseCode,
      'classCode': instance.classCode,
      'campus': instance.campus,
      'place': instance.place,
      'iconName': instance.iconName,
      'rangedWeekNumbers': instance.rangedWeekNumbers,
      'timeslots': instance.timeslots,
      'courseCredit': instance.courseCredit,
      'creditHour': instance.creditHour,
      'dayIndex': instance.dayIndex,
      'teachers': instance.teachers,
    };
