import 'package:hive/hive.dart';

import 'service/result.dart';
import 'storage/result.dart';

class ExamResultInit {
  static late ExamResultService service;
  static late ExamResultStorage storage;

  static void init({
    required Box box,
  }) {
    service = const ExamResultService();
    storage = ExamResultStorage(box);
  }
}
