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
// TypeAdapterGenerator
// **************************************************************************

class ProxyModeAdapter extends TypeAdapter<ProxyMode> {
  @override
  final int typeId = 7;

  @override
  ProxyMode read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ProxyMode.global;
      case 1:
        return ProxyMode.schoolOnly;
      default:
        return ProxyMode.global;
    }
  }

  @override
  void write(BinaryWriter writer, ProxyMode obj) {
    switch (obj) {
      case ProxyMode.global:
        writer.writeByte(0);
        break;
      case ProxyMode.schoolOnly:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ProxyModeAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
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
