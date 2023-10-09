import 'package:hive/hive.dart';
import 'package:sit/network/session.dart';
import 'package:sit/session/sso.dart';

import 'service/school.dart';
import 'storage/timetable.dart';

class TimetableInit {
  static late TimetableService service;
  static late TimetableStorage storage;
  static late SsoSession network;

  static void init({
    required ISession eduSession,
    required Box box,
    required SsoSession ssoSession,
  }) {
    service = TimetableService(eduSession);
    storage = TimetableStorage(box);
    network = ssoSession;
  }
}
