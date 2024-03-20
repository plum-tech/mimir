import 'dart:core';

import 'package:easy_localization/easy_localization.dart';

import 'activity.dart';
import 'package:sit/storage/hive/type_id.dart';

part 'application.g.dart';

@HiveType(typeId: CacheHiveType.class2ndActivityApplicationStatus)
enum Class2ndActivityApplicationStatus {
  @HiveField(0)
  unknown,
  @HiveField(1)
  approved,
  @HiveField(2)
  rejected,
  @HiveField(3)
  withdrawn,
  @HiveField(4)
  activityCancelled,
  @HiveField(5)
  reviewing,
  ;

  static Class2ndActivityApplicationStatus? parse(String status) {
    if (status == "通过") {
      return Class2ndActivityApplicationStatus.approved;
    } else if (status == "未通过") {
      return Class2ndActivityApplicationStatus.rejected;
    } else if (status == "活动取消") {
      return Class2ndActivityApplicationStatus.activityCancelled;
    } else if (status == "已撤销") {
      return Class2ndActivityApplicationStatus.withdrawn;
    } else if (status == "审核中") {
      return Class2ndActivityApplicationStatus.reviewing;
    }
    return null;
  }

  String l10n() {
    return "class2nd.applicationStatus.$name".tr();
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
  final Class2ndActivityApplicationStatus status;

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
