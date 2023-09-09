// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ActivityAdapter extends TypeAdapter<Activity> {
  @override
  final int typeId = 31;

  @override
  Activity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Activity(
      fields[0] as int,
      fields[1] as ActivityType,
      fields[2] as String,
      fields[5] as DateTime,
      fields[3] as String,
      (fields[4] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Activity obj) {
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
      identical(this, other) || other is ActivityAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}

class ActivityTypeAdapter extends TypeAdapter<ActivityType> {
  @override
  final int typeId = 35;

  @override
  ActivityType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ActivityType.lecture;
      case 1:
        return ActivityType.thematicEdu;
      case 2:
        return ActivityType.creation;
      case 3:
        return ActivityType.schoolCulture;
      case 4:
        return ActivityType.practice;
      case 5:
        return ActivityType.voluntary;
      case 6:
        return ActivityType.cyberSafetyEdu;
      case 7:
        return ActivityType.unknown;
      default:
        return ActivityType.lecture;
    }
  }

  @override
  void write(BinaryWriter writer, ActivityType obj) {
    switch (obj) {
      case ActivityType.lecture:
        writer.writeByte(0);
        break;
      case ActivityType.thematicEdu:
        writer.writeByte(1);
        break;
      case ActivityType.creation:
        writer.writeByte(2);
        break;
      case ActivityType.schoolCulture:
        writer.writeByte(3);
        break;
      case ActivityType.practice:
        writer.writeByte(4);
        break;
      case ActivityType.voluntary:
        writer.writeByte(5);
        break;
      case ActivityType.cyberSafetyEdu:
        writer.writeByte(6);
        break;
      case ActivityType.unknown:
        writer.writeByte(7);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityTypeAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
