import 'package:cookie_jar/cookie_jar.dart';

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

  static Future<void> init({
    required CookieJar cookieJar,
    required ISession eduSession,
    required Box<dynamic> box,
  }) async {
    ExamResultInit.cookieJar = cookieJar;
    final examResultCache = ExamResultCache(
      from: ScoreService(eduSession),
      to: ExamResultStorage(box),
      detailExpire: const Duration(days: 180),
      listExpire: const Duration(hours: 6),
    );
    resultService = examResultCache;
    courseEvaluationService = CourseEvaluationService(eduSession);
    eventBus.on<LessonEvaluatedEvent>().listen((event) {
      examResultCache.clearResultListCache();
    });
  }
}
