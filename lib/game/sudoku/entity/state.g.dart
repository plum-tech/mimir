// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$StateSudokuCWProxy {
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// StateSudoku(...).copyWith(id: 12, name: "My name")
  /// ````
  StateSudoku call({
    GameState? state,
    GameMode? mode,
    SudokuBoard? board,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfStateSudoku.copyWith(...)`.
class _$StateSudokuCWProxyImpl implements _$StateSudokuCWProxy {
  const _$StateSudokuCWProxyImpl(this._value);

  final StateSudoku _value;

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// StateSudoku(...).copyWith(id: 12, name: "My name")
  /// ````
  StateSudoku call({
    Object? state = const $CopyWithPlaceholder(),
    Object? mode = const $CopyWithPlaceholder(),
    Object? board = const $CopyWithPlaceholder(),
  }) {
    return StateSudoku(
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
    );
  }
}

extension $StateSudokuCopyWith on StateSudoku {
  /// Returns a callable class that can be used as follows: `instanceOfStateSudoku.copyWith(...)`.
  // ignore: library_private_types_in_public_api
  _$StateSudokuCWProxy get copyWith => _$StateSudokuCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StateSudoku _$StateSudokuFromJson(Map<String, dynamic> json) => StateSudoku(
      state: $enumDecode(_$GameStateEnumMap, json['state']),
      mode: GameMode.fromJson(json['mode'] as String),
      board: SudokuBoard.fromJson(json['board']),
    );

Map<String, dynamic> _$StateSudokuToJson(StateSudoku instance) => <String, dynamic>{
      'state': _$GameStateEnumMap[instance.state]!,
      'mode': instance.mode,
      'board': instance.board,
    };

const _$GameStateEnumMap = {
  GameState.running: 'running',
  GameState.idle: 'idle',
  GameState.gameOver: 'gameOver',
  GameState.victory: 'victory',
};
