// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ApplicationMetaAdapter extends TypeAdapter<ApplicationMeta> {
  @override
  final int typeId = 82;

  @override
  ApplicationMeta read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ApplicationMeta(
      id: fields[0] as String,
      name: fields[1] as String,
      summary: fields[2] as String,
      status: fields[3] as int,
      count: fields[4] as int,
      iconName: fields[5] as String,
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
      other is ApplicationMetaAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}

class ApplicationDetailsAdapter extends TypeAdapter<ApplicationDetails> {
  @override
  final int typeId = 80;

  @override
  ApplicationDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ApplicationDetails(
      id: fields[0] as String,
      sections: (fields[1] as List).cast<ApplicationDetailSection>(),
    );
  }

  @override
  void write(BinaryWriter writer, ApplicationDetails obj) {
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
      other is ApplicationDetailsAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}

class ApplicationDetailSectionAdapter extends TypeAdapter<ApplicationDetailSection> {
  @override
  final int typeId = 81;

  @override
  ApplicationDetailSection read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ApplicationDetailSection(
      section: fields[0] as String,
      type: fields[1] as String,
      createTime: fields[2] as DateTime,
      content: fields[3] as String,
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
      other is ApplicationDetailSectionAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApplicationMeta _$ApplicationMetaFromJson(Map<String, dynamic> json) => ApplicationMeta(
      id: json['appID'] as String,
      name: json['appName'] as String,
      summary: json['appDescribe'] as String,
      status: json['appStatus'] as int,
      count: json['appCount'] as int,
      iconName: json['appIcon'] as String,
    );

ApplicationDetailSection _$ApplicationDetailSectionFromJson(Map<String, dynamic> json) => ApplicationDetailSection(
      section: json['formName'] as String,
      type: json['type'] as String,
      createTime: DateTime.parse(json['createTime'] as String),
      content: json['content'] as String,
    );
