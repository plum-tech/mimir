import 'package:json_annotation/json_annotation.dart';
import 'package:mimir/game/entity/game_result.dart';
import 'package:mimir/game/entity/record.dart';
import 'package:mimir/game/sudoku/entity/board.dart';
import 'package:uuid/uuid.dart';

import 'blueprint.dart';
import 'mode.dart';

part "record.g.dart";

@JsonSerializable()
class RecordSudoku extends GameRecord {
  final GameResult result;
  final Duration playtime;
  final GameModeSudoku mode;
  final int blanks;
  final String blueprint;

  RecordSudoku({
    required super.uuid,
    required super.ts,
    required this.result,
    required this.playtime,
    required this.mode,
    required this.blueprint,
  }) : blanks = mode.blanks;

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
      uuid: const Uuid().v4(),
      ts: DateTime.now(),
      result: result,
      mode: mode,
      playtime: playtime,
      blueprint: blueprint.build(),
    );
  }

  Map<String, dynamic> toJson() => _$RecordSudokuToJson(this);

  factory RecordSudoku.fromJson(Map<String, dynamic> json) => _$RecordSudokuFromJson(json);
}
