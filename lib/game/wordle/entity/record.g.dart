// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordWordle _$RecordWordleFromJson(Map<String, dynamic> json) => RecordWordle(
      uuid: json['uuid'] as String? ?? genUuidV4(),
      ts: DateTime.parse(json['ts'] as String),
      result: $enumDecode(_$GameResultEnumMap, json['result']),
      playtime: Duration(microseconds: (json['playtime'] as num).toInt()),
      vocabulary: WordleVocabulary.fromJson(json['vocabulary'] as String),
      attempts: (json['attempts'] as List<dynamic>).map((e) => e as String).toList(),
      blueprint: json['blueprint'] as String,
    );

Map<String, dynamic> _$RecordWordleToJson(RecordWordle instance) => <String, dynamic>{
      'uuid': instance.uuid,
      'ts': instance.ts.toIso8601String(),
      'result': _$GameResultEnumMap[instance.result]!,
      'playtime': instance.playtime.inMicroseconds,
      'attempts': instance.attempts,
      'vocabulary': instance.vocabulary,
      'blueprint': instance.blueprint,
    };

const _$GameResultEnumMap = {
  GameResult.victory: 'victory',
  GameResult.gameOver: 'gameOver',
};
