// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ApplicationMessageCountAdapter extends TypeAdapter<ApplicationMessageCount> {
  @override
  final int typeId = 85;

  @override
  ApplicationMessageCount read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ApplicationMessageCount(
      fields[0] as int,
      fields[1] as int,
      fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ApplicationMessageCount obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.completed)
      ..writeByte(1)
      ..write(obj.inProgress)
      ..writeByte(2)
      ..write(obj.inDraft);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApplicationMessageCountAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}

class ApplicationMessageAdapter extends TypeAdapter<ApplicationMessage> {
  @override
  final int typeId = 83;

  @override
  ApplicationMessage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ApplicationMessage(
      fields[0] as int,
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
      fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ApplicationMessage obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.flowId)
      ..writeByte(1)
      ..write(obj.functionId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.recentStep)
      ..writeByte(4)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApplicationMessageAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}

class ApplicationMessagePageAdapter extends TypeAdapter<ApplicationMessagePage> {
  @override
  final int typeId = 84;

  @override
  ApplicationMessagePage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ApplicationMessagePage(
      fields[0] as int,
      fields[1] as int,
      fields[2] as int,
      (fields[3] as List).cast<ApplicationMessage>(),
    );
  }

  @override
  void write(BinaryWriter writer, ApplicationMessagePage obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.totalNum)
      ..writeByte(1)
      ..write(obj.totalPage)
      ..writeByte(2)
      ..write(obj.currentPage)
      ..writeByte(3)
      ..write(obj.msgList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApplicationMessagePageAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}

class ApplicationMessageTypeAdapter extends TypeAdapter<ApplicationMessageType> {
  @override
  final int typeId = 86;

  @override
  ApplicationMessageType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ApplicationMessageType.todo;
      case 1:
        return ApplicationMessageType.doing;
      case 2:
        return ApplicationMessageType.done;
      default:
        return ApplicationMessageType.todo;
    }
  }

  @override
  void write(BinaryWriter writer, ApplicationMessageType obj) {
    switch (obj) {
      case ApplicationMessageType.todo:
        writer.writeByte(0);
        break;
      case ApplicationMessageType.doing:
        writer.writeByte(1);
        break;
      case ApplicationMessageType.done:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApplicationMessageTypeAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApplicationMessageCount _$ApplicationMessageCountFromJson(Map<String, dynamic> json) => ApplicationMessageCount(
      json['myFlow_complete_count'] as int,
      json['myFlow_runing_count'] as int,
      json['myFlow_todo_count'] as int,
    );

Map<String, dynamic> _$ApplicationMessageCountToJson(ApplicationMessageCount instance) => <String, dynamic>{
      'myFlow_complete_count': instance.completed,
      'myFlow_runing_count': instance.inProgress,
      'myFlow_todo_count': instance.inDraft,
    };

ApplicationMessage _$ApplicationMessageFromJson(Map<String, dynamic> json) => ApplicationMessage(
      json['WorkID'] as int,
      json['FK_Flow'] as String,
      json['FlowName'] as String,
      json['NodeName'] as String,
      json['FlowNote'] as String,
    );

Map<String, dynamic> _$ApplicationMessageToJson(ApplicationMessage instance) => <String, dynamic>{
      'WorkID': instance.flowId,
      'FK_Flow': instance.functionId,
      'FlowName': instance.name,
      'NodeName': instance.recentStep,
      'FlowNote': instance.status,
    };
