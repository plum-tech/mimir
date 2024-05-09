// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$GameStateMinesweeperCWProxy {
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// GameStateMinesweeper(...).copyWith(id: 12, name: "My name")
  /// ````
  GameStateMinesweeper call({
    GameStatus? status,
    GameMode? mode,
    CellBoard? board,
    Duration? playtime,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfGameStateMinesweeper.copyWith(...)`.
class _$GameStateMinesweeperCWProxyImpl implements _$GameStateMinesweeperCWProxy {
  const _$GameStateMinesweeperCWProxyImpl(this._value);

  final GameStateMinesweeper _value;

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// GameStateMinesweeper(...).copyWith(id: 12, name: "My name")
  /// ````
  GameStateMinesweeper call({
    Object? status = const $CopyWithPlaceholder(),
    Object? mode = const $CopyWithPlaceholder(),
    Object? board = const $CopyWithPlaceholder(),
    Object? playtime = const $CopyWithPlaceholder(),
  }) {
    return GameStateMinesweeper(
      status: status == const $CopyWithPlaceholder() || status == null
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as GameStatus,
      mode: mode == const $CopyWithPlaceholder() || mode == null
          ? _value.mode
          // ignore: cast_nullable_to_non_nullable
          : mode as GameMode,
      board: board == const $CopyWithPlaceholder() || board == null
          ? _value.board
          // ignore: cast_nullable_to_non_nullable
          : board as CellBoard,
      playtime: playtime == const $CopyWithPlaceholder() || playtime == null
          ? _value.playtime
          // ignore: cast_nullable_to_non_nullable
          : playtime as Duration,
    );
  }
}

extension $GameStateMinesweeperCopyWith on GameStateMinesweeper {
  /// Returns a callable class that can be used as follows: `instanceOfGameStateMinesweeper.copyWith(...)`.
  // ignore: library_private_types_in_public_api
  _$GameStateMinesweeperCWProxy get copyWith => _$GameStateMinesweeperCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameStateMinesweeper _$GameStateMinesweeperFromJson(Map<String, dynamic> json) => GameStateMinesweeper(
      status: $enumDecodeNullable(_$GameStatusEnumMap, json['status']) ?? GameStatus.idle,
      mode: GameMode.fromJson(json['mode'] as String),
      board: CellBoard.fromJson(json['board'] as Map<String, dynamic>),
      playtime: json['playtime'] == null ? Duration.zero : Duration(microseconds: (json['playtime'] as num).toInt()),
    );

Map<String, dynamic> _$GameStateMinesweeperToJson(GameStateMinesweeper instance) => <String, dynamic>{
      'status': _$GameStatusEnumMap[instance.status]!,
      'mode': instance.mode,
      'board': instance.board,
      'playtime': instance.playtime.inMicroseconds,
    };

const _$GameStatusEnumMap = {
  GameStatus.running: 'running',
  GameStatus.idle: 'idle',
  GameStatus.gameOver: 'gameOver',
  GameStatus.victory: 'victory',
};
