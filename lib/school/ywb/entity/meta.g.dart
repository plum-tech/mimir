// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meta.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class YwbApplicationMetaAdapter extends TypeAdapter<YwbApplicationMeta> {
  @override
  final int typeId = 82;

  @override
  YwbApplicationMeta read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return YwbApplicationMeta(
      id: fields[0] as String,
      name: fields[1] as String,
      summary: fields[2] as String,
      status: fields[3] as int,
      count: fields[4] as int,
      iconName: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, YwbApplicationMeta obj) {
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
      other is YwbApplicationMetaAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}

class YwbApplicationMetaDetailsAdapter extends TypeAdapter<YwbApplicationMetaDetails> {
  @override
  final int typeId = 80;

  @override
  YwbApplicationMetaDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return YwbApplicationMetaDetails(
      id: fields[0] as String,
      sections: (fields[1] as List).cast<YwbApplicationMetaDetailSection>(),
    );
  }

  @override
  void write(BinaryWriter writer, YwbApplicationMetaDetails obj) {
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
      other is YwbApplicationMetaDetailsAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}

class YwbApplicationMetaDetailSectionAdapter extends TypeAdapter<YwbApplicationMetaDetailSection> {
  @override
  final int typeId = 81;

  @override
  YwbApplicationMetaDetailSection read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return YwbApplicationMetaDetailSection(
      type: fields[1] as String,
      section: fields[0] as String,
      createTime: fields[2] as DateTime,
      content: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, YwbApplicationMetaDetailSection obj) {
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
      other is YwbApplicationMetaDetailSectionAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

YwbApplicationMeta _$YwbApplicationMetaFromJson(Map<String, dynamic> json) => YwbApplicationMeta(
      id: json['appID'] as String,
      name: json['appName'] as String,
      summary: json['appDescribe'] as String,
      status: json['appStatus'] as int,
      count: json['appCount'] as int,
      iconName: json['appIcon'] as String,
    );

YwbApplicationMetaDetailSection _$YwbApplicationMetaDetailSectionFromJson(Map<String, dynamic> json) =>
    YwbApplicationMetaDetailSection(
      type: json['type'] as String,
      section: json['formName'] as String,
      createTime: DateTime.parse(json['createTime'] as String),
      content: json['content'] as String,
    );
