// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Course _$CourseFromJson(Map<String, dynamic> json) => Course(
      json['kcmc'] as String,
      Course._day2Index(json['xqjmc'] as String),
      Course._time2Index(json['jcs'] as String),
      json['cdmc'] as String,
      json['xm'] == null ? ['空'] : Course._string2Vec(json['xm'] as String),
      json['xqmc'] as String,
      Course._string2Double(json['xf'] as String),
      Course._stringToInt(json['zxs'] as String),
      Course._trim(json['jxbmc'] as String),
      json['kch'] as String,
      json['zcd'] as String,
    );

CourseRaw _$CourseRawFromJson(Map<String, dynamic> json) => CourseRaw(
      json['kcmc'] as String,
      json['xqjmc'] as String,
      json['jcs'] as String,
      json['zcd'] as String,
      json['cdmc'] as String,
      json['xm'] as String? ?? '',
      json['xqmc'] as String,
      json['xf'] as String,
      json['zxs'] as String,
      json['jxbmc'] as String,
      json['kch'] as String,
    );

Map<String, dynamic> _$CourseRawToJson(CourseRaw instance) => <String, dynamic>{
      'kcmc': instance.courseName,
      'xqjmc': instance.weekDayText,
      'jcs': instance.timeslotsText,
      'zcd': instance.weekText,
      'cdmc': instance.place,
      'xm': instance.teachers,
      'xqmc': instance.campus,
      'xf': instance.courseCredit,
      'zxs': instance.creditHour,
      'jxbmc': instance.classCode,
      'kch': instance.courseCode,
    };
