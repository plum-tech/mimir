// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$GameStateWordleCWProxy {
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// GameStateWordle(...).copyWith(id: 12, name: "My name")
  /// ````
  GameStateWordle call({
    GameStatus? status,
    Duration? playtime,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfGameStateWordle.copyWith(...)`.
class _$GameStateWordleCWProxyImpl implements _$GameStateWordleCWProxy {
  const _$GameStateWordleCWProxyImpl(this._value);

  final GameStateWordle _value;

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// GameStateWordle(...).copyWith(id: 12, name: "My name")
  /// ````
  GameStateWordle call({
    Object? status = const $CopyWithPlaceholder(),
    Object? playtime = const $CopyWithPlaceholder(),
  }) {
    return GameStateWordle(
      status: status == const $CopyWithPlaceholder() || status == null
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as GameStatus,
      playtime: playtime == const $CopyWithPlaceholder() || playtime == null
          ? _value.playtime
          // ignore: cast_nullable_to_non_nullable
          : playtime as Duration,
    );
  }
}

extension $GameStateWordleCopyWith on GameStateWordle {
  /// Returns a callable class that can be used as follows: `instanceOfGameStateWordle.copyWith(...)`.
  // ignore: library_private_types_in_public_api
  _$GameStateWordleCWProxy get copyWith => _$GameStateWordleCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameStateWordle _$GameStateWordleFromJson(Map<String, dynamic> json) => GameStateWordle(
      status: $enumDecodeNullable(_$GameStatusEnumMap, json['status']) ?? GameStatus.idle,
      playtime: json['playtime'] == null ? Duration.zero : Duration(microseconds: (json['playtime'] as num).toInt()),
    );

Map<String, dynamic> _$GameStateWordleToJson(GameStateWordle instance) => <String, dynamic>{
      'status': _$GameStatusEnumMap[instance.status]!,
      'playtime': instance.playtime.inMicroseconds,
    };

const _$GameStatusEnumMap = {
  GameStatus.running: 'running',
  GameStatus.idle: 'idle',
  GameStatus.gameOver: 'gameOver',
  GameStatus.victory: 'victory',
};
