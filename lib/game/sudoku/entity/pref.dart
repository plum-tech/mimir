import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

import 'mode.dart';

part "pref.g.dart";

@JsonSerializable()
@CopyWith(skipFields: true)
class GamePrefSudoku {
  final GameModeSudoku mode;

  const GamePrefSudoku({
    this.mode = GameModeSudoku.easy,
  });

  @override
  bool operator ==(Object other) {
    return other is GamePrefSudoku && runtimeType == other.runtimeType && mode == other.mode;
  }

  @override
  int get hashCode => Object.hash(mode, 0);

  factory GamePrefSudoku.fromJson(Map<String, dynamic> json) => _$GamePrefSudokuFromJson(json);

  Map<String, dynamic> toJson() => _$GamePrefSudokuToJson(this);
}
