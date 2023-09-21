import 'package:hive/hive.dart';
import 'package:mimir/session/sc.dart';
import 'package:mimir/session/sso.dart';

import 'cache/detail.dart';
import 'cache/list.dart';
import 'service/activity.dart';
import 'service/activity_details.dart';
import 'service/attend.dart';
import 'service/score.dart';
import 'storage/detail.dart';
import 'storage/list.dart';
import 'storage/score.dart';

class Class2ndInit {
  static late Class2ndSession session;
  static late Class2ndActivityListCache activityListService;
  static late Class2ndActivityDetailCache activityDetailService;
  static late Class2ndScoreService scoreService;
  static late Class2ndScoreStorage scoreStorage;
  static late Class2ndAttendActivityService attendActivityService;

  static void init({
    required SsoSession ssoSession,
    required Box<dynamic> box,
  }) {
    session = Class2ndSession(ssoSession);
    activityListService = Class2ndActivityListCache(
      from: Class2ndActivityListService(session),
      to: Class2ndActivityListStorage(box),
      expiration: const Duration(minutes: 30),
    );
    activityDetailService = Class2ndActivityDetailCache(
      from: Class2ndActivityDetailsService(session),
      to: Class2ndActivityDetailStorage(box),
      expiration: const Duration(days: 180),
    );
    scoreStorage = Class2ndScoreStorage(box);
    scoreService = Class2ndScoreService(session);
    attendActivityService = Class2ndAttendActivityService(session);
  }
}
