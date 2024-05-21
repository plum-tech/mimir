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
    WordleVocabulary? vocabulary,
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
    Object? vocabulary = const $CopyWithPlaceholder(),
  }) {
    return GamePrefWordle(
      vocabulary: vocabulary == const $CopyWithPlaceholder() || vocabulary == null
          ? _value.vocabulary
          // ignore: cast_nullable_to_non_nullable
          : vocabulary as WordleVocabulary,
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
      vocabulary:
          json['vocabulary'] == null ? WordleVocabulary.all : WordleVocabulary.fromJson(json['vocabulary'] as String),
    );

Map<String, dynamic> _$GamePrefWordleToJson(GamePrefWordle instance) => <String, dynamic>{
      'vocabulary': instance.vocabulary,
    };
