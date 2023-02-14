// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ApplicationMsgCountAdapter extends TypeAdapter<ApplicationMsgCount> {
  @override
  final int typeId = 33;

  @override
  ApplicationMsgCount read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ApplicationMsgCount(
      fields[0] as int,
      fields[1] as int,
      fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ApplicationMsgCount obj) {
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
      other is ApplicationMsgCountAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ApplicationMsgAdapter extends TypeAdapter<ApplicationMsg> {
  @override
  final int typeId = 31;

  @override
  ApplicationMsg read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ApplicationMsg(
      fields[0] as int,
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
      fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ApplicationMsg obj) {
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
      other is ApplicationMsgAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ApplicationMsgPageAdapter extends TypeAdapter<ApplicationMsgPage> {
  @override
  final int typeId = 32;

  @override
  ApplicationMsgPage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ApplicationMsgPage(
      fields[0] as int,
      fields[1] as int,
      fields[2] as int,
      (fields[3] as List).cast<ApplicationMsg>(),
    );
  }

  @override
  void write(BinaryWriter writer, ApplicationMsgPage obj) {
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
      other is ApplicationMsgPageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ApplicationMessageTypeAdapter extends TypeAdapter<MessageType> {
  @override
  final int typeId = 34;

  @override
  MessageType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MessageType.todo;
      case 1:
        return MessageType.doing;
      case 2:
        return MessageType.done;
      default:
        return MessageType.todo;
    }
  }

  @override
  void write(BinaryWriter writer, MessageType obj) {
    switch (obj) {
      case MessageType.todo:
        writer.writeByte(0);
        break;
      case MessageType.doing:
        writer.writeByte(1);
        break;
      case MessageType.done:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApplicationMessageTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApplicationMsgCount _$ApplicationMsgCountFromJson(Map<String, dynamic> json) =>
    ApplicationMsgCount(
      json['myFlow_complete_count'] as int,
      json['myFlow_runing_count'] as int,
      json['myFlow_todo_count'] as int,
    );

Map<String, dynamic> _$ApplicationMsgCountToJson(
        ApplicationMsgCount instance) =>
    <String, dynamic>{
      'myFlow_complete_count': instance.completed,
      'myFlow_runing_count': instance.inProgress,
      'myFlow_todo_count': instance.inDraft,
    };

ApplicationMsg _$ApplicationMsgFromJson(Map<String, dynamic> json) =>
    ApplicationMsg(
      json['WorkID'] as int,
      json['FK_Flow'] as String,
      json['FlowName'] as String,
      json['NodeName'] as String,
      json['FlowNote'] as String,
    );

Map<String, dynamic> _$ApplicationMsgToJson(ApplicationMsg instance) =>
    <String, dynamic>{
      'WorkID': instance.flowId,
      'FK_Flow': instance.functionId,
      'FlowName': instance.name,
      'NodeName': instance.recentStep,
      'FlowNote': instance.status,
    };
