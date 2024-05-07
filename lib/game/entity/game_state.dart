import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum()
enum GameState {
  running,
  idle,
  gameOver,
  victory;

  bool get shouldSave => this != gameOver || this != victory;
}
