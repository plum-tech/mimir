import 'package:mimir/module/exam_arr/storage/exam.dart';

import 'cache/exam.dart';
import 'dao/exam.dart';
import 'service/exam.dart';
import 'using.dart';

class ExamArrInit {
  static late ExamDao examService;

  static void init({
    required ISession eduSession,
    required Box<dynamic> box,
  }) {
    examService = ExamCache(
      from: ExamService(eduSession),
      to: ExamStorage(box),
      expiration: const Duration(days: 1),
    );
  }
}
