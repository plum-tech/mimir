import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mimir/hive/type_id.dart';
import 'package:mimir/utils/iconfont.dart';

part 'application.g.dart';

@JsonSerializable(createToJson: false)
@HiveType(typeId: HiveTypeYwb.meta)
class YwbApplicationMeta {
  @JsonKey(name: 'appID')
  @HiveField(0)
  final String id;
  @JsonKey(name: 'appName')
  @HiveField(1)
  final String name;
  @JsonKey(name: 'appDescribe')
  @HiveField(2)
  final String summary;
  @JsonKey(name: 'appStatus')
  @HiveField(3)
  final int status;
  @JsonKey(name: 'appCount')
  @HiveField(4)
  final int count;
  @JsonKey(name: 'appIcon')
  @HiveField(5)
  final String iconName;

  IconData get icon => IconFont.query(iconName);

  const YwbApplicationMeta({
    required this.id,
    required this.name,
    required this.summary,
    required this.status,
    required this.count,
    required this.iconName,
  });

  factory YwbApplicationMeta.fromJson(Map<String, dynamic> json) => _$YwbApplicationMetaFromJson(json);
}

@HiveType(typeId: HiveTypeYwb.metaDetails)
class YwbApplicationMetaDetails {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final List<YwbApplicationMetaDetailSection> sections;

  const YwbApplicationMetaDetails({
    required this.id,
    required this.sections,
  });
}

@JsonSerializable(createToJson: false)
@HiveType(typeId: HiveTypeYwb.metaDetailSection)
class YwbApplicationMetaDetailSection {
  @JsonKey(name: 'formName')
  @HiveField(0)
  final String section;
  @JsonKey()
  @HiveField(1)
  final String type;
  @JsonKey()
  @HiveField(2)
  final DateTime createTime;
  @JsonKey()
  @HiveField(3)
  final String content;

  const YwbApplicationMetaDetailSection({
    required this.section,
    required this.type,
    required this.createTime,
    required this.content,
  });

  factory YwbApplicationMetaDetailSection.fromJson(Map<String, dynamic> json) =>
      _$YwbApplicationMetaDetailSectionFromJson(json);
}

extension YwbApplicationMetaDetailSectionX on YwbApplicationMetaDetailSection {
  bool get isEmpty => content.isEmpty;

  bool get isNotEmpty => content.isNotEmpty;
}
