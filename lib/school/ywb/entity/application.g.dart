// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class YwbApplicationAdapter extends TypeAdapter<YwbApplication> {
  @override
  final int typeId = 83;

  @override
  YwbApplication read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return YwbApplication(
      workId: fields[0] as int,
      functionId: fields[1] as String,
      name: fields[2] as String,
      note: fields[3] as String,
      startTs: fields[4] as DateTime,
      track: (fields[5] as List).cast<YwbApplicationTrack>(),
    );
  }

  @override
  void write(BinaryWriter writer, YwbApplication obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.workId)
      ..writeByte(1)
      ..write(obj.functionId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.note)
      ..writeByte(4)
      ..write(obj.startTs)
      ..writeByte(5)
      ..write(obj.track);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is YwbApplicationAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

YwbApplication _$YwbApplicationFromJson(Map<String, dynamic> json) => YwbApplication(
      workId: json['WorkID'] as int,
      functionId: json['FK_Flow'] as String,
      name: json['FlowName'] as String,
      note: json['FlowNote'] as String,
      startTs: _parseTimestamp(json['RDT']),
    );

YwbApplicationTrack _$YwbApplicationTrackFromJson(Map<String, dynamic> json) => YwbApplicationTrack(
      actionType: json['ActionType'] as int,
      action: json['ActionTypeText'] as String,
      senderId: json['EmpFrom'] as String,
      senderName: mapChinesePunctuations(json['EmpFromT'] as String),
      receiverId: json['EmpTo'] as String,
      receiverName: mapChinesePunctuations(json['EmpToT'] as String),
      message: mapChinesePunctuations(json['Msg'] as String),
      timestamp: _parseTimestamp(json['RDT']),
      step: mapChinesePunctuations(json['NDFromT'] as String),
    );
