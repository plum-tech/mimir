// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$GameStatesCWProxy {
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// GameStates(...).copyWith(id: 12, name: "My name")
  /// ````
  GameStates call({
    bool? gameOver,
    bool? goodGame,
    GameMode? mode,
    Screen? screen,
    Board? board,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfGameStates.copyWith(...)`.
class _$GameStatesCWProxyImpl implements _$GameStatesCWProxy {
  const _$GameStatesCWProxyImpl(this._value);

  final GameStates _value;

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// GameStates(...).copyWith(id: 12, name: "My name")
  /// ````
  GameStates call({
    Object? gameOver = const $CopyWithPlaceholder(),
    Object? goodGame = const $CopyWithPlaceholder(),
    Object? mode = const $CopyWithPlaceholder(),
    Object? screen = const $CopyWithPlaceholder(),
    Object? board = const $CopyWithPlaceholder(),
  }) {
    return GameStates(
      gameOver: gameOver == const $CopyWithPlaceholder() || gameOver == null
          ? _value.gameOver
          // ignore: cast_nullable_to_non_nullable
          : gameOver as bool,
      goodGame: goodGame == const $CopyWithPlaceholder() || goodGame == null
          ? _value.goodGame
          // ignore: cast_nullable_to_non_nullable
          : goodGame as bool,
      mode: mode == const $CopyWithPlaceholder() || mode == null
          ? _value.mode
          // ignore: cast_nullable_to_non_nullable
          : mode as GameMode,
      screen: screen == const $CopyWithPlaceholder() || screen == null
          ? _value.screen
          // ignore: cast_nullable_to_non_nullable
          : screen as Screen,
      board: board == const $CopyWithPlaceholder() || board == null
          ? _value.board
          // ignore: cast_nullable_to_non_nullable
          : board as Board,
    );
  }
}

extension $GameStatesCopyWith on GameStates {
  /// Returns a callable class that can be used as follows: `instanceOfGameStates.copyWith(...)`.
  // ignore: library_private_types_in_public_api
  _$GameStatesCWProxy get copyWith => _$GameStatesCWProxyImpl(this);
}
