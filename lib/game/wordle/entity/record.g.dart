// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordWordle _$RecordWordleFromJson(Map<String, dynamic> json) => RecordWordle(
      ts: DateTime.parse(json['ts'] as String),
    );

Map<String, dynamic> _$RecordWordleToJson(RecordWordle instance) => <String, dynamic>{
      'ts': instance.ts.toIso8601String(),
    };
