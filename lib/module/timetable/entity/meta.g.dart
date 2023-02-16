// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meta.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TimetableMetaLegacyAdapter extends TypeAdapter<TimetableMetaLegacy> {
  @override
  final int typeId = 8;

  @override
  TimetableMetaLegacy read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TimetableMetaLegacy()
      ..name = fields[0] as String
      ..description = fields[1] as String
      ..startDate = fields[2] as DateTime
      ..schoolYear = fields[3] as int
      ..semester = fields[4] as int;
  }

  @override
  void write(BinaryWriter writer, TimetableMetaLegacy obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.startDate)
      ..writeByte(3)
      ..write(obj.schoolYear)
      ..writeByte(4)
      ..write(obj.semester);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimetableMetaLegacyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
