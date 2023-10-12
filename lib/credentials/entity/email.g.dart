// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'email.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EmailCredentialsAdapter extends TypeAdapter<EmailCredentials> {
  @override
  final int typeId = 22;

  @override
  EmailCredentials read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EmailCredentials(
      address: fields[0] as String,
      password: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, EmailCredentials obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.address)
      ..writeByte(1)
      ..write(obj.password);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmailCredentialsAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
