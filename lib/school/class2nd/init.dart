import 'package:sit/school/class2nd/service/points.demo.dart';
import 'package:sit/settings/settings.dart';

import 'service/activity.dart';
import 'service/application.dart';
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
    pointService = Settings.demoMode ? const DemoClass2ndPointsService() : const Class2ndPointsService();
    pointStorage = const Class2ndPointsStorage();
    activityService = const Class2ndActivityService();
    activityStorage = const Class2ndActivityStorage();
    applicationService = const Class2ndApplicationService();
  }
}
