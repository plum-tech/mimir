// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'background.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$BackgroundImageCWProxy {
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// BackgroundImage(...).copyWith(id: 12, name: "My name")
  /// ````
  BackgroundImage call({
    String? path,
    double? opacity,
    bool? repeat,
    bool? antialias,
    bool? hidden,
    bool? immersive,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfBackgroundImage.copyWith(...)`.
class _$BackgroundImageCWProxyImpl implements _$BackgroundImageCWProxy {
  const _$BackgroundImageCWProxyImpl(this._value);

  final BackgroundImage _value;

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// BackgroundImage(...).copyWith(id: 12, name: "My name")
  /// ````
  BackgroundImage call({
    Object? path = const $CopyWithPlaceholder(),
    Object? opacity = const $CopyWithPlaceholder(),
    Object? repeat = const $CopyWithPlaceholder(),
    Object? antialias = const $CopyWithPlaceholder(),
    Object? hidden = const $CopyWithPlaceholder(),
    Object? immersive = const $CopyWithPlaceholder(),
  }) {
    return BackgroundImage(
      path: path == const $CopyWithPlaceholder() || path == null
          ? _value.path
          // ignore: cast_nullable_to_non_nullable
          : path as String,
      opacity: opacity == const $CopyWithPlaceholder() || opacity == null
          ? _value.opacity
          // ignore: cast_nullable_to_non_nullable
          : opacity as double,
      repeat: repeat == const $CopyWithPlaceholder() || repeat == null
          ? _value.repeat
          // ignore: cast_nullable_to_non_nullable
          : repeat as bool,
      antialias: antialias == const $CopyWithPlaceholder() || antialias == null
          ? _value.antialias
          // ignore: cast_nullable_to_non_nullable
          : antialias as bool,
      hidden: hidden == const $CopyWithPlaceholder() || hidden == null
          ? _value.hidden
          // ignore: cast_nullable_to_non_nullable
          : hidden as bool,
      immersive: immersive == const $CopyWithPlaceholder() || immersive == null
          ? _value.immersive
          // ignore: cast_nullable_to_non_nullable
          : immersive as bool,
    );
  }
}

extension $BackgroundImageCopyWith on BackgroundImage {
  /// Returns a callable class that can be used as follows: `instanceOfBackgroundImage.copyWith(...)`.
  // ignore: library_private_types_in_public_api
  _$BackgroundImageCWProxy get copyWith => _$BackgroundImageCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BackgroundImage _$BackgroundImageFromJson(Map<String, dynamic> json) => BackgroundImage(
      path: json['path'] as String,
      opacity: (json['opacity'] as num?)?.toDouble() ?? 1.0,
      repeat: json['repeat'] as bool? ?? true,
      antialias: json['antialias'] as bool? ?? true,
      hidden: json['hidden'] as bool? ?? false,
      immersive: json['immersive'] as bool? ?? false,
    );

Map<String, dynamic> _$BackgroundImageToJson(BackgroundImage instance) => <String, dynamic>{
      'path': instance.path,
      'opacity': instance.opacity,
      'repeat': instance.repeat,
      'antialias': instance.antialias,
      'hidden': instance.hidden,
      'immersive': instance.immersive,
    };
