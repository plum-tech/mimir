import 'package:hive/hive.dart';
import 'package:sit/session/class2nd.dart';
import 'package:sit/session/sso.dart';

import 'cache/list.dart';
import 'service/activity.dart';
import 'service/activity_details.dart';
import 'service/attend.dart';
import 'service/score.dart';
import 'storage/details.dart';
import 'storage/list.dart';
import 'storage/score.dart';

class Class2ndInit {
  static late Class2ndSession session;
  static late Class2ndActivityListCache activityListService;
  static late Class2ndActivityDetailsService activityDetailsService;
  static late Class2ndActivityDetailsStorage activityDetailsStorage;
  static late Class2ndScoreService scoreService;
  static late Class2ndScoreStorage scoreStorage;
  static late Class2ndAttendActivityService attendActivityService;

  static void init({
    required SsoSession ssoSession,
    required Box box,
  }) {
    session = Class2ndSession(ssoSession);
    activityListService = Class2ndActivityListCache(
      from: Class2ndActivityListService(session),
      to: Class2ndActivityListStorage(box),
      expiration: const Duration(minutes: 30),
    );
    activityDetailsService = Class2ndActivityDetailsService(session);
    activityDetailsStorage = Class2ndActivityDetailsStorage(box);
    scoreStorage = Class2ndScoreStorage(box);
    scoreService = Class2ndScoreService(session);
    attendActivityService = Class2ndAttendActivityService(session);
  }
}
