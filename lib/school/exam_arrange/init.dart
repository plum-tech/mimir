import 'package:hive/hive.dart';
import 'package:sit/school/exam_arrange/storage/exam.dart';

import 'service/exam.dart';

class ExamArrangeInit {
  static late ExamArrangeService service;
  static late ExamArrangeStorage storage;

  static void init({
    required Box box,
  }) {
    service = const ExamArrangeService();
    storage = ExamArrangeStorage(box);
  }
}
