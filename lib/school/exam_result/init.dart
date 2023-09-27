import 'package:cookie_jar/cookie_jar.dart';
import 'package:hive/hive.dart';
import 'package:mimir/session/sis.dart';

import 'service/result.dart';
import 'storage/result.dart';

class ExamResultInit {
  static late CookieJar cookieJar;
  static late ExamResultService service;
  static late ExamResultStorage storage;

  static void init({
    required CookieJar cookieJar,
    required SisSession sisSession,
    required Box<dynamic> box,
  }) {
    ExamResultInit.cookieJar = cookieJar;
    service = ExamResultService(sisSession);
    storage = ExamResultStorage(box);
  }
}
