import 'dart:math';

import 'package:sit/school/class2nd/entity/details.dart';

import '../entity/activity.dart';
import 'activity.dart';

class DemoClass2ndActivityService implements Class2ndActivityService {
  const DemoClass2ndActivityService();

  @override
  Future<List<Class2ndActivity>> getActivityList(Class2ndActivityCat cat, int page) async {
    if (page > 3) return [];
    final rand = Random(cat.hashCode);
    final now = DateTime.now();
    Class2ndActivity gen(String title) {
      final time = now.copyWith(day: now.day + rand.nextInt(10) + 1);
      return Class2ndActivity(
        id: rand.nextInt(9999) + 1000,
        title: "$title ${time.month}/${time.day}",
        time: time,
      );
    }

    return switch (cat) {
      Class2ndActivityCat.lecture => [gen("小应生活开发者讲座")],
      Class2ndActivityCat.thematicEdu => [gen("生活主题教育")],
      Class2ndActivityCat.creation => [gen("三创展")],
      Class2ndActivityCat.schoolCultureActivity => [gen("小应生活社区活动")],
      Class2ndActivityCat.schoolCivilization => [gen("小应生活文明安全")],
      Class2ndActivityCat.practice => [gen("小应生活线下实践")],
      Class2ndActivityCat.voluntary => [gen("小应生活志愿活动")],
      Class2ndActivityCat.onlineSafetyEdu => [gen("生活线上安全教育")],
      Class2ndActivityCat.conference => [gen("小应生活开发者大会")],
      Class2ndActivityCat.schoolCultureCompetition => [gen("小应生活竞赛")],
      Class2ndActivityCat.paperAndPatent => [gen("小应生活论文报告")],
      Class2ndActivityCat.unknown => [gen("小应生活活动")],
    };
  }

  @override
  Future<List<Class2ndActivity>> query(String queryString) async {
    final rand = Random();
    final now = DateTime.now();
    return [
      Class2ndActivity(
        id: rand.nextInt(9999) + 1000,
        title: queryString,
        time: now.copyWith(day: now.day + rand.nextInt(10) + 1),
      ),
    ];
  }

  @override
  Future<Class2ndActivityDetails> getActivityDetails(int activityId) async {
    final now = DateTime.now();
    return Class2ndActivityDetails(
      id: activityId,
      title: "小应生活线下活动",
      startTime: now.copyWith(day: now.day + 10),
      signStartTime: now.copyWith(day: now.day + 10),
      signEndTime: now.copyWith(day: now.day + 10, hour: now.hour + 2),
    );
  }
}
