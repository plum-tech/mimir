import 'package:sit/settings/dev.dart';
import 'package:sit/timetable/service/school.demo.dart';

import 'service/school.dart';
import 'storage/timetable.dart';

class TimetableInit {
  static late TimetableService service;
  static late TimetableStorage storage;

  static void init() {
    service = Dev.demoMode ? const DemoTimetableService() : const TimetableService();
  }

  static void initStorage() {
    storage = TimetableStorage();
  }
}
