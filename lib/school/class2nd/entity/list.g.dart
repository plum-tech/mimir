// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class Class2ndActivityAdapter extends TypeAdapter<Class2ndActivity> {
  @override
  final int typeId = 10;

  @override
  Class2ndActivity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Class2ndActivity(
      id: fields[0] as int,
      title: fields[1] as String,
      time: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Class2ndActivity obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.time);
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
  final int typeId = 12;

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
        return Class2ndActivityCat.schoolCultureActivity;
      case 4:
        return Class2ndActivityCat.schoolCivilization;
      case 5:
        return Class2ndActivityCat.practice;
      case 6:
        return Class2ndActivityCat.voluntary;
      case 7:
        return Class2ndActivityCat.onlineSafetyEdu;
      case 8:
        return Class2ndActivityCat.conference;
      case 9:
        return Class2ndActivityCat.schoolCultureCompetition;
      case 10:
        return Class2ndActivityCat.paperAndPatent;
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
      case Class2ndActivityCat.schoolCultureActivity:
        writer.writeByte(3);
        break;
      case Class2ndActivityCat.schoolCivilization:
        writer.writeByte(4);
        break;
      case Class2ndActivityCat.practice:
        writer.writeByte(5);
        break;
      case Class2ndActivityCat.voluntary:
        writer.writeByte(6);
        break;
      case Class2ndActivityCat.onlineSafetyEdu:
        writer.writeByte(7);
        break;
      case Class2ndActivityCat.conference:
        writer.writeByte(8);
        break;
      case Class2ndActivityCat.schoolCultureCompetition:
        writer.writeByte(9);
        break;
      case Class2ndActivityCat.paperAndPatent:
        writer.writeByte(10);
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
