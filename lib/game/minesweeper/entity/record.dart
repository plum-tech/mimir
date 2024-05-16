import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:sit/game/entity/game_result.dart';
import 'package:sit/game/entity/record.dart';

import 'blueprint.dart';
import 'board.dart';
import 'mode.dart';

part "record.g.dart";

@JsonSerializable()
@immutable
class RecordMinesweeper extends GameRecord {
  final GameResult result;
  final int rows;
  final int columns;
  final int mines;
  final Duration playtime;
  final GameModeMinesweeper mode;
  final String blueprint;

  const RecordMinesweeper({
    required super.ts,
    required this.result,
    required this.rows,
    required this.columns,
    required this.mines,
    required this.playtime,
    required this.mode,
    required this.blueprint,
  });

  factory RecordMinesweeper.createFrom({
    required CellBoard board,
    required Duration playtime,
    required GameModeMinesweeper mode,
    required GameResult result,
  }) {
    final blueprint = BlueprintMinesweeper(builder: board.toBuilder(), mode: mode);
    return RecordMinesweeper(
      ts: DateTime.now(),
      rows: board.rows,
      columns: board.columns,
      mines: board.mines,
      playtime: playtime,
      mode: mode,
      blueprint: blueprint.build(),
      result: result,
    );
  }

  Map<String, dynamic> toJson() => _$RecordMinesweeperToJson(this);

  factory RecordMinesweeper.fromJson(Map<String, dynamic> json) => _$RecordMinesweeperFromJson(json);
}
