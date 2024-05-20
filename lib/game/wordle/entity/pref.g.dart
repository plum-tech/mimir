// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pref.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$GamePrefWordleCWProxy {
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// GamePrefWordle(...).copyWith(id: 12, name: "My name")
  /// ````
  GamePrefWordle call({
    WordleWordSet? wordSet,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfGamePrefWordle.copyWith(...)`.
class _$GamePrefWordleCWProxyImpl implements _$GamePrefWordleCWProxy {
  const _$GamePrefWordleCWProxyImpl(this._value);

  final GamePrefWordle _value;

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// GamePrefWordle(...).copyWith(id: 12, name: "My name")
  /// ````
  GamePrefWordle call({
    Object? wordSet = const $CopyWithPlaceholder(),
  }) {
    return GamePrefWordle(
      wordSet: wordSet == const $CopyWithPlaceholder() || wordSet == null
          ? _value.wordSet
          // ignore: cast_nullable_to_non_nullable
          : wordSet as WordleWordSet,
    );
  }
}

extension $GamePrefWordleCopyWith on GamePrefWordle {
  /// Returns a callable class that can be used as follows: `instanceOfGamePrefWordle.copyWith(...)`.
  // ignore: library_private_types_in_public_api
  _$GamePrefWordleCWProxy get copyWith => _$GamePrefWordleCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GamePrefWordle _$GamePrefWordleFromJson(Map<String, dynamic> json) => GamePrefWordle(
      wordSet: json['wordSet'] == null ? WordleWordSet.all : WordleWordSet.fromJson(json['wordSet'] as String),
    );

Map<String, dynamic> _$GamePrefWordleToJson(GamePrefWordle instance) => <String, dynamic>{
      'wordSet': instance.wordSet,
    };
