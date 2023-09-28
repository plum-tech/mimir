import 'package:easy_localization/easy_localization.dart';

import '../utils.dart';
import 'package:mimir/hive/type_id.dart';
import 'attended.dart';

part 'list.g.dart';

@HiveType(typeId: HiveTypeClass2nd.activityCat)
enum Class2ndActivityCat {
  /// 讲座报告
  @HiveField(0)
  lecture,

  /// 主题教育
  @HiveField(1)
  thematicEdu,

  /// 创新创业创意
  @HiveField(2)
  creation,

  /// 校园文化活动
  @HiveField(3)
  schoolCultureActivity,

  /// 社会实践
  @HiveField(4)
  practice,

  /// 志愿公益
  @HiveField(5)
  voluntary,

  /// 安全教育网络教学
  @HiveField(6)
  onlineSafetyEdu,

  /// 会议（无学分）
  @HiveField(7)
  conference,

  /// 校园文化竞赛活动
  @HiveField(8)
  schoolCultureCompetition,

  /// 论文专利
  @HiveField(9)
  paperAndPatent;

  const Class2ndActivityCat();

  String l10nName() => "class2nd.activityCat.$name".tr();

  /// Don't Change this.
  /// Strings from school API
  static Class2ndActivityCat? parse(String catName) {
    if (catName == "讲座报告") {
      return Class2ndActivityCat.lecture;
    } else if (catName == "主题教育") {
      return Class2ndActivityCat.lecture;
    } else if (catName == "校园文化活动") {
      return Class2ndActivityCat.schoolCultureActivity;
    } else if (catName == "校园文化竞赛活动") {
      return Class2ndActivityCat.schoolCultureCompetition;
    } else if (catName == "创新创业创意") {
      return Class2ndActivityCat.creation;
    } else if (catName == "论文专利") {
      return Class2ndActivityCat.paperAndPatent;
    } else if (catName == "社会实践") {
      return Class2ndActivityCat.practice;
    } else if (catName == "志愿公益") {
      return Class2ndActivityCat.voluntary;
    } else if (catName.contains("安全教育网络教学")) {
      // To prevent ellipsis
      return Class2ndActivityCat.onlineSafetyEdu;
    } else if (catName == "校园文明") {
      return Class2ndActivityCat.schoolCultureActivity;
    } else if (catName.contains("会议")) {
      return Class2ndActivityCat.conference;
    }
    return null;
  }
}

@HiveType(typeId: HiveTypeClass2nd.activity)
class Class2ndActivity {
  /// Activity id
  @HiveField(0)
  final int id;

  /// Title
  @HiveField(1)
  final String title;

  @HiveField(2)
  final String realTitle;

  @HiveField(3)
  final List<String> tags;

  /// Date
  @HiveField(4)
  final DateTime ts;

  const Class2ndActivity({
    required this.id,
    required this.title,
    required this.ts,
    required this.realTitle,
    required this.tags,
  });

  @override
  String toString() {
    return {
      "id": id,
      "title": title,
      "ts": ts,
      "realTitle": realTitle,
      "tags": tags,
    }.toString();
  }
}

extension ActivityParser on Class2ndActivity {
  static Class2ndActivity parse(Class2ndAttendedActivity activity) {
    final (:title, :tags) = splitTitleAndTags(activity.title);
    return Class2ndActivity(
      id: activity.activityId,
      title: activity.title,
      ts: activity.time,
      realTitle: title,
      tags: tags,
    );
  }
}
