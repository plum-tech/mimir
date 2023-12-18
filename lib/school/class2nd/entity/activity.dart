import 'package:easy_localization/easy_localization.dart';

import 'package:sit/storage/hive/type_id.dart';

import 'attended.dart';

part 'activity.g.dart';

@HiveType(typeId: CacheHiveType.activityCat)
enum Class2ndActivityCat {
  /// 讲座报告
  @HiveField(0)
  lecture(
    "001",
    Class2ndPointType.thematicReport,
  ),

  /// 主题教育
  @HiveField(1)
  thematicEdu("ff808081674ec4720167ce60dda77cea"),

  /// 创新创业创意
  @HiveField(2)
  creation(
    "ff8080814e241104014eb867e1481dc3",
    Class2ndPointType.creation,
  ),

  /// 校园文化活动
  @HiveField(3)
  schoolCultureActivity(
    "8ab17f543fe626a8013fe6278a880001",
    Class2ndPointType.schoolCulture,
  ),

  /// 校园文明
  @HiveField(4)
  schoolCivilization(
    "8F963F2A04013A66E0540021287E4866",
    Class2ndPointType.schoolSafetyCivilization,
  ),

  /// 社会实践
  @HiveField(5)
  practice(
    "8ab17f543fe62d5d013fe62efd3a0002",
    Class2ndPointType.practice,
  ),

  /// 志愿公益
  @HiveField(6)
  voluntary(
    "8ab17f543fe62d5d013fe62e6dc70001",
    Class2ndPointType.voluntary,
  ),

  /// 安全教育网络教学
  @HiveField(7)
  onlineSafetyEdu(
    "402881de5d62ba57015d6320f1a7000c",
    Class2ndPointType.schoolSafetyCivilization,
  ),

  /// 会议（无学分）
  @HiveField(8)
  conference("ff8080814e241104014fedbbf7fd329d"),

  /// 校园文化竞赛活动
  @HiveField(9)
  schoolCultureCompetition(
    "8ab17f2a3fe6585e013fe6596c300001",
    Class2ndPointType.schoolCulture,
  ),

  /// 论文专利
  @HiveField(10)
  paperAndPatent(
    "8ab17f533ff05c27013ff06d10bf0001",
    Class2ndPointType.creation,
  );

  final String id;
  final Class2ndPointType? pointType;

  const Class2ndActivityCat(this.id, [this.pointType]);

  String l10nName() => "class2nd.activityCat.$name".tr();

  static String allCatL10n() => "class2nd.activityCat.all".tr();

  /// Don't Change this.
  /// Strings from school API
  static Class2ndActivityCat? parse(String name) {
    // To prevent ellipsis
    name = name.replaceAll(".", "");
    if (name == "讲座报告") {
      return Class2ndActivityCat.lecture;
    } else if (name == "主题教育") {
      return Class2ndActivityCat.lecture;
    } else if (name == "校园文化活动") {
      return Class2ndActivityCat.schoolCultureActivity;
    } else if (name == "校园文化竞赛活动") {
      return Class2ndActivityCat.schoolCultureCompetition;
    } else if (name == "创新创业创意") {
      return Class2ndActivityCat.creation;
    } else if (name == "论文专利") {
      return Class2ndActivityCat.paperAndPatent;
    } else if (name == "社会实践") {
      return Class2ndActivityCat.practice;
    } else if (name == "志愿公益") {
      return Class2ndActivityCat.voluntary;
    } else if (name == "安全教育网络教学") {
      return Class2ndActivityCat.onlineSafetyEdu;
    } else if (name == "校园文明") {
      return Class2ndActivityCat.schoolCivilization;
    } else if (name.contains("会议")) {
      return Class2ndActivityCat.conference;
    }
    return null;
  }
}

@HiveType(typeId: CacheHiveType.activity)
class Class2ndActivity {
  /// Activity id
  @HiveField(0)
  final int id;

  /// Title
  @HiveField(1)
  final String title;

  /// Date
  @HiveField(2)
  final DateTime time;

  const Class2ndActivity({
    required this.id,
    required this.title,
    required this.time,
  });

  @override
  String toString() {
    return {
      "id": id,
      "fullTitle": title,
      "time": time,
    }.toString();
  }
}
