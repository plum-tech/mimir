// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$BoardCWProxy {
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// Board(...).copyWith(id: 12, name: "My name")
  /// ````
  Board call({
    int? score,
    List<Tile>? tiles,
    GameStatus? status,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfBoard.copyWith(...)`.
class _$BoardCWProxyImpl implements _$BoardCWProxy {
  const _$BoardCWProxyImpl(this._value);

  final Board _value;

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// Board(...).copyWith(id: 12, name: "My name")
  /// ````
  Board call({
    Object? score = const $CopyWithPlaceholder(),
    Object? tiles = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
  }) {
    return Board(
      score: score == const $CopyWithPlaceholder() || score == null
          ? _value.score
          // ignore: cast_nullable_to_non_nullable
          : score as int,
      tiles: tiles == const $CopyWithPlaceholder() || tiles == null
          ? _value.tiles
          // ignore: cast_nullable_to_non_nullable
          : tiles as List<Tile>,
      status: status == const $CopyWithPlaceholder() || status == null
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as GameStatus,
    );
  }
}

extension $BoardCopyWith on Board {
  /// Returns a callable class that can be used as follows: `instanceOfBoard.copyWith(...)`.
  // ignore: library_private_types_in_public_api
  _$BoardCWProxy get copyWith => _$BoardCWProxyImpl(this);
}
