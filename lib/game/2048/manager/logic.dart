import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import 'package:sit/game/entity/game_status.dart';
import 'package:sit/game/utils.dart';
import 'package:uuid/uuid.dart';

import '../entity/record.dart';
import '../entity/tile.dart';
import '../entity/board.dart';

import '../storage.dart';
import 'next_direction.dart';
import 'round.dart';

class GameLogic extends StateNotifier<Board> {
  // We will use this list to retrieve the right index when user swipes up/down
  // which will allow us to reuse most of the logic.
  static const verticalOrder = [12, 8, 4, 0, 13, 9, 5, 1, 14, 10, 6, 2, 15, 11, 7, 3];

  final StateNotifierProviderRef ref;

  GameLogic(this.ref) : super(const Board(tiles: []));

  // Start New Game
  void newGame() {
    state = Board(tiles: [random([])]);
  }

  // Continue from save
  void fromSave(Board save) {
    state = save;
  }

  // Check whether the indexes are in the same row or column in the board.
  static bool _inRange(index, nextIndex) {
    return index < 4 && nextIndex < 4 ||
        index >= 4 && index < 8 && nextIndex >= 4 && nextIndex < 8 ||
        index >= 8 && index < 12 && nextIndex >= 8 && nextIndex < 12 ||
        index >= 12 && nextIndex >= 12;
  }

  static Tile _calculate(Tile tile, List<Tile> tiles, direction) {
    bool asc = direction == SwipeDirection.left || direction == SwipeDirection.up;
    bool vert = direction == SwipeDirection.up || direction == SwipeDirection.down;
    // Get the first index from the left in the row
    // Example: for left swipe that can be: 0, 4, 8, 12
    // for right swipe that can be: 3, 7, 11, 15
    // depending which row in the column in the board we need
    // let's say the title.index = 6 (which is the 3rd tile from the left and 2nd from right side, in the second row)
    // ceil means it will ALWAYS round up to the next largest integer
    // NOTE: don't confuse ceil it with floor or round as even if the value is 2.1 output would be 3.
    // ((6 + 1) / 4) = 1.75
    // Ceil(1.75) = 2
    // If it's ascending: 2 * 4 – 4 = 4, which is the first index from the left side in the second row
    // If it's descending: 2 * 4 – 1 = 7, which is the last index from the left side and first index from the right side in the second row
    // If user swipes vertically use the verticalOrder list to retrieve the up/down index else use the existing index
    int index = vert ? verticalOrder[tile.index] : tile.index;
    int nextIndex = ((index + 1) / 4).ceil() * 4 - (asc ? 4 : 1);

    // If the list of the new tiles to be rendered is not empty get the last tile
    // and if that tile is in the same row as the curren tile set the next index for the current tile to be after the last tile
    if (tiles.isNotEmpty) {
      var last = tiles.last;
      // If user swipes vertically use the verticalOrder list to retrieve the up/down index else use the existing index
      var lastIndex = last.nextIndex ?? last.index;
      lastIndex = vert ? verticalOrder[lastIndex] : lastIndex;
      if (_inRange(index, lastIndex)) {
        // If the order is ascending set the tile after the last processed tile
        // If the order is descending set the tile before the last processed tile
        nextIndex = lastIndex + (asc ? 1 : -1);
      }
    }

    // Return immutable copy of the current tile with the new next index
    // which can either be the top left index in the row or the last tile nextIndex/index + 1
    return tile.copyWith(nextIndex: vert ? verticalOrder.indexOf(nextIndex) : nextIndex);
  }

  //Move the tile in the direction
  bool move(SwipeDirection direction) {
    bool asc = direction == SwipeDirection.left || direction == SwipeDirection.up;
    bool vert = direction == SwipeDirection.up || direction == SwipeDirection.down;
    // Sort the list of tiles by index.
    // If user swipes vertically use the verticalOrder list to retrieve the up/down index
    state.tiles.sort(
      ((a, b) =>
          (asc ? 1 : -1) *
          (vert ? verticalOrder[a.index].compareTo(verticalOrder[b.index]) : a.index.compareTo(b.index))),
    );

    List<Tile> tiles = [];

    for (int i = 0, l = state.tiles.length; i < l; i++) {
      var tile = state.tiles[i];

      // Calculate nextIndex for current tile.
      tile = _calculate(tile, tiles, direction);
      tiles.add(tile);

      if (i + 1 < l) {
        var next = state.tiles[i + 1];
        // Assign current tile nextIndex or index to the next tile if its allowed to be moved.
        if (tile.value == next.value) {
          // If user swipes vertically use the verticalOrder list to retrieve the up/down index else use the existing index
          var index = vert ? verticalOrder[tile.index] : tile.index,
              nextIndex = vert ? verticalOrder[next.index] : next.index;
          if (_inRange(index, nextIndex)) {
            tiles.add(next.copyWith(nextIndex: tile.nextIndex));
            // Skip next iteration if next tile was already assigned nextIndex.
            i += 1;
            continue;
          }
        }
      }
    }

    // Assign immutable copy of the new board state and trigger rebuild.
    state = state.copyWith(tiles: tiles);
    return true;
  }

  static final rand = Random();

  /// Generates tiles at random place on the board.
  /// Avoids occupied tiles.
  static Tile random(List<int> indexes) {
    final candidates = Iterable.generate(16, (i) => i).toList();
    candidates.removeWhere((i) => indexes.contains(i));
    final index = candidates[rand.nextInt(candidates.length)];
    return Tile(id: const Uuid().v4(), value: 2, index: index);
  }

  //Merge tiles
  void merge() {
    List<Tile> tiles = [];
    var tilesMoved = false;
    List<int> indexes = [];
    var score = state.score;

    for (int i = 0, l = state.tiles.length; i < l; i++) {
      var tile = state.tiles[i];

      var value = tile.value, merged = false;

      if (i + 1 < l) {
        //sum the number of the two tiles with same index and mark the tile as merged and skip the next iteration.
        var next = state.tiles[i + 1];
        if (tile.nextIndex == next.nextIndex || tile.index == next.nextIndex && tile.nextIndex == null) {
          value = tile.value + next.value;
          merged = true;
          applyGameHapticFeedback();
          score += tile.value;
          i += 1;
        }
      }

      if (merged || tile.nextIndex != null && tile.index != tile.nextIndex) {
        tilesMoved = true;
      }

      tiles.add(tile.copyWith(index: tile.nextIndex ?? tile.index, nextIndex: null, value: value, merged: merged));
      indexes.add(tiles.last.index);
    }

    // If tiles got moved then generate a new tile at random position of the available positions on the board.
    // If all tiles are occupied, then don't generate.
    if (tilesMoved && indexes.length < 16) {
      tiles.add(random(indexes));
    }
    state = state.copyWith(score: score, tiles: tiles);
  }

  //Finish round, win or loose the game.
  void _endRound() {
    var boardFilled = true;
    var got2048 = false;
    List<Tile> tiles = [];

    //If there is no more empty place on the board
    if (state.tiles.length == 16) {
      state.tiles.sort(((a, b) => a.index.compareTo(b.index)));

      for (int i = 0, l = state.tiles.length; i < l; i++) {
        var tile = state.tiles[i];

        //If there is a tile with 2048 then the game is won.
        if (tile.value == 2048) {
          got2048 = true;
        }

        var x = (i - (((i + 1) / 4).ceil() * 4 - 4));

        if (x > 0 && i - 1 >= 0) {
          //If tile can be merged with left tile then game is not lost.
          var left = state.tiles[i - 1];
          if (tile.value == left.value) {
            boardFilled = false;
          }
        }

        if (x < 3 && i + 1 < l) {
          //If tile can be merged with right tile then game is not lost.
          var right = state.tiles[i + 1];
          if (tile.value == right.value) {
            boardFilled = false;
          }
        }

        if (i - 4 >= 0) {
          //If tile can be merged with above tile then game is not lost.
          var top = state.tiles[i - 4];
          if (tile.value == top.value) {
            boardFilled = false;
          }
        }

        if (i + 4 < l) {
          //If tile can be merged with the bellow tile then game is not lost.
          var bottom = state.tiles[i + 4];
          if (tile.value == bottom.value) {
            boardFilled = false;
          }
        }
        //Set the tile merged: false
        tiles.add(tile.copyWith(merged: false));
      }
    } else {
      //There is still a place on the board to add a tile so the game is not lost.
      boardFilled = false;
      for (var tile in state.tiles) {
        //If there is a tile with 2048 then the game is won.
        if (tile.value == 2048) {
          got2048 = true;
        }
        //Set the tile merged: false
        tiles.add(tile.copyWith(merged: false));
      }
    }
    state = state.copyWith(
      tiles: tiles,
    );
    if (boardFilled) {
      if (got2048) {
        onVictory();
      } else {
        onGameOver();
      }
    }
  }

  //Mark the merged as false after the merge animation is complete.
  bool endRound() {
    //End round.
    _endRound();
    ref.read(roundManager.notifier).end();

    //If player moved too fast before the current animation/transition finished, start the move for the next direction
    var nextDirection = ref.read(nextDirectionManager);
    if (nextDirection != null) {
      move(nextDirection);
      ref.read(nextDirectionManager.notifier).clear();
      return true;
    }
    return false;
  }

  //Move the tiles using the arrow keys on the keyboard.
  bool onKey(KeyEvent event) {
    SwipeDirection? direction;
    if (HardwareKeyboard.instance.isLogicalKeyPressed(LogicalKeyboardKey.arrowRight)) {
      direction = SwipeDirection.right;
    } else if (HardwareKeyboard.instance.isLogicalKeyPressed(LogicalKeyboardKey.arrowLeft)) {
      direction = SwipeDirection.left;
    } else if (HardwareKeyboard.instance.isLogicalKeyPressed(LogicalKeyboardKey.arrowUp)) {
      direction = SwipeDirection.up;
    } else if (HardwareKeyboard.instance.isLogicalKeyPressed(LogicalKeyboardKey.arrowDown)) {
      direction = SwipeDirection.down;
    }

    if (direction != null) {
      move(direction);
      return true;
    }
    return false;
  }

  void onVictory() {
    state = state.copyWith(
      status: GameStatus.victory,
    );
    Storage2048.record.add(Record2048.createFrom(
      maxNumber: state.maxNumber,
      score: state.score,
    ));
  }

  void onGameOver() {
    state = state.copyWith(
      status: GameStatus.gameOver,
    );
    Storage2048.record.add(Record2048.createFrom(
      maxNumber: state.maxNumber,
      score: state.score,
    ));
  }

  bool canSave() {
    if (!state.status.shouldSave) return false;
    if (state.tiles.isEmpty) return false;
    if (state.tiles.length == 1 && state.tiles.first.value == 2) return false;
    return true;
  }

  Future<void> save() async {
    if (canSave()) {
      await Storage2048.save.save(state.toSave());
    } else {
      await Storage2048.save.delete();
    }
  }
}
