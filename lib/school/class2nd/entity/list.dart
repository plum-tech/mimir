import '../utils.dart';
import 'package:mimir/hive/type_id.dart';
import 'score.dart';

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

  /// 校园文化
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
    } else if (catName == "安全教育网络教学") {
      return Class2ndActivityCat.onlineSafetyEdu;
    } else if (catName == "校园文明") {
      return Class2ndActivityCat.schoolCultureActivity;
    } else if (catName.contains("会议")) {
      return Class2ndActivityCat.conference;
    }
    return null;
  }
}

enum ActivityScoreType {
  /// 讲座报告
  thematicReport,

  /// 创新创业创意
  creation,

  /// 校园文化
  schoolCulture,

  /// 社会实践
  practice,

  /// 志愿公益
  voluntary,

  /// 校园安全文明
  schoolSafetyCivilization;

  const ActivityScoreType();

  static ActivityScoreType? parse(String typeName) {
    if (typeName == "主题报告") {
      return ActivityScoreType.thematicReport;
    } else if (typeName == "社会实践") {
      return ActivityScoreType.practice;
    } else if (typeName == "创新创业创意") {
      return ActivityScoreType.creation;
    } else if (typeName == "校园文化") {
      return ActivityScoreType.schoolCulture;
    } else if (typeName == "公益志愿") {
      return ActivityScoreType.voluntary;
    } else if (typeName == "校园安全文明") {
      return ActivityScoreType.schoolSafetyCivilization;
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
    final titleAndTags = splitTitleAndTags(activity.title);
    return Class2ndActivity(
      id: activity.activityId,
      title: activity.title,
      ts: activity.time,
      realTitle: titleAndTags.title,
      tags: titleAndTags.tags,
    );
  }
}
