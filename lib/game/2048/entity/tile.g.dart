// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tile.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$TileCWProxy {
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// Tile(...).copyWith(id: 12, name: "My name")
  /// ````
  Tile call({
    String? id,
    int? value,
    int? index,
    int? nextIndex,
    bool? merged,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfTile.copyWith(...)`.
class _$TileCWProxyImpl implements _$TileCWProxy {
  const _$TileCWProxyImpl(this._value);

  final Tile _value;

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// Tile(...).copyWith(id: 12, name: "My name")
  /// ````
  Tile call({
    Object? id = const $CopyWithPlaceholder(),
    Object? value = const $CopyWithPlaceholder(),
    Object? index = const $CopyWithPlaceholder(),
    Object? nextIndex = const $CopyWithPlaceholder(),
    Object? merged = const $CopyWithPlaceholder(),
  }) {
    return Tile(
      id: id == const $CopyWithPlaceholder() || id == null
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      value: value == const $CopyWithPlaceholder() || value == null
          ? _value.value
          // ignore: cast_nullable_to_non_nullable
          : value as int,
      index: index == const $CopyWithPlaceholder() || index == null
          ? _value.index
          // ignore: cast_nullable_to_non_nullable
          : index as int,
      nextIndex: nextIndex == const $CopyWithPlaceholder()
          ? _value.nextIndex
          // ignore: cast_nullable_to_non_nullable
          : nextIndex as int?,
      merged: merged == const $CopyWithPlaceholder() || merged == null
          ? _value.merged
          // ignore: cast_nullable_to_non_nullable
          : merged as bool,
    );
  }
}

extension $TileCopyWith on Tile {
  /// Returns a callable class that can be used as follows: `instanceOfTile.copyWith(...)`.
  // ignore: library_private_types_in_public_api
  _$TileCWProxy get copyWith => _$TileCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tile _$TileFromJson(Map json) => Tile(
      id: json['id'] as String,
      value: json['value'] as int,
      index: json['index'] as int,
      nextIndex: json['nextIndex'] as int?,
      merged: json['merged'] as bool? ?? false,
    );

Map<String, dynamic> _$TileToJson(Tile instance) => <String, dynamic>{
      'id': instance.id,
      'value': instance.value,
      'index': instance.index,
      'nextIndex': instance.nextIndex,
      'merged': instance.merged,
    };
