// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

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
      fields[0] as int,
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
      fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, YwbApplication obj) {
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
      other is YwbApplicationAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

YwbApplication _$YwbApplicationFromJson(Map<String, dynamic> json) => YwbApplication(
      json['WorkID'] as int,
      json['FK_Flow'] as String,
      json['FlowName'] as String,
      json['NodeName'] as String,
      json['FlowNote'] as String,
    );

Map<String, dynamic> _$YwbApplicationToJson(YwbApplication instance) => <String, dynamic>{
      'WorkID': instance.flowId,
      'FK_Flow': instance.functionId,
      'FlowName': instance.name,
      'NodeName': instance.recentStep,
      'FlowNote': instance.status,
    };

YwbApplicationTrack _$YwbApplicationTrackFromJson(Map<String, dynamic> json) => YwbApplicationTrack(
      action: json['ActionTypeText'] as String,
      senderId: json['EmpFrom'] as String,
      senderName: json['EmpFromT'] as String,
      recieverId: json['EmpTo'] as String,
      recieverName: json['EmpToT'] as String,
      message: json['Msg'] as String,
      timestamp: _parseTimestamp(json['RDT']),
      step: json['NDFromT'] as String,
    );
