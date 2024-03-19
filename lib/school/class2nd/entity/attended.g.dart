// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attended.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class Class2ndPointsSummaryAdapter extends TypeAdapter<Class2ndPointsSummary> {
  @override
  final int typeId = 33;

  @override
  Class2ndPointsSummary read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Class2ndPointsSummary(
      thematicReport: fields[0] as double,
      practice: fields[1] as double,
      creation: fields[2] as double,
      schoolSafetyCivilization: fields[3] as double,
      voluntary: fields[4] as double,
      schoolCulture: fields[5] as double,
      honestyPoints: fields[6] as double,
      totalPoints: fields[7] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Class2ndPointsSummary obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.thematicReport)
      ..writeByte(1)
      ..write(obj.practice)
      ..writeByte(2)
      ..write(obj.creation)
      ..writeByte(3)
      ..write(obj.schoolSafetyCivilization)
      ..writeByte(4)
      ..write(obj.voluntary)
      ..writeByte(5)
      ..write(obj.schoolCulture)
      ..writeByte(6)
      ..write(obj.honestyPoints)
      ..writeByte(7)
      ..write(obj.totalPoints);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Class2ndPointsSummaryAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}

class Class2ndPointItemAdapter extends TypeAdapter<Class2ndPointItem> {
  @override
  final int typeId = 35;

  @override
  Class2ndPointItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Class2ndPointItem(
      name: fields[0] as String,
      activityId: fields[1] as int,
      category: fields[2] as Class2ndActivityCat,
      time: fields[3] as DateTime?,
      points: fields[4] as double,
      honestyPoints: fields[5] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Class2ndPointItem obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.activityId)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.time)
      ..writeByte(4)
      ..write(obj.points)
      ..writeByte(5)
      ..write(obj.honestyPoints);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Class2ndPointItemAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}

class Class2ndPointTypeAdapter extends TypeAdapter<Class2ndPointType> {
  @override
  final int typeId = 36;

  @override
  Class2ndPointType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Class2ndPointType.thematicReport;
      case 1:
        return Class2ndPointType.creation;
      case 2:
        return Class2ndPointType.schoolCulture;
      case 3:
        return Class2ndPointType.practice;
      case 4:
        return Class2ndPointType.voluntary;
      case 5:
        return Class2ndPointType.schoolSafetyCivilization;
      default:
        return Class2ndPointType.thematicReport;
    }
  }

  @override
  void write(BinaryWriter writer, Class2ndPointType obj) {
    switch (obj) {
      case Class2ndPointType.thematicReport:
        writer.writeByte(0);
        break;
      case Class2ndPointType.creation:
        writer.writeByte(1);
        break;
      case Class2ndPointType.schoolCulture:
        writer.writeByte(2);
        break;
      case Class2ndPointType.practice:
        writer.writeByte(3);
        break;
      case Class2ndPointType.voluntary:
        writer.writeByte(4);
        break;
      case Class2ndPointType.schoolSafetyCivilization:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Class2ndPointTypeAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
