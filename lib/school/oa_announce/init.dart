import 'package:hive/hive.dart';
import 'storage/announce.dart';
import 'package:mimir/session/sso.dart';

import 'service/announce.dart';

class OaAnnounceInit {
  static late AnnounceService service;
  static late AnnounceStorage storage;
  static late SsoSession session;

  static void init({
    required SsoSession ssoSession,
    required Box<dynamic> box,
  }) {
    session = ssoSession;
    service = AnnounceService(session);
    storage =AnnounceStorage(box);
  }
}
