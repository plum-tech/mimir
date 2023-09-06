import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mimir/hive/type_id.dart';

import '../using.dart';

part 'application.g.dart';

@JsonSerializable(createToJson: false)
@HiveType(typeId: HiveTypeId.applicationMeta)
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

  const ApplicationMeta(this.id, this.name, this.summary, this.status, this.count, this.iconName);

  factory ApplicationMeta.fromJson(Map<String, dynamic> json) => _$ApplicationMetaFromJson(json);
}

@JsonSerializable()
@HiveType(typeId: HiveTypeId.applicationDetailSection)
class ApplicationDetailSection {
  @JsonKey(name: 'formName')
  @HiveField(0)
  final String section;
  @HiveField(1)
  final String type;
  @HiveField(2)
  final DateTime createTime;
  @HiveField(3)
  final String content;

  const ApplicationDetailSection(this.section, this.type, this.createTime, this.content);

  factory ApplicationDetailSection.fromJson(Map<String, dynamic> json) => _$ApplicationDetailSectionFromJson(json);
}

extension ApplicationDetailSectionX on ApplicationDetailSection {
  bool get isEmpty => content.isEmpty;

  bool get isNotEmpty => content.isNotEmpty;
}

@HiveType(typeId: HiveTypeId.applicationDetail)
class ApplicationDetail {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final List<ApplicationDetailSection> sections;

  const ApplicationDetail(this.id, this.sections);
}
