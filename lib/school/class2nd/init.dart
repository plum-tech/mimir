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
    pointService = const Class2ndPointsService();
    activityService = const Class2ndActivityService();
    applicationService =  const Class2ndApplicationService();
  }

  static void initStorage() {
    pointStorage = Class2ndPointsStorage();
    activityStorage = const Class2ndActivityStorage();
  }
}
