import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mimir/hive/type_id.dart';
import 'package:mimir/utils/iconfont.dart';

part 'application.g.dart';

@JsonSerializable(createToJson: false)
@HiveType(typeId: HiveTypeYwb.meta)
class ApplicationMeta {
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

  const ApplicationMeta({
    required this.id,
    required this.name,
    required this.summary,
    required this.status,
    required this.count,
    required this.iconName,
  });

  factory ApplicationMeta.fromJson(Map<String, dynamic> json) => _$ApplicationMetaFromJson(json);
}

@HiveType(typeId: HiveTypeYwb.details)
class ApplicationDetails {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final List<ApplicationDetailSection> sections;

  const ApplicationDetails({
    required this.id,
    required this.sections,
  });
}

@JsonSerializable(createToJson: false)
@HiveType(typeId: HiveTypeYwb.detailSection)
class ApplicationDetailSection {
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

  const ApplicationDetailSection({
    required this.section,
    required this.type,
    required this.createTime,
    required this.content,
  });

  factory ApplicationDetailSection.fromJson(Map<String, dynamic> json) => _$ApplicationDetailSectionFromJson(json);
}

extension ApplicationDetailSectionX on ApplicationDetailSection {
  bool get isEmpty => content.isEmpty;

  bool get isNotEmpty => content.isNotEmpty;
}
