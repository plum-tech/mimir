import 'package:cookie_jar/cookie_jar.dart';
import 'package:hive/hive.dart';
import 'package:mimir/session/ywb.dart';

import 'service/meta.dart';
import 'service/application.dart';
import 'storage/meta.dart';
import 'storage/application.dart';

class YwbInit {
  static late CookieJar cookieJar;
  static late YwbApplicationMetaService metaService;
  static late YwbApplicationMetaStorage metaStorage;
  static late YwbApplicationService applicationService;
  static late YwbApplicationStorage applicationStorage;
  static late YwbSession session;

  static void init({
    required YwbSession session,
    required CookieJar cookieJar,
    required Box box,
  }) {
    YwbInit.cookieJar = cookieJar;
    YwbInit.session = session;
    metaService = YwbApplicationMetaService(session);
    metaStorage = YwbApplicationMetaStorage(box);
    applicationService = YwbApplicationService(session);
    applicationStorage = YwbApplicationStorage(box);
  }
}
