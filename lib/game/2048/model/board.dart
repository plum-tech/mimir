import 'package:json_annotation/json_annotation.dart';

import '../model/tile.dart';

part 'board.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
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

  Board(this.score, this.best, this.tiles, {this.over = false, this.won = false});

  //Create a model for a new game.
  Board.newGame(this.best, this.tiles)
      : score = 0,
        over = false,
        won = false;

  //Create an immutable copy of the board
  Board copyWith({int? score, int? best, List<Tile>? tiles, bool? over, bool? won}) =>
      Board(score ?? this.score, best ?? this.best, tiles ?? this.tiles, over: over ?? this.over, won: won ?? this.won);

  //Create a Board from json data
  factory Board.fromJson(Map<String, dynamic> json) => _$BoardFromJson(json);

  //Generate json data from the Board
  Map<String, dynamic> toJson() => _$BoardToJson(this);
}
