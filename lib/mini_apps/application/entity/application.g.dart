// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ApplicationMetaAdapter extends TypeAdapter<ApplicationMeta> {
  @override
  final int typeId = 63;

  @override
  ApplicationMeta read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ApplicationMeta(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
      fields[3] as int,
      fields[4] as int,
      fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ApplicationMeta obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.summary)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.count)
      ..writeByte(5)
      ..write(obj.iconName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApplicationMetaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ApplicationDetailSectionAdapter
    extends TypeAdapter<ApplicationDetailSection> {
  @override
  final int typeId = 62;

  @override
  ApplicationDetailSection read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ApplicationDetailSection(
      fields[0] as String,
      fields[1] as String,
      fields[2] as DateTime,
      fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ApplicationDetailSection obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.section)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.createTime)
      ..writeByte(3)
      ..write(obj.content);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApplicationDetailSectionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ApplicationDetailAdapter extends TypeAdapter<ApplicationDetail> {
  @override
  final int typeId = 61;

  @override
  ApplicationDetail read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ApplicationDetail(
      fields[0] as String,
      (fields[1] as List).cast<ApplicationDetailSection>(),
    );
  }

  @override
  void write(BinaryWriter writer, ApplicationDetail obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.sections);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApplicationDetailAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApplicationMeta _$ApplicationMetaFromJson(Map<String, dynamic> json) =>
    ApplicationMeta(
      json['appID'] as String,
      json['appName'] as String,
      json['appDescribe'] as String,
      json['appStatus'] as int,
      json['appCount'] as int,
      json['appIcon'] as String,
    );

ApplicationDetailSection _$ApplicationDetailSectionFromJson(
        Map<String, dynamic> json) =>
    ApplicationDetailSection(
      json['formName'] as String,
      json['type'] as String,
      DateTime.parse(json['createTime'] as String),
      json['content'] as String,
    );

Map<String, dynamic> _$ApplicationDetailSectionToJson(
        ApplicationDetailSection instance) =>
    <String, dynamic>{
      'formName': instance.section,
      'type': instance.type,
      'createTime': instance.createTime.toIso8601String(),
      'content': instance.content,
    };
