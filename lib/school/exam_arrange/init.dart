import 'package:hive/hive.dart';
import 'package:mimir/school/exam_arrange/storage/exam.dart';
import 'package:mimir/network/session.dart';

import 'service/exam.dart';

class ExamArrangeInit {
  static late ExamArrangeService service;
  static late ExamArrangeStorage storage;

  static void init({
    required ISession eduSession,
    required Box<dynamic> box,
  }) {
    service = ExamArrangeService(eduSession);
    storage = ExamArrangeStorage(box);
  }
}
