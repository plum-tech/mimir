import 'package:collection/collection.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:mimir/game/entity/game_status.dart';
import 'package:uuid/uuid.dart';

import '../entity/tile.dart';
import 'save.dart';

part "board.g.dart";

@CopyWith(skipFields: true)
class Board {
  //Current score on the board
  final int score;

  //Current list of tiles shown on the board
  final List<Tile> tiles;

  final GameStatus status;

  /// Create a model for a new game.
  const Board({
    this.score = 0,
    required this.tiles,
    this.status = GameStatus.idle,
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
    return Board(score: save.score, tiles: tiles);
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

  int get maxNumber => tiles.map((tile) => tile.value).maxOrNull ?? 0;
}
