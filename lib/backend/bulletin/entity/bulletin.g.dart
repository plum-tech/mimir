// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bulletin.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$MimirBulletinCWProxy {
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// MimirBulletin(...).copyWith(id: 12, name: "My name")
  /// ````
  MimirBulletin call({
    int? id,
    DateTime? createdAt,
    String? short,
    String? content,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfMimirBulletin.copyWith(...)`.
class _$MimirBulletinCWProxyImpl implements _$MimirBulletinCWProxy {
  const _$MimirBulletinCWProxyImpl(this._value);

  final MimirBulletin _value;

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// MimirBulletin(...).copyWith(id: 12, name: "My name")
  /// ````
  MimirBulletin call({
    Object? id = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? short = const $CopyWithPlaceholder(),
    Object? content = const $CopyWithPlaceholder(),
  }) {
    return MimirBulletin(
      id: id == const $CopyWithPlaceholder() || id == null
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as int,
      createdAt: createdAt == const $CopyWithPlaceholder() || createdAt == null
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
      short: short == const $CopyWithPlaceholder() || short == null
          ? _value.short
          // ignore: cast_nullable_to_non_nullable
          : short as String,
      content: content == const $CopyWithPlaceholder() || content == null
          ? _value.content
          // ignore: cast_nullable_to_non_nullable
          : content as String,
    );
  }
}

extension $MimirBulletinCopyWith on MimirBulletin {
  /// Returns a callable class that can be used as follows: `instanceOfMimirBulletin.copyWith(...)`.
  // ignore: library_private_types_in_public_api
  _$MimirBulletinCWProxy get copyWith => _$MimirBulletinCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MimirBulletin _$MimirBulletinFromJson(Map<String, dynamic> json) => MimirBulletin(
      id: (json['id'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      short: json['short'] as String,
      content: json['content'] as String,
    );
