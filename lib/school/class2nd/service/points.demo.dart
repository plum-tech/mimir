import 'package:flutter/cupertino.dart';

import '../entity/activity.dart';
import '../entity/application.dart';
import '../entity/attended.dart';
import 'points.dart';

class DemoClass2ndPointsService implements Class2ndPointsService {
  const DemoClass2ndPointsService();

  @override
  Future<Class2ndPointsSummary> fetchScoreSummary() async {
    debugPrint("fetchScoreSummary");
    return const Class2ndPointsSummary(
      thematicReport: 1.5,
      practice: 2.0,
      creation: 1.5,
      schoolSafetyCivilization: 1.0,
      voluntary: 1.0,
      schoolCulture: 1.0,
      honestyPoints: 10.0,
      totalPoints: 8.0,
    );
  }

  @override
  Future<List<Class2ndPointItem>> fetchScoreItemList() async {
    debugPrint("fetchScoreItemList");
    return [
      Class2ndPointItem(
        name: "小应生活茶话会",
        activityId: 1919810,
        category: Class2ndActivityCat.creation,
        time: DateTime(2020, 12, 18),
        points: 2.0,
        honestyPoints: 0.2,
      ),
    ];
  }

  @override
  Future<List<Class2ndActivityApplication>> fetchActivityApplicationList() async {
    debugPrint("fetchActivityApplicationList");
    return [
      Class2ndActivityApplication(
        applicationId: 10001,
        activityId: 114514,
        title: "小应生活茶话会",
        time: DateTime(2020, 12, 18),
        status: Class2ndActivityApplicationStatus.reviewing,
        category: Class2ndActivityCat.creation,
      ),
      Class2ndActivityApplication(
        applicationId: 10002,
        activityId: 1919810,
        title: "小应生活开发者大会",
        time: DateTime(2020, 12, 18),
        status: Class2ndActivityApplicationStatus.approved,
        category: Class2ndActivityCat.creation,
      ),
    ];
  }
}
