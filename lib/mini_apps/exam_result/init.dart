import 'package:cookie_jar/cookie_jar.dart';
import 'package:hive/hive.dart';

import 'cache/result.dart';
import 'dao/evaluation.dart';
import 'dao/result.dart';
import 'events.dart';
import 'service/evaluation.dart';
import 'service/result.dart';
import 'storage/result.dart';
import 'using.dart';

class ExamResultInit {
  static late CookieJar cookieJar;
  static late ExamResultDao resultService;
  static late CourseEvaluationDao courseEvaluationService;

  static void init({
    required CookieJar cookieJar,
    required SisSession sisSession,
    required Box<dynamic> box,
  }) {
    ExamResultInit.cookieJar = cookieJar;
    final examResultCache = ExamResultCache(
      from: ScoreService(sisSession),
      to: ExamResultStorage(box),
      detailExpire: const Duration(days: 180),
      listExpire: const Duration(hours: 6),
    );
    resultService = examResultCache;
    courseEvaluationService = CourseEvaluationService(sisSession);
    eventBus.on<LessonEvaluatedEvent>().listen((event) {
      examResultCache.clearResultListCache();
    });
  }
}
