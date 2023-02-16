// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'school.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SchoolYearAdapter extends TypeAdapter<SchoolYear> {
  @override
  final int typeId = 37;

  @override
  SchoolYear read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SchoolYear(
      fields[0] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, SchoolYear obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.year);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SchoolYearAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SemesterAdapter extends TypeAdapter<Semester> {
  @override
  final int typeId = 36;

  @override
  Semester read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Semester.all;
      case 1:
        return Semester.term1st;
      case 2:
        return Semester.term2rd;
      default:
        return Semester.all;
    }
  }

  @override
  void write(BinaryWriter writer, Semester obj) {
    switch (obj) {
      case Semester.all:
        writer.writeByte(0);
        break;
      case Semester.term1st:
        writer.writeByte(1);
        break;
      case Semester.term2rd:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SemesterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
