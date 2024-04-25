// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Record2048 _$Record2048FromJson(Map<String, dynamic> json) => Record2048(
      ts: DateTime.parse(json['ts'] as String),
      score: (json['score'] as num).toInt(),
      maxNumber: (json['maxNumber'] as num).toInt(),
    );

Map<String, dynamic> _$Record2048ToJson(Record2048 instance) => <String, dynamic>{
      'ts': instance.ts.toIso8601String(),
      'score': instance.score,
      'maxNumber': instance.maxNumber,
    };
