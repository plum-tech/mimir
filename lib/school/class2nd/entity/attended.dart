import 'dart:core';

import 'package:easy_localization/easy_localization.dart';

import 'list.dart';
import 'package:sit/hive/type_id.dart';

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

  List<({Class2ndScoreType type, double score})> toName2score() {
    return [
      (type: Class2ndScoreType.voluntary, score: voluntary),
      (type: Class2ndScoreType.schoolCulture, score: schoolCulture),
      (type: Class2ndScoreType.creation, score: creation),
      (type: Class2ndScoreType.schoolSafetyCivilization, score: schoolSafetyCivilization),
      (type: Class2ndScoreType.thematicReport, score: thematicReport),
      (type: Class2ndScoreType.practice, score: practice),
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
  final DateTime? time;

  /// 得分
  @HiveField(4)
  final double points;

  /// 诚信分
  @HiveField(5)
  final double honestyPoints;

  Class2ndScoreType? get scoreType => category.scoreType;

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

@HiveType(typeId: HiveTypeClass2nd.scoreType)
enum Class2ndScoreType {
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

  const Class2ndScoreType();

  String l10nShortName() => "class2nd.scoreType.$name.short".tr();

  String l10nFullName() => "class2nd.scoreType.$name.full".tr();

  static String allCatL10n() => "class2nd.scoreType.all".tr();

  static Class2ndScoreType? parse(String typeName) {
    if (typeName == "主题报告") {
      return Class2ndScoreType.thematicReport;
    } else if (typeName == "社会实践") {
      return Class2ndScoreType.practice;
    } else if (typeName == "创新创业创意") {
      return Class2ndScoreType.creation;
    } else if (typeName == "校园文化") {
      return Class2ndScoreType.schoolCulture;
    } else if (typeName == "公益志愿") {
      return Class2ndScoreType.voluntary;
    } else if (typeName == "校园安全文明") {
      return Class2ndScoreType.schoolSafetyCivilization;
    }
    return null;
  }
}

class Class2ndAttendedActivity {
  final Class2ndActivityApplication application;
  final List<Class2ndScoreItem> scores;

  double? calcTotalPoints() {
    if (scores.isEmpty) return null;
    return scores.fold<double>(0.0, (pre, e) => pre + e.points);
  }

  double? calcTotalHonestyPoints() {
    if (scores.isEmpty) return null;
    return scores.fold<double>(0.0, (pre, e) => pre + e.honestyPoints);
  }

  Class2ndActivityCat get category => application.category;

  Class2ndScoreType? get scoreType => application.category.scoreType;

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
