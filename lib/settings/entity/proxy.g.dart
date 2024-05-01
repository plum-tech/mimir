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
