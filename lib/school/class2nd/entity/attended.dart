import 'dart:core';

import 'package:easy_localization/easy_localization.dart';

import 'list.dart';
import 'package:sit/storage/hive/type_id.dart';

part 'attended.g.dart';

@HiveType(typeId: CacheHiveType.class2ndPointsSummary)
class Class2ndPointsSummary {
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

  /// 诚信积分
  @HiveField(6)
  final double honestyPoints;

  /// Total points
  @HiveField(7)
  final double totalPoints;

  const Class2ndPointsSummary({
    this.thematicReport = 0,
    this.practice = 0,
    this.creation = 0,
    this.schoolSafetyCivilization = 0,
    this.voluntary = 0,
    this.schoolCulture = 0,
    this.honestyPoints = 0,
    this.totalPoints = 0,
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
      "honestyPoints": honestyPoints,
    }.toString();
  }

  List<({Class2ndPointType type, double score})> toName2score() {
    return [
      (type: Class2ndPointType.voluntary, score: voluntary),
      (type: Class2ndPointType.schoolCulture, score: schoolCulture),
      (type: Class2ndPointType.creation, score: creation),
      (type: Class2ndPointType.schoolSafetyCivilization, score: schoolSafetyCivilization),
      (type: Class2ndPointType.thematicReport, score: thematicReport),
      (type: Class2ndPointType.practice, score: practice),
    ];
  }
}

@HiveType(typeId: CacheHiveType.class2ndPointItem)
class Class2ndPointItem {
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
  final DateTime? time;

  /// 得分
  @HiveField(4)
  final double points;

  /// 诚信分
  @HiveField(5)
  final double honestyPoints;

  Class2ndPointType? get pointType => category.pointType;

  const Class2ndPointItem({
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

@HiveType(typeId: CacheHiveType.class2ndActivityApplication)
class Class2ndActivityApplication {
  /// 申请编号
  @HiveField(0)
  final int applicationId;

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

  const Class2ndActivityApplication({
    required this.applicationId,
    required this.activityId,
    required this.title,
    required this.time,
    required this.status,
    required this.category,
  });

  bool get isPassed => status == "通过";

  @override
  String toString() {
    return {
      "applyId": applicationId,
      "activityId": activityId,
      "title": title,
      "time": time,
      "status": status,
      "category": category,
    }.toString();
  }
}

@HiveType(typeId: CacheHiveType.class2ndScoreType)
enum Class2ndPointType {
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

  const Class2ndPointType();

  String l10nShortName() => "class2nd.scoreType.$name.short".tr();

  String l10nFullName() => "class2nd.scoreType.$name.full".tr();

  static String allCatL10n() => "class2nd.scoreType.all".tr();

  static Class2ndPointType? parse(String typeName) {
    if (typeName == "主题报告") {
      return Class2ndPointType.thematicReport;
    } else if (typeName == "社会实践") {
      return Class2ndPointType.practice;
    } else if (typeName == "创新创业创意") {
      return Class2ndPointType.creation;
    } else if (typeName == "校园文化") {
      return Class2ndPointType.schoolCulture;
    } else if (typeName == "公益志愿") {
      return Class2ndPointType.voluntary;
    } else if (typeName == "校园安全文明") {
      return Class2ndPointType.schoolSafetyCivilization;
    }
    return null;
  }
}

class Class2ndAttendedActivity {
  final Class2ndActivityApplication application;
  final List<Class2ndPointItem> scores;

  double? calcTotalPoints() {
    if (scores.isEmpty) return null;
    return scores.fold<double>(0.0, (pre, e) => pre + e.points);
  }

  double? calcTotalHonestyPoints() {
    if (scores.isEmpty) return null;
    return scores.fold<double>(0.0, (pre, e) => pre + e.honestyPoints);
  }

  int get activityId => application.activityId;

  bool get cancelled => application.activityId == -1;

  int get applicationId => application.applicationId;

  Class2ndActivityCat get category => application.category;

  Class2ndPointType? get scoreType => application.category.pointType;

  /// Because the [application.name] might have trailing ellipsis
  String get title => scores.firstOrNull?.name ?? application.title;

  const Class2ndAttendedActivity({
    required this.application,
    required this.scores,
  });

  @override
  String toString() {
    return {
      "application": application,
      "scores": scores,
    }.toString();
  }
}
