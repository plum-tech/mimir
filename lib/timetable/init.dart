import 'package:sit/settings/settings.dart';
import 'package:sit/timetable/service/school.demo.dart';

import 'service/school.dart';
import 'storage/timetable.dart';

class TimetableInit {
  static late TimetableService service;
  static late TimetableStorage storage;

  static void init() {
    service = Settings.demoMode ? const DemoTimetableService() : const TimetableService();
    storage = TimetableStorage();
  }
}
