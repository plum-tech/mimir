import 'package:mimir/settings/dev.dart';
import 'package:mimir/timetable/service/school.demo.dart';

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
