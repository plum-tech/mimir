import 'package:mimir/school/exam_arrange/storage/exam.dart';
import 'package:mimir/settings/dev.dart';

import 'service/exam.dart';
import 'service/exam.demo.dart';

class ExamArrangeInit {
  static late ExamArrangeService service;
  static late ExamArrangeStorage storage;

  static void init() {
    service = Dev.demoMode ? const DemoExamArrangeService() : const ExamArrangeService();
  }

  static void initStorage() {
    storage = ExamArrangeStorage();
  }
}
