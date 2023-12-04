// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SchoolContactAdapter extends TypeAdapter<SchoolContact> {
  @override
  final int typeId = 100;

  @override
  SchoolContact read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SchoolContact(
      fields[0] as String,
      fields[1] as String?,
      fields[2] as String?,
      fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SchoolContact obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.department)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.phone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SchoolContactAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SchoolContact _$SchoolContactFromJson(Map<String, dynamic> json) => SchoolContact(
      json['department'] as String,
      json['description'] as String?,
      json['name'] as String?,
      json['phone'] as String,
    );
