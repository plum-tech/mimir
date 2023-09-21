import 'package:hive/hive.dart';
import 'package:mimir/network/session.dart';
import 'package:mimir/session/sso.dart';

import 'service/school.dart';
import 'storage/timetable.dart';

class TimetableInit {
  static late TimetableService service;
  static late TimetableStorage storage;
  static late SsoSession network;

  static void init({
    required ISession eduSession,
    required Box<dynamic> box,
    required SsoSession ssoSession,
  }) {
    service = TimetableService(eduSession);
    storage = TimetableStorage(box);
    network = ssoSession;
  }
}
