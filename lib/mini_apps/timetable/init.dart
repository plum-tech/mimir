import 'service/school.dart';
import 'storage/timetable.dart';
import 'using.dart';

class TimetableInit {
  static late TimetableService timetableService;
  static late TimetableStorage timetableStorage;
  static late SsoSession network;

  static void init({
    required ISession eduSession,
    required Box<dynamic> box,
    required SsoSession ssoSession,
  }) {
    timetableService = TimetableService(eduSession);
    timetableStorage = TimetableStorage(box);
    network = ssoSession;
  }
}
