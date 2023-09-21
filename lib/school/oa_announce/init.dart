import 'package:hive/hive.dart';
import 'storage/announce.dart';
import 'package:mimir/session/sso.dart';

import 'cache/announce.dart';
import 'dao/announce.dart';
import 'service/announce.dart';

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
