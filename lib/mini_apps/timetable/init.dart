import 'service/school.dart';
import 'storage/timetable.dart';
import 'using.dart';

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
