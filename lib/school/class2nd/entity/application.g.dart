// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class Class2ndActivityApplicationAdapter extends TypeAdapter<Class2ndActivityApplication> {
  @override
  final int typeId = 34;

  @override
  Class2ndActivityApplication read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Class2ndActivityApplication(
      applicationId: fields[0] as int,
      activityId: fields[1] as int,
      title: fields[2] as String,
      time: fields[3] as DateTime,
      status: fields[4] as String,
      category: fields[5] as Class2ndActivityCat,
    );
  }

  @override
  void write(BinaryWriter writer, Class2ndActivityApplication obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.applicationId)
      ..writeByte(1)
      ..write(obj.activityId)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.time)
      ..writeByte(4)
      ..write(obj.status)
      ..writeByte(5)
      ..write(obj.category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Class2ndActivityApplicationAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
