import 'package:mimir/school/oa_announce/service/announce.demo.dart';
import 'package:mimir/settings/dev.dart';

import 'storage/announce.dart';

import 'service/announce.dart';

class OaAnnounceInit {
  static late OaAnnounceService service;
  static late OaAnnounceStorage storage;

  static void init() {
    service = Dev.demoMode ? const DemoOaAnnounceService() : const OaAnnounceService();
  }

  static void initStorage() {
    storage = const OaAnnounceStorage();
  }
}
