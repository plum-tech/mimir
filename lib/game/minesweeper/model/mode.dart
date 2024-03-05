class GameMode {
  final String name;
  final int gameRows;
  final int gameCols;
  final int gameMines;

  static const easy = GameMode(
    name: "easy",
    gameRows: 15,
    gameCols: 8,
    gameMines: 18,
  );
  static const normal = GameMode(
    name: "normal",
    gameRows: 15,
    gameCols: 8,
    gameMines: 18,
  );
  static const hard = GameMode(
    name: "hard",
    gameRows: 15,
    gameCols: 8,
    gameMines: 18,
  );

  const GameMode({
    required this.name,
    required this.gameRows,
    required this.gameCols,
    required this.gameMines,
  });
}
