// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordMinesweeper _$RecordMinesweeperFromJson(Map<String, dynamic> json) => RecordMinesweeper(
      ts: DateTime.parse(json['ts'] as String),
      result: $enumDecode(_$GameResultEnumMap, json['result']),
      rows: (json['rows'] as num).toInt(),
      columns: (json['columns'] as num).toInt(),
      mines: (json['mines'] as num).toInt(),
      playtime: Duration(microseconds: (json['playtime'] as num).toInt()),
      mode: GameModeMinesweeper.fromJson(json['mode'] as String),
      blueprint: json['blueprint'] as String,
    );

Map<String, dynamic> _$RecordMinesweeperToJson(RecordMinesweeper instance) => <String, dynamic>{
      'ts': instance.ts.toIso8601String(),
      'result': _$GameResultEnumMap[instance.result]!,
      'rows': instance.rows,
      'columns': instance.columns,
      'mines': instance.mines,
      'playtime': instance.playtime.inMicroseconds,
      'mode': instance.mode,
      'blueprint': instance.blueprint,
    };

const _$GameResultEnumMap = {
  GameResult.victory: 'victory',
  GameResult.gameOver: 'gameOver',
};
