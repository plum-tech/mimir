// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserTypeAdapter extends TypeAdapter<UserType> {
  @override
  final int typeId = 31;

  @override
  UserType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return UserType.undergraduate;
      case 1:
        return UserType.postgraduate;
      case 2:
        return UserType.teacher;
      default:
        return UserType.undergraduate;
    }
  }

  @override
  void write(BinaryWriter writer, UserType obj) {
    switch (obj) {
      case UserType.undergraduate:
        writer.writeByte(0);
        break;
      case UserType.postgraduate:
        writer.writeByte(1);
        break;
      case UserType.teacher:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is UserTypeAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
