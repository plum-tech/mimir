// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pref.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$GamePrefMinesweeperCWProxy {
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// GamePrefMinesweeper(...).copyWith(id: 12, name: "My name")
  /// ````
  GamePrefMinesweeper call({
    GameModeMinesweeper? mode,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfGamePrefMinesweeper.copyWith(...)`.
class _$GamePrefMinesweeperCWProxyImpl implements _$GamePrefMinesweeperCWProxy {
  const _$GamePrefMinesweeperCWProxyImpl(this._value);

  final GamePrefMinesweeper _value;

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// GamePrefMinesweeper(...).copyWith(id: 12, name: "My name")
  /// ````
  GamePrefMinesweeper call({
    Object? mode = const $CopyWithPlaceholder(),
  }) {
    return GamePrefMinesweeper(
      mode: mode == const $CopyWithPlaceholder() || mode == null
          ? _value.mode
          // ignore: cast_nullable_to_non_nullable
          : mode as GameModeMinesweeper,
    );
  }
}

extension $GamePrefMinesweeperCopyWith on GamePrefMinesweeper {
  /// Returns a callable class that can be used as follows: `instanceOfGamePrefMinesweeper.copyWith(...)`.
  // ignore: library_private_types_in_public_api
  _$GamePrefMinesweeperCWProxy get copyWith => _$GamePrefMinesweeperCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GamePrefMinesweeper _$GamePrefMinesweeperFromJson(Map<String, dynamic> json) => GamePrefMinesweeper(
      mode: json['mode'] == null ? GameModeMinesweeper.easy : GameModeMinesweeper.fromJson(json['mode'] as String),
    );

Map<String, dynamic> _$GamePrefMinesweeperToJson(GamePrefMinesweeper instance) => <String, dynamic>{
      'mode': instance.mode,
    };
