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
    gameRows: 15,
    gameColumns: 8,
    gameMines: 18,
  );
  static const hard = GameMode._(
    name: "hard",
    gameRows: 15,
    gameColumns: 8,
    gameMines: 18,
  );

  static final name2mode = {
    "easy": easy,
    "normal": normal,
    "hard": hard,
  };

  const GameMode._({
    required this.name,
    required this.gameRows,
    required this.gameColumns,
    required this.gameMines,
  });

  static String toJson(GameMode mode) => mode.name;

  static GameMode fromJson(String name) => name2mode[name] ?? easy;
}
