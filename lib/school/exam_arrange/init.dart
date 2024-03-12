import 'package:sit/school/exam_arrange/storage/exam.dart';
import 'package:sit/settings/dev.dart';

import 'service/exam.dart';
import 'service/exam.demo.dart';

class ExamArrangeInit {
  static late ExamArrangeService service;
  static late ExamArrangeStorage storage;

  static void init() {
    service = Dev.demoMode ? const DemoExamArrangeService() : const ExamArrangeService();
    storage = const ExamArrangeStorage();
  }
}
