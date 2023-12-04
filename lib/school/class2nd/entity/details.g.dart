// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'details.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class Class2ndActivityDetailsAdapter extends TypeAdapter<Class2ndActivityDetails> {
  @override
  final int typeId = 31;

  @override
  Class2ndActivityDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Class2ndActivityDetails(
      id: fields[0] as int,
      title: fields[1] as String,
      startTime: fields[2] as DateTime,
      signStartTime: fields[3] as DateTime,
      signEndTime: fields[4] as DateTime,
      place: fields[5] as String?,
      duration: fields[6] as String?,
      principal: fields[7] as String?,
      contactInfo: fields[8] as String?,
      organizer: fields[9] as String?,
      undertaker: fields[10] as String?,
      description: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Class2ndActivityDetails obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.startTime)
      ..writeByte(3)
      ..write(obj.signStartTime)
      ..writeByte(4)
      ..write(obj.signEndTime)
      ..writeByte(5)
      ..write(obj.place)
      ..writeByte(6)
      ..write(obj.duration)
      ..writeByte(7)
      ..write(obj.principal)
      ..writeByte(8)
      ..write(obj.contactInfo)
      ..writeByte(9)
      ..write(obj.organizer)
      ..writeByte(10)
      ..write(obj.undertaker)
      ..writeByte(11)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Class2ndActivityDetailsAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
