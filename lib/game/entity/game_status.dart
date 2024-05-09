import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum GameStatus {
  running,
  idle,
  gameOver,
  victory;

  bool get shouldSave => this != gameOver && this != victory;
}
