// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OaUserTypeAdapter extends TypeAdapter<OaUserType> {
  @override
  final int typeId = 6;

  @override
  OaUserType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return OaUserType.undergraduate;
      case 1:
        return OaUserType.postgraduate;
      case 2:
        return OaUserType.other;
      default:
        return OaUserType.undergraduate;
    }
  }

  @override
  void write(BinaryWriter writer, OaUserType obj) {
    switch (obj) {
      case OaUserType.undergraduate:
        writer.writeByte(0);
        break;
      case OaUserType.postgraduate:
        writer.writeByte(1);
        break;
      case OaUserType.other:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OaUserTypeAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
