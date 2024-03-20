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
      status: fields[4] as Class2ndActivityApplicationStatus,
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

class Class2ndActivityApplicationStatusAdapter extends TypeAdapter<Class2ndActivityApplicationStatus> {
  @override
  final int typeId = 35;

  @override
  Class2ndActivityApplicationStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Class2ndActivityApplicationStatus.unknown;
      case 1:
        return Class2ndActivityApplicationStatus.approved;
      case 2:
        return Class2ndActivityApplicationStatus.rejected;
      case 3:
        return Class2ndActivityApplicationStatus.withdrawn;
      case 4:
        return Class2ndActivityApplicationStatus.activityCancelled;
      case 5:
        return Class2ndActivityApplicationStatus.reviewing;
      default:
        return Class2ndActivityApplicationStatus.unknown;
    }
  }

  @override
  void write(BinaryWriter writer, Class2ndActivityApplicationStatus obj) {
    switch (obj) {
      case Class2ndActivityApplicationStatus.unknown:
        writer.writeByte(0);
        break;
      case Class2ndActivityApplicationStatus.approved:
        writer.writeByte(1);
        break;
      case Class2ndActivityApplicationStatus.rejected:
        writer.writeByte(2);
        break;
      case Class2ndActivityApplicationStatus.withdrawn:
        writer.writeByte(3);
        break;
      case Class2ndActivityApplicationStatus.activityCancelled:
        writer.writeByte(4);
        break;
      case Class2ndActivityApplicationStatus.reviewing:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Class2ndActivityApplicationStatusAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
