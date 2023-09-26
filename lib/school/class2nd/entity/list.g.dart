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
      id: fields[0] as int,
      category: fields[1] as Class2ndActivityCat,
      title: fields[2] as String,
      ts: fields[5] as DateTime,
      realTitle: fields[3] as String,
      tags: (fields[4] as List).cast<String>(),
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

class Class2ndActivityCatAdapter extends TypeAdapter<Class2ndActivityCat> {
  @override
  final int typeId = 52;

  @override
  Class2ndActivityCat read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Class2ndActivityCat.lecture;
      case 1:
        return Class2ndActivityCat.thematicEdu;
      case 2:
        return Class2ndActivityCat.creation;
      case 3:
        return Class2ndActivityCat.schoolCulture;
      case 4:
        return Class2ndActivityCat.practice;
      case 5:
        return Class2ndActivityCat.voluntary;
      case 6:
        return Class2ndActivityCat.cyberSafetyEdu;
      case 7:
        return Class2ndActivityCat.unknown;
      default:
        return Class2ndActivityCat.lecture;
    }
  }

  @override
  void write(BinaryWriter writer, Class2ndActivityCat obj) {
    switch (obj) {
      case Class2ndActivityCat.lecture:
        writer.writeByte(0);
        break;
      case Class2ndActivityCat.thematicEdu:
        writer.writeByte(1);
        break;
      case Class2ndActivityCat.creation:
        writer.writeByte(2);
        break;
      case Class2ndActivityCat.schoolCulture:
        writer.writeByte(3);
        break;
      case Class2ndActivityCat.practice:
        writer.writeByte(4);
        break;
      case Class2ndActivityCat.voluntary:
        writer.writeByte(5);
        break;
      case Class2ndActivityCat.cyberSafetyEdu:
        writer.writeByte(6);
        break;
      case Class2ndActivityCat.unknown:
        writer.writeByte(7);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Class2ndActivityCatAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
