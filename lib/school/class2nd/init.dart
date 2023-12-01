import 'service/activity.dart';
import 'service/attend.dart';
import 'service/score.dart';
import 'storage/activity.dart';
import 'storage/score.dart';

class Class2ndInit {
  static late Class2ndScoreService scoreService;
  static late Class2ndScoreStorage scoreStorage;
  static late Class2ndActivityService activityService;
  static late Class2ndActivityStorage activityStorage;
  static late Class2ndApplicationService applicationService;

  static void init() {
    scoreStorage = const Class2ndScoreStorage();
    scoreService = const Class2ndScoreService();
    activityService = const Class2ndActivityService();
    activityStorage = const Class2ndActivityStorage();
    applicationService = const Class2ndApplicationService();
  }
}
