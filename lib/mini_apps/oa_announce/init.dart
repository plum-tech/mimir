import 'package:hive/hive.dart';
import 'package:mimir/mini_apps/oa_announce/storage/announce.dart';

import 'cache/announce.dart';
import 'dao/announce.dart';
import 'service/announce.dart';
import 'using.dart';

class OaAnnounceInit {
  static late AnnounceDao service;
  static late SsoSession session;

  static void init({required SsoSession ssoSession, required Box<dynamic> box}) {
    session = ssoSession;
    service = AnnounceCache(
        from: AnnounceService(session),
        to: AnnounceStorage(box),
        detailExpire: const Duration(days: 180),
        catalogueExpire: const Duration(days: 1));
  }
}
