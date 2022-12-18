import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';

import 'cache/application.dart';
import 'cache/message.dart';
import 'dao/application.dart';
import 'dao/message.dart';
import 'service/application.dart';
import 'service/message.dart';
import 'storage/application.dart';
import 'storage/message.dart';
import 'using.dart';

class ApplicationInit {
  static late CookieJar cookieJar;
  static late ApplicationDao applicationService;
  static late ApplicationMessageDao messageService;
  static late OfficeSession session;

  static Future<void> init({
    required Dio dio,
    required CookieJar cookieJar,
    required Box<dynamic> box,
  }) async {
    ApplicationInit.cookieJar = cookieJar;
    session = OfficeSession(dio: dio);

    applicationService = ApplicationCache(
        from: ApplicationService(session),
        to: ApplicationStorage(box),
        detailExpire: const Duration(days: 180),
        listExpire: const Duration(days: 10));
    messageService = ApplicationMessageCache(
      from: ApplicationMessageService(session),
      to: ApplicationMessageStorage(box),
      expiration: const Duration(days: 1),
    );
  }
}
