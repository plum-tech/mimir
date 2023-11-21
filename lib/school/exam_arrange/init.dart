import 'package:sit/school/exam_arrange/storage/exam.dart';

import 'service/exam.dart';

class ExamArrangeInit {
  static late ExamArrangeService service;
  static late ExamArrangeStorage storage;

  static void init() {
    service = const ExamArrangeService();
    storage =const ExamArrangeStorage();
  }
}
