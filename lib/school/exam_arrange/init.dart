import 'package:hive/hive.dart';
import 'package:sit/school/exam_arrange/storage/exam.dart';
import 'package:sit/session/sis.dart';

import 'service/exam.dart';

class ExamArrangeInit {
  static late ExamArrangeService service;
  static late ExamArrangeStorage storage;

  static void init({
    required SisSession session,
    required Box box,
  }) {
    service = ExamArrangeService(session);
    storage = ExamArrangeStorage(box);
  }
}
