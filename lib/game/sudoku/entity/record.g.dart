// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordSudoku _$RecordSudokuFromJson(Map<String, dynamic> json) => RecordSudoku(
      uuid: json['uuid'] as String? ?? genUuidV4(),
      ts: DateTime.parse(json['ts'] as String),
      result: $enumDecode(_$GameResultEnumMap, json['result']),
      playtime: Duration(microseconds: (json['playtime'] as num).toInt()),
      mode: GameModeSudoku.fromJson(json['mode'] as String),
      blueprint: json['blueprint'] as String,
    );

Map<String, dynamic> _$RecordSudokuToJson(RecordSudoku instance) => <String, dynamic>{
      'uuid': instance.uuid,
      'ts': instance.ts.toIso8601String(),
      'result': _$GameResultEnumMap[instance.result]!,
      'playtime': instance.playtime.inMicroseconds,
      'mode': instance.mode,
      'blueprint': instance.blueprint,
    };

const _$GameResultEnumMap = {
  GameResult.victory: 'victory',
  GameResult.gameOver: 'gameOver',
};
