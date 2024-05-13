import 'package:json_annotation/json_annotation.dart';
import 'package:sit/game/entity/record.dart';

import 'mode.dart';

part "record.g.dart";

@JsonSerializable()
class RecordMinesweeper extends GameRecord {
  final int rows;
  final int columns;
  final int mines;
  final Duration playTime;
  final GameModeMinesweeper mode;

  const RecordMinesweeper({
    required super.ts,
    required this.rows,
    required this.columns,
    required this.mines,
    required this.playTime,
    required this.mode,
  });

  Map<String, dynamic> toJson() => _$RecordMinesweeperToJson(this);

  factory RecordMinesweeper.fromJson(Map<String, dynamic> json) => _$RecordMinesweeperFromJson(json);
}
