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
    String? id,
    String? hash,
    DateTime? createdAt,
    String? short,
    String? text,
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
    Object? hash = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? short = const $CopyWithPlaceholder(),
    Object? text = const $CopyWithPlaceholder(),
    Object? content = const $CopyWithPlaceholder(),
  }) {
    return MimirBulletin(
      id: id == const $CopyWithPlaceholder() || id == null
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      hash: hash == const $CopyWithPlaceholder() || hash == null
          ? _value.hash
          // ignore: cast_nullable_to_non_nullable
          : hash as String,
      createdAt: createdAt == const $CopyWithPlaceholder() || createdAt == null
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
      short: short == const $CopyWithPlaceholder() || short == null
          ? _value.short
          // ignore: cast_nullable_to_non_nullable
          : short as String,
      text: text == const $CopyWithPlaceholder() || text == null
          ? _value.text
          // ignore: cast_nullable_to_non_nullable
          : text as String,
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
      id: json['id'] as String,
      hash: _randHash(json['hash'] as String?),
      createdAt: DateTime.parse(json['createdAt'] as String),
      short: _trim(json['short'] as String),
      text: _trim(json['text'] as String),
      content: _trim(json['content'] as String),
    );

Map<String, dynamic> _$MimirBulletinToJson(MimirBulletin instance) => <String, dynamic>{
      'id': instance.id,
      'hash': instance.hash,
      'createdAt': instance.createdAt.toIso8601String(),
      'short': instance.short,
      'text': instance.text,
      'content': instance.content,
    };
