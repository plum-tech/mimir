import 'package:mimir/school/class2nd/service/points.demo.dart';
import 'package:mimir/settings/dev.dart';

import 'service/activity.dart';
import 'service/activity.demo.dart';
import 'service/application.dart';
import 'service/application.demo.dart';
import 'service/points.dart';
import 'storage/activity.dart';
import 'storage/points.dart';

class Class2ndInit {
  static late Class2ndPointsService pointService;
  static late Class2ndPointsStorage pointStorage;
  static late Class2ndActivityService activityService;
  static late Class2ndActivityStorage activityStorage;
  static late Class2ndApplicationService applicationService;

  static void init() {
    pointService = Dev.demoMode ? const DemoClass2ndPointsService() : const Class2ndPointsService();
    activityService = Dev.demoMode ? const DemoClass2ndActivityService() : const Class2ndActivityService();
    applicationService = Dev.demoMode ? const DemoClass2ndApplicationService() : const Class2ndApplicationService();
  }

  static void initStorage() {
    pointStorage = Class2ndPointsStorage();
    activityStorage = const Class2ndActivityStorage();
  }
}
