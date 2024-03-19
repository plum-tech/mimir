import 'dart:core';

import 'activity.dart';
import 'package:sit/storage/hive/type_id.dart';

part 'application.g.dart';

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
