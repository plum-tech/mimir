import 'package:sit/school/oa_announce/service/announce.demo.dart';
import 'package:sit/settings/settings.dart';

import 'storage/announce.dart';

import 'service/announce.dart';

class OaAnnounceInit {
  static late OaAnnounceService service;
  static late OaAnnounceStorage storage;

  static void init() {
    service = Settings.demoMode ? const DemoOaAnnounceService() : const OaAnnounceService();
    storage = const OaAnnounceStorage();
  }
}
