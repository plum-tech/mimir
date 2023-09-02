// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimetableMetaLegacy _$TimetableMetaLegacyFromJson(Map<String, dynamic> json) =>
    TimetableMetaLegacy()
      ..name = json['name'] as String
      ..description = json['description'] as String
      ..startDate = DateTime.parse(json['startDate'] as String)
      ..schoolYear = json['schoolYear'] as int
      ..semester = json['semester'] as int;

Map<String, dynamic> _$TimetableMetaLegacyToJson(
        TimetableMetaLegacy instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'startDate': instance.startDate.toIso8601String(),
      'schoolYear': instance.schoolYear,
      'semester': instance.semester,
    };
