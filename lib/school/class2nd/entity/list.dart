import '../utils.dart';
import 'package:mimir/hive/type_id.dart';
import 'score.dart';

part 'list.g.dart';

/// No I18n for unambiguity among all languages
class ActivityName {
  static const lectureReport = "讲座报告";
  static const thematicReport = "主题报告";
  static const creation = "三创";
  static const practice = "社会实践";
  static const safetyCivilizationEdu = "校园安全文明";
  static const onlineSafetyEdu = "安全教育网络教学";
  static const schoolCulture = "校园文化";
  static const thematicEdu = "主题教育";
  static const unknown = "未知";
  static const voluntary = "志愿公益";
  static const blackList = ["补录"];
}

@HiveType(typeId: HiveTypeClass2nd.activityCat)
enum Class2ndActivityCat {
  @HiveField(0)
  lecture(ActivityName.lectureReport), // 讲座报告
  @HiveField(1)
  thematicEdu(ActivityName.thematicEdu), // 主题教育
  @HiveField(2)
  creation(ActivityName.creation), // 三创
  @HiveField(3)
  schoolCulture(ActivityName.schoolCulture), // 校园文化
  @HiveField(4)
  practice(ActivityName.practice), // 社会实践
  @HiveField(5)
  voluntary(ActivityName.voluntary), // 志愿公益
  @HiveField(6)
  onlineSafetyEdu(ActivityName.onlineSafetyEdu), // 安全教育网络教学
  @HiveField(7)
  unknown(ActivityName.unknown); // 未知

  final String name;

  const Class2ndActivityCat(this.name);

  /// Don't Change this.
  /// Strings from school API
  static Class2ndActivityCat? parse(String catName) {
    if (catName.contains("讲座报告")) {
      return Class2ndActivityCat.lecture;
    } else if (catName.contains("主题教育")) {
      return Class2ndActivityCat.lecture;
    } else if (catName.contains("校园文化")) {
      return Class2ndActivityCat.schoolCulture;
    } else if (catName.contains("创新创业创意")) {
      return Class2ndActivityCat.creation;
    } else if (catName.contains("社会实践")) {
      return Class2ndActivityCat.practice;
    } else if (catName.contains("志愿公益")) {
      return Class2ndActivityCat.voluntary;
    } else if (catName.contains("安全教育")) {
      return Class2ndActivityCat.onlineSafetyEdu;
    } else if (catName.contains("校园文明")) {
      return Class2ndActivityCat.schoolCulture;
    }
    return null;
  }
}

enum ActivityScoreType {
  thematicReport(ActivityName.thematicReport), // 讲座报告
  creation(ActivityName.creation), // 三创
  schoolCulture(ActivityName.schoolCulture), // 校园文化
  practice(ActivityName.practice), // 社会实践
  voluntary(ActivityName.voluntary), // 志愿公益
  safetyCiviEdu(ActivityName.safetyCivilizationEdu); // 校园安全文明

  final String name;

  const ActivityScoreType(this.name);
}

/// Don't Change this.
/// Strings from school API
const Map<String, ActivityScoreType> stringToActivityScoreType = {
  '主题报告': ActivityScoreType.thematicReport,
  '社会实践': ActivityScoreType.practice,
  '创新创业创意': ActivityScoreType.creation, // 三创
  '校园文化': ActivityScoreType.schoolCulture,
  '公益志愿': ActivityScoreType.voluntary,
  '校园安全文明': ActivityScoreType.safetyCiviEdu,
};

@HiveType(typeId: HiveTypeClass2nd.activity)
class Class2ndActivity {
  /// Activity id
  @HiveField(0)
  final int id;

  /// Activity category
  @HiveField(1)
  final Class2ndActivityCat category;

  /// Title
  @HiveField(2)
  final String title;

  @HiveField(3)
  final String realTitle;

  @HiveField(4)
  final List<String> tags;

  /// Date
  @HiveField(5)
  final DateTime ts;

  const Class2ndActivity({
    required this.id,
    required this.category,
    required this.title,
    required this.ts,
    required this.realTitle,
    required this.tags,
  });

  @override
  String toString() {
    return 'Activity{id: $id, category: $category, title: $title, ts: $ts}';
  }
}

extension ActivityParser on Class2ndActivity {
  static Class2ndActivity parse(Class2ndAttendedActivity activity) {
    final titleAndTags = splitTitleAndTags(activity.title);
    return Class2ndActivity(
      id: activity.activityId,
      category: Class2ndActivityCat.unknown,
      title: activity.title,
      ts: activity.time,
      realTitle: titleAndTags.title,
      tags: titleAndTags.tags,
    );
  }
}
