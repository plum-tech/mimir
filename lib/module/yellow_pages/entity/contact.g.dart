// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ContactDataAdapter extends TypeAdapter<ContactData> {
  @override
  final int typeId = 10;

  @override
  ContactData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ContactData(
      fields[0] as String,
      fields[1] as String?,
      fields[2] as String?,
      fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ContactData obj) {
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
      other is ContactDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContactData _$ContactDataFromJson(Map<String, dynamic> json) => ContactData(
      json['department'] as String,
      json['description'] as String?,
      json['name'] as String?,
      json['phone'] as String,
    );

Map<String, dynamic> _$ContactDataToJson(ContactData instance) =>
    <String, dynamic>{
      'department': instance.department,
      'description': instance.description,
      'name': instance.name,
      'phone': instance.phone,
    };
