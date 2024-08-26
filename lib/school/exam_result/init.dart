import 'package:mimir/school/exam_result/service/result.ug.demo.dart';
import 'package:mimir/settings/dev.dart';

import 'service/result.pg.dart';
import 'service/result.pg.demo.dart';
import 'service/result.ug.dart';
import 'storage/result.pg.dart';
import 'storage/result.ug.dart';

class ExamResultInit {
  static late ExamResultUgService ugService;
  static late ExamResultPgService pgService;
  static late ExamResultUgStorage ugStorage;
  static late ExamResultPgStorage pgStorage;

  static void init() {
    ugService = Dev.demoMode ? const DemoExamResultUgService() : const ExamResultUgService();
    pgService = Dev.demoMode ? const DemoExamResultPgService() : const ExamResultPgService();
  }

  static void initStorage() {
    ugStorage = ExamResultUgStorage();
    pgStorage = ExamResultPgStorage();
  }
}
