// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'school.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SemesterAdapter extends TypeAdapter<Semester> {
  @override
  final int typeId = 7;

  @override
  Semester read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Semester.all;
      case 1:
        return Semester.term1;
      case 2:
        return Semester.term2;
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
      case Semester.term1:
        writer.writeByte(1);
        break;
      case Semester.term2:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is SemesterAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
