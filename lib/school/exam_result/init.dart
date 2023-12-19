import 'package:sit/school/exam_result/service/result.ug.demo.dart';
import 'package:sit/settings/settings.dart';

import 'service/result.pg.dart';
import 'service/result.ug.dart';
import 'storage/result.pg.dart';
import 'storage/result.ug.dart';

class ExamResultInit {
  static late ExamResultUgService ugService;
  static late ExamResultPgService pgService;
  static late ExamResultUgStorage ugStorage;
  static late ExamResultPgStorage pgStorage;

  static void init() {
    ugService = Settings.demoMode ? const DemoExamResultUgService() : const ExamResultUgService();
    pgService = const ExamResultPgService();
    ugStorage = const ExamResultUgStorage();
    pgStorage = const ExamResultPgStorage();
  }
}
