import 'package:hive/hive.dart';
import 'package:mimir/session/sc.dart';
import 'package:mimir/session/sso/session.dart';

import 'cache/detail.dart';
import 'cache/list.dart';
import 'cache/score.dart';
import 'service/detail.dart';
import 'service/attend.dart';
import 'service/list.dart';
import 'service/score.dart';
import 'storage/detail.dart';
import 'storage/list.dart';
import 'storage/score.dart';

class Class2ndInit {
  static late Class2ndSession session;
  static late Class2ndActivityListCache scActivityListService;
  static late Class2ndActivityDetailCache scActivityDetailService;
  static late Class2ndScoreCache scoreService;
  static late Class2ndAttendActivityService attendActivityService;

  static void init({
    required SsoSession ssoSession,
    required Box<dynamic> box,
  }) {
    session = Class2ndSession(ssoSession);
    scActivityListService = Class2ndActivityListCache(
      from: Class2ndActivityListService(session),
      to: Class2ndActivityListStorage(box),
      expiration: const Duration(minutes: 30),
    );
    scActivityDetailService = Class2ndActivityDetailCache(
      from: Class2ndActivityDetailService(session),
      to: Class2ndActivityDetailStorage(box),
      expiration: const Duration(days: 180),
    );
    scoreService = Class2ndScoreCache(
      from: Class2ndScoreService(session),
      to: Class2ndScoreStorage(box),
      expiration: const Duration(minutes: 5),
    );
    attendActivityService = Class2ndAttendActivityService(session);
  }
}
