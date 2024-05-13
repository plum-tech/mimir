import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

import 'entity/mode.dart';

part "pref.g.dart";

@JsonSerializable()
@CopyWith(skipFields: true)
class GamePrefMinesweeper {
  final GameModeMinesweeper mode;

  const GamePrefMinesweeper({
    this.mode = GameModeMinesweeper.easy,
  });

  @override
  bool operator ==(Object other) {
    return other is GamePrefMinesweeper && runtimeType == other.runtimeType && mode == other.mode;
  }

  @override
  int get hashCode => Object.hash(mode, 0);

  factory GamePrefMinesweeper.fromJson(Map<String, dynamic> json) => _$GamePrefMinesweeperFromJson(json);

  Map<String, dynamic> toJson() => _$GamePrefMinesweeperToJson(this);
}
