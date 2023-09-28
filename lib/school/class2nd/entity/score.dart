import 'dart:core';

import 'list.dart';
import 'package:mimir/hive/type_id.dart';

part 'score.g.dart';

@HiveType(typeId: HiveTypeClass2nd.scoreSummary)
class Class2ndScoreSummary {
  /// Subject report (主题报告)
  @HiveField(0)
  final double lecture;

  /// Social practice (社会实践)
  @HiveField(1)
  final double practice;

  /// Innovation, entrepreneurship and creativity.(创新创业创意)
  @HiveField(2)
  final double creation;

  /// Campus safety and civilization.(校园安全文明)
  @HiveField(3)
  final double safetyEdu;

  /// Charity and Volunteer.(公益志愿)
  @HiveField(4)
  final double voluntary;

  /// Campus culture.(校园文化)
  @HiveField(5)
  final double campusCulture;

  const Class2ndScoreSummary({
    this.lecture = 0,
    this.practice = 0,
    this.creation = 0,
    this.safetyEdu = 0,
    this.voluntary = 0,
    this.campusCulture = 0,
  });

  @override
  String toString() {
    return {
      "lecture": lecture,
      "practice": practice,
      "creation": creation,
      "safetyEdu": safetyEdu,
      "voluntary": voluntary,
      "campusCulture": campusCulture,
    }.toString();
  }

  List<({String name, double score})> toName2score() {
    return [
      (name: "志愿", score: voluntary),
      (name: "校园文化", score: campusCulture),
      (name: "三创", score: creation),
      (name: "安全文明", score: safetyEdu),
      (name: "讲座", score: lecture),
      (name: "社会实践", score: practice),
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
  final Class2ndActivityCat type;

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
    required this.type,
    required this.time,
    required this.points,
    required this.honestyPoints,
  });

  @override
  String toString() {
    return {
      "name": name,
      "activityId": activityId,
      "type": type,
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

  Class2ndActivityApplication({
    required this.applyId,
    required this.activityId,
    required this.title,
    required this.time,
    required this.status,
  });

  @override
  String toString() {
    return {
      "applyId": applyId,
      "activityId": activityId,
      "title": title,
      "time": time,
      "status": status,
    }.toString();
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

  /// 活动状态
  @HiveField(4)
  final String status;

  /// 总得分
  @HiveField(5)
  final double points;

  /// 总诚信分
  @HiveField(6)
  final double honestyPoints;

  const Class2ndAttendedActivity({
    required this.applyId,
    required this.activityId,
    required this.title,
    required this.time,
    required this.status,
    required this.points,
    required this.honestyPoints,
  });

  @override
  String toString() {
    return {
      "applyId": applyId,
      "activityId": activityId,
      "title": title,
      "time": time,
      "status": status,
      "points": points,
      "honestyPoints": honestyPoints,
    }.toString();
  }
}

extension ScJoinedActivityHelper on Class2ndAttendedActivity {
  bool get isPassed => status == "通过";
}
