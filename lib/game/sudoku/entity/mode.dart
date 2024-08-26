import 'package:easy_localization/easy_localization.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mimir/game/entity/game_mode.dart';

@JsonSerializable(createToJson: false, createFactory: false)
class GameModeSudoku extends GameMode {
  final int blanks;
  final bool enableFillerHint;
  static const beginner = GameModeSudoku._(
    name: "beginner",
    blanks: 18,
    enableFillerHint: true,
  );
  static const easy = GameModeSudoku._(
    name: "easy",
    blanks: 27,
    enableFillerHint: true,
  );
  static const medium = GameModeSudoku._(
    name: "medium",
    blanks: 36,
  );
  static const hard = GameModeSudoku._(
    name: "hard",
    blanks: 54,
  );

  static final name2mode = {
    "beginner": beginner,
    "easy": easy,
    "medium": medium,
    "hard": hard,
  };

  static final values = [
    beginner,
    easy,
    medium,
    hard,
  ];

  /// for unique solution, the [blanks] should be equal or less than 54
  const GameModeSudoku._({
    required super.name,
    required this.blanks,
    this.enableFillerHint = false,
  }) : assert(blanks <= 54);

  factory GameModeSudoku.fromJson(String name) => name2mode[name] ?? easy;

  @override
  bool operator ==(Object other) {
    return other is GameModeSudoku && runtimeType == other.runtimeType && name == other.name && blanks == other.blanks;
  }

  @override
  int get hashCode => Object.hash(name, blanks);

  @override
  String l10n() => "game.sudoku.gameMode.$name".tr();
}
