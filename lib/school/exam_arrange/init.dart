import 'package:hive/hive.dart';
import 'package:mimir/school/exam_arrange/storage/exam.dart';
import 'package:mimir/session/sis.dart';

import 'service/exam.dart';

class ExamArrangeInit {
  static late ExamArrangeService service;
  static late ExamArrangeStorage storage;

  static void init({
    required SisSession session,
    required Box<dynamic> box,
  }) {
    service = ExamArrangeService(session);
    storage = ExamArrangeStorage(box);
  }
}
