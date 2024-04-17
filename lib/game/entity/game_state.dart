import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum()
enum GameState {
  running,
  idle,
  gameOver,
  victory,
}
