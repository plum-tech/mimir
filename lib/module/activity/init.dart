import './using.dart';
import 'cache/detail.dart';
import 'cache/list.dart';
import 'cache/score.dart';
import 'dao/detail.dart';
import 'dao/list.dart';
import 'dao/score.dart';
import 'service/detail.dart';
import 'service/join.dart';
import 'service/list.dart';
import 'service/score.dart';
import 'storage/detail.dart';
import 'storage/list.dart';
import 'storage/score.dart';

class ScInit {
  static late ScSession session;
  static late ScActivityListDao scActivityListService;
  static late ScActivityDetailDao scActivityDetailService;
  static late ScScoreDao scScoreService;
  static late ScJoinActivityService scJoinActivityService;

  static void init({
    required SsoSession ssoSession,
    required Box<dynamic> box,
  }) {
    session = ScSession(ssoSession);
    scActivityListService = ScActivityListCache(
      from: ScActivityListService(session),
      to: ScActivityListStorage(box),
      expiration: const Duration(minutes: 30),
    );
    scActivityDetailService = ScActivityDetailCache(
      from: ScActivityDetailService(session),
      to: ScActivityDetailStorage(box),
      expiration: const Duration(days: 180),
    );
    scScoreService = ScScoreCache(
      from: ScScoreService(session),
      to: ScScoreStorage(box),
      expiration: const Duration(minutes: 5),
    );
    scJoinActivityService = ScJoinActivityService(session);
  }
}
