import 'dart:core';

import 'package:easy_localization/easy_localization.dart';

import 'list.dart';
import 'package:mimir/hive/type_id.dart';

part 'attended.g.dart';

@HiveType(typeId: HiveTypeClass2nd.scoreSummary)
class Class2ndScoreSummary {
  /// 主题报告
  @HiveField(0)
  final double thematicReport;

  /// 社会实践
  @HiveField(1)
  final double practice;

  /// 创新创业创意
  @HiveField(2)
  final double creation;

  /// 校园安全文明
  @HiveField(3)
  final double schoolSafetyCivilization;

  /// 公益志愿
  @HiveField(4)
  final double voluntary;

  /// 校园文化
  @HiveField(5)
  final double schoolCulture;

  const Class2ndScoreSummary({
    this.thematicReport = 0,
    this.practice = 0,
    this.creation = 0,
    this.schoolSafetyCivilization = 0,
    this.voluntary = 0,
    this.schoolCulture = 0,
  });

  @override
  String toString() {
    return {
      "lecture": thematicReport,
      "practice": practice,
      "creation": creation,
      "safetyEdu": schoolSafetyCivilization,
      "voluntary": voluntary,
      "schoolCulture": schoolCulture,
    }.toString();
  }

  List<({Class2ndActivityScoreType type, double score})> toName2score() {
    return [
      (type: Class2ndActivityScoreType.voluntary, score: voluntary),
      (type: Class2ndActivityScoreType.schoolCulture, score: schoolCulture),
      (type: Class2ndActivityScoreType.creation, score: creation),
      (type: Class2ndActivityScoreType.schoolSafetyCivilization, score: schoolSafetyCivilization),
      (type: Class2ndActivityScoreType.thematicReport, score: thematicReport),
      (type: Class2ndActivityScoreType.practice, score: practice),
    ];
  }
}

@HiveType(typeId: HiveTypeClass2nd.scoreItem)
class Class2ndScoreItem {
  /// 活动名称
  @HiveField(0)
  final String name;

  /// 活动编号
  @HiveField(1)
  final int activityId;

  /// 活动类型
  @HiveField(2)
  final Class2ndActivityCat category;

  /// 活动时间
  @HiveField(3)
  final DateTime time;

  /// 得分
  @HiveField(4)
  final double points;

  /// 诚信分
  @HiveField(5)
  final double honestyPoints;

  const Class2ndScoreItem({
    required this.name,
    required this.activityId,
    required this.category,
    required this.time,
    required this.points,
    required this.honestyPoints,
  });

  @override
  String toString() {
    return {
      "name": name,
      "activityId": activityId,
      "category": category,
      "time": time,
      "points": points,
      "honestyPoints": honestyPoints,
    }.toString();
  }
}

@HiveType(typeId: HiveTypeClass2nd.activityApplication)
class Class2ndActivityApplication {
  /// 申请编号
  @HiveField(0)
  final int applyId;

  /// 活动编号
  /// -1 if the activity was cancelled.
  @HiveField(1)
  final int activityId;

  /// 活动标题
  @HiveField(2)
  final String title;

  /// 申请时间
  @HiveField(3)
  final DateTime time;

  /// 活动状态
  @HiveField(4)
  final String status;

  @HiveField(5)
  final Class2ndActivityCat category;

  Class2ndActivityApplication({
    required this.applyId,
    required this.activityId,
    required this.title,
    required this.time,
    required this.status,
    required this.category,
  });

  @override
  String toString() {
    return {
      "applyId": applyId,
      "activityId": activityId,
      "title": title,
      "time": time,
      "status": status,
      "category": category,
    }.toString();
  }
}

@HiveType(typeId: HiveTypeClass2nd.scoreType)
enum Class2ndActivityScoreType {
  /// 讲座报告
  @HiveField(0)
  thematicReport,

  /// 创新创业创意
  @HiveField(1)
  creation,

  /// 校园文化
  @HiveField(2)
  schoolCulture,

  /// 社会实践
  @HiveField(3)
  practice,

  /// 志愿公益
  @HiveField(4)
  voluntary,

  /// 校园安全文明
  @HiveField(5)
  schoolSafetyCivilization;

  const Class2ndActivityScoreType();

  String l10nShortName() => "class2nd.scoreType.$name.short".tr();

  String l10nFullName() => "class2nd.scoreType.$name.full".tr();

  static Class2ndActivityScoreType? parse(String typeName) {
    if (typeName == "主题报告") {
      return Class2ndActivityScoreType.thematicReport;
    } else if (typeName == "社会实践") {
      return Class2ndActivityScoreType.practice;
    } else if (typeName == "创新创业创意") {
      return Class2ndActivityScoreType.creation;
    } else if (typeName == "校园文化") {
      return Class2ndActivityScoreType.schoolCulture;
    } else if (typeName == "公益志愿") {
      return Class2ndActivityScoreType.voluntary;
    } else if (typeName == "校园安全文明") {
      return Class2ndActivityScoreType.schoolSafetyCivilization;
    }
    return null;
  }
}

@HiveType(typeId: HiveTypeClass2nd.attendedActivity)
class Class2ndAttendedActivity {
  /// 申请编号
  @HiveField(0)
  final int applyId;

  /// 活动编号
  @HiveField(1)
  final int activityId;

  /// 活动标题
  @HiveField(2)
  final String title;

  /// 申请时间
  @HiveField(3)
  final DateTime time;

  /// 申请时间
  @HiveField(4)
  final Class2ndActivityCat category;

  /// 活动状态
  @HiveField(5)
  final String status;

  /// 总得分
  @HiveField(6)
  final double? points;

  /// 总诚信分
  @HiveField(7)
  final double? honestyPoints;

  const Class2ndAttendedActivity({
    required this.applyId,
    required this.activityId,
    required this.title,
    required this.time,
    required this.category,
    required this.status,
    required this.points,
    required this.honestyPoints,
  });

  bool get isPassed => status == "通过";

  @override
  String toString() {
    return {
      "applyId": applyId,
      "activityId": activityId,
      "title": title,
      "time": time,
      "category": category,
      "status": status,
      "points": points,
      "honestyPoints": honestyPoints,
    }.toString();
  }
}
