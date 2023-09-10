import 'package:hive/hive.dart';
import 'package:mimir/school/exam_arr/storage/exam.dart';
import 'package:mimir/network/session.dart';

import 'cache/exam.dart';
import 'dao/exam.dart';
import 'service/exam.dart';

class ExamArrangeInit {
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
