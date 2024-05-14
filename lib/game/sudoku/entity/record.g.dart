// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordSudoku _$RecordSudokuFromJson(Map<String, dynamic> json) => RecordSudoku(
      ts: DateTime.parse(json['ts'] as String),
      playTime: Duration(microseconds: (json['playTime'] as num).toInt()),
      mode: GameModeSudoku.fromJson(json['mode'] as String),
    );

Map<String, dynamic> _$RecordSudokuToJson(RecordSudoku instance) => <String, dynamic>{
      'ts': instance.ts.toIso8601String(),
      'playTime': instance.playTime.inMicroseconds,
      'mode': instance.mode,
    };
