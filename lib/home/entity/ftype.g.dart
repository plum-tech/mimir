// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ftype.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FTypeAdapter extends TypeAdapter<FType> {
  @override
  final int typeId = 7;

  @override
  FType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return FType.separator;
      case 1:
        return FType.timetable;
      case 2:
        return FType.reportTemp;
      case 3:
        return FType.examArr;
      case 4:
        return FType.activity;
      case 5:
        return FType.expense;
      case 6:
        return FType.examResult;
      case 7:
        return FType.library;
      case 8:
        return FType.application;
      case 9:
        return FType.eduEmail;
      case 10:
        return FType.oaAnnouncement;
      case 11:
        return FType.yellowPages;
      case 13:
        return FType.scanner;
      case 14:
        return FType.electricityBill;
      default:
        return FType.separator;
    }
  }

  @override
  void write(BinaryWriter writer, FType obj) {
    switch (obj) {
      case FType.separator:
        writer.writeByte(0);
        break;
      case FType.timetable:
        writer.writeByte(1);
        break;
      case FType.reportTemp:
        writer.writeByte(2);
        break;
      case FType.examArr:
        writer.writeByte(3);
        break;
      case FType.activity:
        writer.writeByte(4);
        break;
      case FType.expense:
        writer.writeByte(5);
        break;
      case FType.examResult:
        writer.writeByte(6);
        break;
      case FType.library:
        writer.writeByte(7);
        break;
      case FType.application:
        writer.writeByte(8);
        break;
      case FType.eduEmail:
        writer.writeByte(9);
        break;
      case FType.oaAnnouncement:
        writer.writeByte(10);
        break;
      case FType.yellowPages:
        writer.writeByte(11);
        break;
      case FType.scanner:
        writer.writeByte(13);
        break;
      case FType.electricityBill:
        writer.writeByte(14);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
