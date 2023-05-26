// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'miniApp.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MiniAppAdapter extends TypeAdapter<MiniApp> {
  @override
  final int typeId = 6;

  @override
  MiniApp read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MiniApp.separator;
      case 1:
        return MiniApp.timetable;
      case 2:
        return MiniApp.examArr;
      case 3:
        return MiniApp.activity;
      case 4:
        return MiniApp.expense;
      case 5:
        return MiniApp.examResult;
      case 6:
        return MiniApp.library;
      case 7:
        return MiniApp.application;
      case 8:
        return MiniApp.eduEmail;
      case 9:
        return MiniApp.oaAnnouncement;
      case 10:
        return MiniApp.yellowPages;
      case 11:
        return MiniApp.elecBill;
      default:
        return MiniApp.separator;
    }
  }

  @override
  void write(BinaryWriter writer, MiniApp obj) {
    switch (obj) {
      case MiniApp.separator:
        writer.writeByte(0);
        break;
      case MiniApp.timetable:
        writer.writeByte(1);
        break;
      case MiniApp.examArr:
        writer.writeByte(2);
        break;
      case MiniApp.activity:
        writer.writeByte(3);
        break;
      case MiniApp.expense:
        writer.writeByte(4);
        break;
      case MiniApp.examResult:
        writer.writeByte(5);
        break;
      case MiniApp.library:
        writer.writeByte(6);
        break;
      case MiniApp.application:
        writer.writeByte(7);
        break;
      case MiniApp.eduEmail:
        writer.writeByte(8);
        break;
      case MiniApp.oaAnnouncement:
        writer.writeByte(9);
        break;
      case MiniApp.yellowPages:
        writer.writeByte(10);
        break;
      case MiniApp.elecBill:
        writer.writeByte(11);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MiniAppAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
