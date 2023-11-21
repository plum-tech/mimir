import 'service/result.dart';
import 'storage/result.dart';

class ExamResultInit {
  static late ExamResultService service;
  static late ExamResultStorage storage;

  static void init() {
    service = const ExamResultService();
    storage = const ExamResultStorage();
  }
}
