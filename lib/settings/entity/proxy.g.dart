// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'proxy.dart';

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
      address: json['address'] as String,
      enabled: json['enabled'] as bool,
      mode: $enumDecode(_$ProxyModeEnumMap, json['mode']),
    );

Map<String, dynamic> _$ProxyProfileToJson(ProxyProfile instance) => <String, dynamic>{
      'address': instance.address,
      'enabled': instance.enabled,
      'mode': _$ProxyModeEnumMap[instance.mode]!,
    };

const _$ProxyModeEnumMap = {
  ProxyMode.global: 'global',
  ProxyMode.schoolOnly: 'schoolOnly',
};
