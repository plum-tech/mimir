// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class Class2ndActivityAdapter extends TypeAdapter<Class2ndActivity> {
  @override
  final int typeId = 50;

  @override
  Class2ndActivity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Class2ndActivity(
      fields[0] as int,
      fields[1] as Class2ndActivityType,
      fields[2] as String,
      fields[5] as DateTime,
      fields[3] as String,
      (fields[4] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Class2ndActivity obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.category)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.realTitle)
      ..writeByte(4)
      ..write(obj.tags)
      ..writeByte(5)
      ..write(obj.ts);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Class2ndActivityAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}

class Class2ndActivityTypeAdapter extends TypeAdapter<Class2ndActivityType> {
  @override
  final int typeId = 52;

  @override
  Class2ndActivityType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Class2ndActivityType.lecture;
      case 1:
        return Class2ndActivityType.thematicEdu;
      case 2:
        return Class2ndActivityType.creation;
      case 3:
        return Class2ndActivityType.schoolCulture;
      case 4:
        return Class2ndActivityType.practice;
      case 5:
        return Class2ndActivityType.voluntary;
      case 6:
        return Class2ndActivityType.cyberSafetyEdu;
      case 7:
        return Class2ndActivityType.unknown;
      default:
        return Class2ndActivityType.lecture;
    }
  }

  @override
  void write(BinaryWriter writer, Class2ndActivityType obj) {
    switch (obj) {
      case Class2ndActivityType.lecture:
        writer.writeByte(0);
        break;
      case Class2ndActivityType.thematicEdu:
        writer.writeByte(1);
        break;
      case Class2ndActivityType.creation:
        writer.writeByte(2);
        break;
      case Class2ndActivityType.schoolCulture:
        writer.writeByte(3);
        break;
      case Class2ndActivityType.practice:
        writer.writeByte(4);
        break;
      case Class2ndActivityType.voluntary:
        writer.writeByte(5);
        break;
      case Class2ndActivityType.cyberSafetyEdu:
        writer.writeByte(6);
        break;
      case Class2ndActivityType.unknown:
        writer.writeByte(7);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Class2ndActivityTypeAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
