import 'package:json_annotation/json_annotation.dart';
import 'package:sit/game/entity/game_result.dart';
import 'package:sit/game/entity/record.dart';
import 'package:sit/game/sudoku/entity/board.dart';

import 'blueprint.dart';
import 'mode.dart';

part "record.g.dart";

@JsonSerializable()
class RecordSudoku extends GameRecord {
  final GameResult result;
  final Duration playTime;
  final GameModeSudoku mode;
  final int blanks;
  final String blueprint;

  const RecordSudoku({
    required super.ts,
    required this.result,
    required this.playTime,
    required this.mode,
    required this.blanks,
    required this.blueprint,
  });

  factory RecordSudoku.createFrom({
    required SudokuBoard board,
    required Duration playtime,
    required GameModeSudoku mode,
    required GameResult result,
  }) {
    final blueprint = BlueprintSudoku(
      board: board,
      mode: mode,
    );
    return RecordSudoku(
      ts: DateTime.now(),
      result: result,
      mode: mode,
      playTime: playtime,
      blueprint: blueprint.build(),
      blanks: mode.blanks,
    );
  }

  Map<String, dynamic> toJson() => _$RecordSudokuToJson(this);

  factory RecordSudoku.fromJson(Map<String, dynamic> json) => _$RecordSudokuFromJson(json);
}
