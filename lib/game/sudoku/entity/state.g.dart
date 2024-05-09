// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$GameStateSudokuCWProxy {
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// GameStateSudoku(...).copyWith(id: 12, name: "My name")
  /// ````
  GameStateSudoku call({
    GameState? state,
    GameMode? mode,
    SudokuBoard? board,
    Duration? playtime,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfGameStateSudoku.copyWith(...)`.
class _$GameStateSudokuCWProxyImpl implements _$GameStateSudokuCWProxy {
  const _$GameStateSudokuCWProxyImpl(this._value);

  final GameStateSudoku _value;

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// GameStateSudoku(...).copyWith(id: 12, name: "My name")
  /// ````
  GameStateSudoku call({
    Object? state = const $CopyWithPlaceholder(),
    Object? mode = const $CopyWithPlaceholder(),
    Object? board = const $CopyWithPlaceholder(),
    Object? playtime = const $CopyWithPlaceholder(),
  }) {
    return GameStateSudoku(
      state: state == const $CopyWithPlaceholder() || state == null
          ? _value.state
          // ignore: cast_nullable_to_non_nullable
          : state as GameState,
      mode: mode == const $CopyWithPlaceholder() || mode == null
          ? _value.mode
          // ignore: cast_nullable_to_non_nullable
          : mode as GameMode,
      board: board == const $CopyWithPlaceholder() || board == null
          ? _value.board
          // ignore: cast_nullable_to_non_nullable
          : board as SudokuBoard,
      playtime: playtime == const $CopyWithPlaceholder() || playtime == null
          ? _value.playtime
          // ignore: cast_nullable_to_non_nullable
          : playtime as Duration,
    );
  }
}

extension $GameStateSudokuCopyWith on GameStateSudoku {
  /// Returns a callable class that can be used as follows: `instanceOfGameStateSudoku.copyWith(...)`.
  // ignore: library_private_types_in_public_api
  _$GameStateSudokuCWProxy get copyWith => _$GameStateSudokuCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameStateSudoku _$GameStateSudokuFromJson(Map<String, dynamic> json) => GameStateSudoku(
      state: $enumDecodeNullable(_$GameStateEnumMap, json['state']) ?? GameState.idle,
      mode: GameMode.fromJson(json['mode'] as String),
      board: SudokuBoard.fromJson(json['board']),
      playtime: json['playtime'] == null ? Duration.zero : Duration(microseconds: (json['playtime'] as num).toInt()),
    );

Map<String, dynamic> _$GameStateSudokuToJson(GameStateSudoku instance) => <String, dynamic>{
      'state': _$GameStateEnumMap[instance.state]!,
      'mode': instance.mode,
      'board': instance.board,
      'playtime': instance.playtime.inMicroseconds,
    };

const _$GameStateEnumMap = {
  GameState.running: 'running',
  GameState.idle: 'idle',
  GameState.gameOver: 'gameOver',
  GameState.victory: 'victory',
};
