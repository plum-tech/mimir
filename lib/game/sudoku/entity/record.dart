import 'package:json_annotation/json_annotation.dart';
import 'package:sit/game/entity/record.dart';

import 'mode.dart';
part "record.g.dart";

@JsonSerializable()
class RecordSudoku extends GameRecord {
  final Duration playTime;
  final GameModeSudoku mode;

  const RecordSudoku({
    required super.ts,
    required this.playTime,
    required this.mode,
  });

  Map<String, dynamic> toJson() => _$RecordSudokuToJson(this);

  factory RecordSudoku.fromJson(Map<String, dynamic> json) => _$RecordSudokuFromJson(json);
}
