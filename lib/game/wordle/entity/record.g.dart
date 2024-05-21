// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordWordle _$RecordWordleFromJson(Map<String, dynamic> json) => RecordWordle(
      ts: DateTime.parse(json['ts'] as String),
      result: $enumDecode(_$GameResultEnumMap, json['result']),
      playtime: Duration(microseconds: (json['playtime'] as num).toInt()),
      blueprint: json['blueprint'] as String,
      vocabulary: WordleVocabulary.fromJson(json['vocabulary'] as String),
    );

Map<String, dynamic> _$RecordWordleToJson(RecordWordle instance) => <String, dynamic>{
      'ts': instance.ts.toIso8601String(),
      'result': _$GameResultEnumMap[instance.result]!,
      'playtime': instance.playtime.inMicroseconds,
      'blueprint': instance.blueprint,
      'vocabulary': instance.vocabulary,
    };

const _$GameResultEnumMap = {
  GameResult.victory: 'victory',
  GameResult.gameOver: 'gameOver',
};
