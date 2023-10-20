import 'package:hive/hive.dart';

import 'service/school.dart';
import 'storage/timetable.dart';

class TimetableInit {
  static late TimetableService service;
  static late TimetableStorage storage;

  static void init({
    required Box box,
  }) {
    service = const TimetableService();
    storage = TimetableStorage(box);
  }
}
