// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_status.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LoginStatusAdapter extends TypeAdapter<LoginStatus> {
  @override
  final int typeId = 5;

  @override
  LoginStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return LoginStatus.never;
      case 2:
        return LoginStatus.offline;
      case 3:
        return LoginStatus.validated;
      case 4:
        return LoginStatus.everLogin;
      default:
        return LoginStatus.never;
    }
  }

  @override
  void write(BinaryWriter writer, LoginStatus obj) {
    switch (obj) {
      case LoginStatus.never:
        writer.writeByte(0);
        break;
      case LoginStatus.offline:
        writer.writeByte(2);
        break;
      case LoginStatus.validated:
        writer.writeByte(3);
        break;
      case LoginStatus.everLogin:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoginStatusAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
