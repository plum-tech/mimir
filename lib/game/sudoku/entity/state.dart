import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meta/meta.dart';
import 'package:sit/game/entity/game_state.dart';

import 'board.dart';
import 'mode.dart';

part "state.g.dart";

@immutable
@JsonSerializable()
@CopyWith(skipFields: true)
class StateSudoku {
  final GameState state;
  final GameMode mode;
  final SudokuBoard board;

  const StateSudoku({
    required this.state,
    required this.mode,
    required this.board,
  });

  factory StateSudoku.fromJson(Map<String, dynamic> json) => _$StateSudokuFromJson(json);

  Map<String, dynamic> toJson() => _$StateSudokuToJson(this);
}
