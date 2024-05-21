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
    WordleVocabulary? vocabulary,
    String? word,
    List<String>? attempts,
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
    Object? vocabulary = const $CopyWithPlaceholder(),
    Object? word = const $CopyWithPlaceholder(),
    Object? attempts = const $CopyWithPlaceholder(),
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
      vocabulary: vocabulary == const $CopyWithPlaceholder() || vocabulary == null
          ? _value.vocabulary
          // ignore: cast_nullable_to_non_nullable
          : vocabulary as WordleVocabulary,
      word: word == const $CopyWithPlaceholder() || word == null
          ? _value.word
          // ignore: cast_nullable_to_non_nullable
          : word as String,
      attempts: attempts == const $CopyWithPlaceholder() || attempts == null
          ? _value.attempts
          // ignore: cast_nullable_to_non_nullable
          : attempts as List<String>,
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
      vocabulary:
          json['vocabulary'] == null ? WordleVocabulary.all : WordleVocabulary.fromJson(json['vocabulary'] as String),
      word: json['word'] as String,
      attempts: (json['attempts'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
    );

Map<String, dynamic> _$GameStateWordleToJson(GameStateWordle instance) => <String, dynamic>{
      'word': instance.word,
      'attempts': instance.attempts,
      'status': _$GameStatusEnumMap[instance.status]!,
      'playtime': instance.playtime.inMicroseconds,
      'vocabulary': instance.vocabulary,
    };

const _$GameStatusEnumMap = {
  GameStatus.running: 'running',
  GameStatus.idle: 'idle',
  GameStatus.gameOver: 'gameOver',
  GameStatus.victory: 'victory',
};
