import 'package:hive/hive.dart';
import 'storage/announce.dart';
import 'package:mimir/session/sso.dart';

import 'service/announce.dart';

class OaAnnounceInit {
  static late OaAnnounceService service;
  static late OaAnnounceStorage storage;
  static late SsoSession session;

  static void init({
    required SsoSession ssoSession,
    required Box box,
  }) {
    session = ssoSession;
    service = OaAnnounceService(session);
    storage = OaAnnounceStorage(box);
  }
}
