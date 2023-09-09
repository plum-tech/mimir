// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detail.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ActivityDetailAdapter extends TypeAdapter<ActivityDetail> {
  @override
  final int typeId = 51;

  @override
  ActivityDetail read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ActivityDetail(
      fields[0] as int,
      fields[1] as int,
      fields[2] as String,
      fields[3] as DateTime,
      fields[4] as DateTime,
      fields[5] as DateTime,
      fields[6] as String?,
      fields[7] as String?,
      fields[8] as String?,
      fields[9] as String?,
      fields[10] as String?,
      fields[11] as String?,
      fields[12] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ActivityDetail obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.category)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.startTime)
      ..writeByte(4)
      ..write(obj.signStartTime)
      ..writeByte(5)
      ..write(obj.signEndTime)
      ..writeByte(6)
      ..write(obj.place)
      ..writeByte(7)
      ..write(obj.duration)
      ..writeByte(8)
      ..write(obj.principal)
      ..writeByte(9)
      ..write(obj.contactInfo)
      ..writeByte(10)
      ..write(obj.organizer)
      ..writeByte(11)
      ..write(obj.undertaker)
      ..writeByte(12)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityDetailAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
