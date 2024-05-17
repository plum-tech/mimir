// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordSudoku _$RecordSudokuFromJson(Map<String, dynamic> json) => RecordSudoku(
      ts: DateTime.parse(json['ts'] as String),
      result: $enumDecode(_$GameResultEnumMap, json['result']),
      playTime: Duration(microseconds: (json['playTime'] as num).toInt()),
      mode: GameModeSudoku.fromJson(json['mode'] as String),
      blanks: (json['blanks'] as num).toInt(),
      blueprint: json['blueprint'] as String,
    );

Map<String, dynamic> _$RecordSudokuToJson(RecordSudoku instance) => <String, dynamic>{
      'ts': instance.ts.toIso8601String(),
      'result': _$GameResultEnumMap[instance.result]!,
      'playTime': instance.playTime.inMicroseconds,
      'mode': instance.mode,
      'blanks': instance.blanks,
      'blueprint': instance.blueprint,
    };

const _$GameResultEnumMap = {
  GameResult.victory: 'victory',
  GameResult.gameOver: 'gameOver',
};
