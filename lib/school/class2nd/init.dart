import 'package:hive/hive.dart';

import 'cache/list.dart';
import 'service/activity.dart';
import 'service/activity_details.dart';
import 'service/attend.dart';
import 'service/score.dart';
import 'storage/details.dart';
import 'storage/list.dart';
import 'storage/score.dart';

class Class2ndInit {
  static late Class2ndActivityListCache activityListService;
  static late Class2ndActivityDetailsService activityDetailsService;
  static late Class2ndActivityDetailsStorage activityDetailsStorage;
  static late Class2ndScoreService scoreService;
  static late Class2ndScoreStorage scoreStorage;
  static late Class2ndAttendActivityService attendActivityService;

  static void init({
    required Box box,
  }) {
    activityListService = Class2ndActivityListCache(
      from: const Class2ndActivityListService(),
      to: Class2ndActivityListStorage(box),
      expiration: const Duration(minutes: 30),
    );
    activityDetailsService = const Class2ndActivityDetailsService();
    activityDetailsStorage = Class2ndActivityDetailsStorage(box);
    scoreStorage = Class2ndScoreStorage(box);
    scoreService = const Class2ndScoreService();
    attendActivityService = const Class2ndAttendActivityService();
  }
}
