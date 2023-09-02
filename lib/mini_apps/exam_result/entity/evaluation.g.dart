// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'evaluation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourseToEvaluate _$CourseToEvaluateFromJson(Map<String, dynamic> json) =>
    CourseToEvaluate(
      json['jzgmc'] as String,
      json['kch_id'] as String,
      json['kcmc'] as String,
      json['jxbmc'] as String,
      json['pjmbmcb_id'] as String? ?? '',
      json['jgh_id'] as String,
      json['jxb_id'] as String,
      json['pjzt'] as String,
      json['tjzt'] as String,
      json['xsdm'] as String,
      json['xsmc'] as String,
    );

Map<String, dynamic> _$CourseToEvaluateToJson(CourseToEvaluate instance) =>
    <String, dynamic>{
      'jzgmc': instance.teacher,
      'jgh_id': instance.teacherId,
      'kch_id': instance.courseId,
      'kcmc': instance.courseName,
      'jxbmc': instance.dynClassId,
      'jxb_id': instance.innerClassId,
      'pjmbmcb_id': instance.evaluationId,
      'pjzt': instance.evaluatingStatus,
      'tjzt': instance.submittingStatus,
      'xsdm': instance.subTypeId,
      'xsmc': instance.subType,
    };
