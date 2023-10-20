import 'package:hive/hive.dart';
import 'storage/announce.dart';

import 'service/announce.dart';

class OaAnnounceInit {
  static late OaAnnounceService service;
  static late OaAnnounceStorage storage;

  static void init({
    required Box box,
  }) {
    service = const OaAnnounceService();
    storage = OaAnnounceStorage(box);
  }
}
