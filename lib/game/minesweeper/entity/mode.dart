class GameMode {
  final String name;
  final int gameRows;
  final int gameColumns;
  final int gameMines;
  static const defaultRows = 15;
  static const defaultColumns = 8;
  static const easy = GameMode(
    name: "easy",
    gameRows: defaultRows,
    gameColumns: defaultColumns,
    gameMines: 18,
  );
  static const normal = GameMode(
    name: "normal",
    gameRows: 15,
    gameColumns: 8,
    gameMines: 18,
  );
  static const hard = GameMode(
    name: "hard",
    gameRows: 15,
    gameColumns: 8,
    gameMines: 18,
  );

  const GameMode({
    required this.name,
    required this.gameRows,
    required this.gameColumns,
    required this.gameMines,
  });
}
