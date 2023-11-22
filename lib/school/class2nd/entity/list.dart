import 'package:easy_localization/easy_localization.dart';

import 'package:sit/hive/type_id.dart';

import 'attended.dart';

part 'list.g.dart';

@HiveType(typeId: HiveTypeClass2nd.activityCat)
enum Class2ndActivityCat {
  /// 讲座报告
  @HiveField(0)
  lecture(
    "001",
    Class2ndScoreType.thematicReport,
  ),

  /// 主题教育
  @HiveField(1)
  thematicEdu("ff808081674ec4720167ce60dda77cea"),

  /// 创新创业创意
  @HiveField(2)
  creation(
    "ff8080814e241104014eb867e1481dc3",
    Class2ndScoreType.creation,
  ),

  /// 校园文化活动
  @HiveField(3)
  schoolCultureActivity(
    "8ab17f543fe626a8013fe6278a880001",
    Class2ndScoreType.schoolCulture,
  ),

  /// 校园文明
  @HiveField(4)
  schoolCivilization(
    "8F963F2A04013A66E0540021287E4866",
    Class2ndScoreType.schoolSafetyCivilization,
  ),

  /// 社会实践
  @HiveField(5)
  practice(
    "8ab17f543fe62d5d013fe62efd3a0002",
    Class2ndScoreType.practice,
  ),

  /// 志愿公益
  @HiveField(6)
  voluntary(
    "8ab17f543fe62d5d013fe62e6dc70001",
    Class2ndScoreType.voluntary,
  ),

  /// 安全教育网络教学
  @HiveField(7)
  onlineSafetyEdu(
    "402881de5d62ba57015d6320f1a7000c",
    Class2ndScoreType.schoolSafetyCivilization,
  ),

  /// 会议（无学分）
  @HiveField(8)
  conference("ff8080814e241104014fedbbf7fd329d"),

  /// 校园文化竞赛活动
  @HiveField(9)
  schoolCultureCompetition(
    "8ab17f2a3fe6585e013fe6596c300001",
    Class2ndScoreType.schoolCulture,
  ),

  /// 论文专利
  @HiveField(10)
  paperAndPatent(
    "8ab17f533ff05c27013ff06d10bf0001",
    Class2ndScoreType.creation,
  );

  final String id;
  final Class2ndScoreType? scoreType;

  const Class2ndActivityCat(this.id, [this.scoreType]);

  String l10nName() => "class2nd.activityCat.$name".tr();

  static String allCatL10n() => "class2nd.activityCat.all".tr();

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
      return Class2ndActivityCat.schoolCivilization;
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
