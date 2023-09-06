import 'dart:core';

import '../entity/list.dart';
import 'package:mimir/hive/type_id.dart';

part 'score.g.dart';

@HiveType(typeId: HiveTypeId.scScoreSummary)
class ScScoreSummary {
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
  final double campus;

  const ScScoreSummary({
    this.lecture = 0,
    this.practice = 0,
    this.creation = 0,
    this.safetyEdu = 0,
    this.voluntary = 0,
    this.campus = 0,
  });

  @override
  String toString() {
    return 'ScScoreSummary{themeReport: $lecture, socialPractice: $practice, '
        'creativity: $creation, safetyCivilization: $safetyEdu, '
        'charity: $voluntary, campusCulture: $campus}';
  }
}

@HiveType(typeId: HiveTypeId.scScoreItem)
class ScScoreItem {
  /// 活动编号
  @HiveField(1)
  final int activityId;

  /// 活动类型
  @HiveField(2)
  final ActivityType type;

  /// 分数
  @HiveField(3)
  final double amount;

  ScScoreItem(this.activityId, this.type, this.amount);

  @override
  String toString() {
    return 'ScScoreItem{activityId: $activityId, category: $type, amount: $amount}';
  }
}

@HiveType(typeId: HiveTypeId.scActivityApplication)
class ScActivityApplication {
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

  ScActivityApplication(this.applyId, this.activityId, this.title, this.time, this.status);

  @override
  String toString() {
    return 'ScActivityApplication{activityId: $activityId, time: $time, status: $status}';
  }
}

class ScJoinedActivity {
  /// 申请编号
  final int applyId;

  /// 活动编号
  final int activityId;

  /// 活动标题
  final String title;

  /// 申请时间
  final DateTime time;

  /// 活动状态
  final String status;

  /// 总得分
  final double amount;

  ScJoinedActivity(this.applyId, this.activityId, this.title, this.time, this.status, this.amount);
}

extension ScJoinedActivityHelper on ScJoinedActivity {
  bool get isPassed => status == "通过";
}
