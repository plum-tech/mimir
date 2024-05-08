import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:uuid/uuid.dart';

import '../entity/tile.dart';
import '../save.dart';

part "board.g.dart";

@CopyWith(skipFields: true)
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

  /// Create a model for a new game.
  const Board({
    this.score = 0,
    required this.tiles,
    this.best = 0,
    this.over = false,
    this.won = false,
  });

  /// Create a Board from json data
  factory Board.fromSave(Save2048 save) {
    final tiles = <Tile>[];
    for (var i = 0; i < save.tiles.length; i++) {
      final score = save.tiles[i];
      if (score > 0) {
        tiles.add(Tile(id: const Uuid().v4(), value: score, index: i));
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
