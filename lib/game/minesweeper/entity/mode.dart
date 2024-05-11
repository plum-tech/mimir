import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(createToJson: false, createFactory: false)
class GameMode {
  final String name;
  final int gameRows;
  final int gameColumns;
  final int gameMines;
  static const defaultRows = 15;
  static const defaultColumns = 8;
  static const easy = GameMode._(
    name: "easy",
    gameRows: defaultRows,
    gameColumns: defaultColumns,
    gameMines: 18,
  );
  static const normal = GameMode._(
    name: "normal",
    gameRows: defaultRows,
    gameColumns: defaultColumns,
    gameMines: 30,
  );
  static const hard = GameMode._(
    name: "hard",
    gameRows: defaultRows,
    gameColumns: defaultColumns,
    gameMines: 43,
  );

  static final name2mode = {
    "easy": easy,
    "normal": normal,
    "hard": hard,
  };

  static final all = [
    easy,
    normal,
    hard,
  ];

  const GameMode._({
    required this.name,
    required this.gameRows,
    required this.gameColumns,
    required this.gameMines,
  });

  String toJson() => name;

  factory GameMode.fromJson(String name) => name2mode[name] ?? easy;

  @override
  bool operator ==(Object other) {
    return other is GameMode &&
        runtimeType == other.runtimeType &&
        name == other.name &&
        gameRows == other.gameRows &&
        gameColumns == other.gameColumns &&
        gameMines == other.gameMines;
  }

  @override
  int get hashCode => Object.hash(name, gameRows, gameColumns, gameMines);
}
