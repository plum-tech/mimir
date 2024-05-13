// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordMinesweeper _$RecordMinesweeperFromJson(Map<String, dynamic> json) => RecordMinesweeper(
      ts: DateTime.parse(json['ts'] as String),
      rows: (json['rows'] as num).toInt(),
      columns: (json['columns'] as num).toInt(),
      mines: (json['mines'] as num).toInt(),
      playTime: Duration(microseconds: (json['playTime'] as num).toInt()),
      mode: GameModeMinesweeper.fromJson(json['mode'] as String),
    );

Map<String, dynamic> _$RecordMinesweeperToJson(RecordMinesweeper instance) => <String, dynamic>{
      'ts': instance.ts.toIso8601String(),
      'rows': instance.rows,
      'columns': instance.columns,
      'mines': instance.mines,
      'playTime': instance.playTime.inMicroseconds,
      'mode': instance.mode,
    };
