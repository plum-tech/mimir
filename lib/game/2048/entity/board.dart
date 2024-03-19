import 'package:uuid/uuid.dart';

import '../entity/tile.dart';
import '../save.dart';

class Board {
  //Current score on the board
  final int score;

  //Best score so far
  final int best;

  //Current list of tiles shown on the board
  final List<Tile> tiles;

  //Whether the game is over or not
  final bool over;

  //Whether the game is won or not
  final bool won;

  Board({
    required this.score,
    required this.best,
    required this.tiles,
    this.over = false,
    this.won = false,
  });

  //Create a model for a new game.
  Board.newGame({
    required this.best,
    required this.tiles,
  })  : score = 0,
        over = false,
        won = false;

  //Create an immutable copy of the board
  Board copyWith({
    int? score,
    int? best,
    List<Tile>? tiles,
    bool? over,
    bool? won,
  }) {
    return Board(
      score: score ?? this.score,
      best: best ?? this.best,
      tiles: tiles ?? this.tiles,
      over: over ?? this.over,
      won: won ?? this.won,
    );
  }

  // Create a Board from json data
  factory Board.fromSave(Save2048 save) {
    final tiles = <Tile>[];
    for (var i = 0; i < save.tiles.length; i++) {
      final score = save.tiles[i];
      if (score > 0) {
        tiles.add(Tile(const Uuid().v4(), score, i));
      }
    }
    return Board(score: save.score, best: save.score, tiles: tiles);
  }

  //Generate json data from the Board
  Save2048 toSave() {
    final slots = List.generate(16, (index) => -1, growable: false);
    for (final tile in tiles) {
      slots[tile.index] = tile.value;
    }
    return Save2048(
      score: score,
      tiles: slots,
    );
  }
}
