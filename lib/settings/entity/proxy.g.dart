// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'proxy.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ProxyProfileCWProxy {
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// ProxyProfile(...).copyWith(id: 12, name: "My name")
  /// ````
  ProxyProfile call({
    Uri? address,
    bool? enabled,
    ProxyMode? mode,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfProxyProfile.copyWith(...)`.
class _$ProxyProfileCWProxyImpl implements _$ProxyProfileCWProxy {
  const _$ProxyProfileCWProxyImpl(this._value);

  final ProxyProfile _value;

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// ProxyProfile(...).copyWith(id: 12, name: "My name")
  /// ````
  ProxyProfile call({
    Object? address = const $CopyWithPlaceholder(),
    Object? enabled = const $CopyWithPlaceholder(),
    Object? mode = const $CopyWithPlaceholder(),
  }) {
    return ProxyProfile(
      address: address == const $CopyWithPlaceholder() || address == null
          ? _value.address
          // ignore: cast_nullable_to_non_nullable
          : address as Uri,
      enabled: enabled == const $CopyWithPlaceholder() || enabled == null
          ? _value.enabled
          // ignore: cast_nullable_to_non_nullable
          : enabled as bool,
      mode: mode == const $CopyWithPlaceholder() || mode == null
          ? _value.mode
          // ignore: cast_nullable_to_non_nullable
          : mode as ProxyMode,
    );
  }
}

extension $ProxyProfileCopyWith on ProxyProfile {
  /// Returns a callable class that can be used as follows: `instanceOfProxyProfile.copyWith(...)`.
  // ignore: library_private_types_in_public_api
  _$ProxyProfileCWProxy get copyWith => _$ProxyProfileCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProxyProfile _$ProxyProfileFromJson(Map<String, dynamic> json) => ProxyProfile(
      address: Uri.parse(json['address'] as String),
      enabled: json['enabled'] as bool? ?? false,
      mode: $enumDecodeNullable(_$ProxyModeEnumMap, json['mode']) ?? ProxyMode.schoolOnly,
    );

Map<String, dynamic> _$ProxyProfileToJson(ProxyProfile instance) => <String, dynamic>{
      'address': instance.address.toString(),
      'enabled': instance.enabled,
      'mode': _$ProxyModeEnumMap[instance.mode]!,
    };

const _$ProxyModeEnumMap = {
  ProxyMode.global: 'global',
  ProxyMode.schoolOnly: 'schoolOnly',
};
