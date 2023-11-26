import 'package:flutter/material.dart';
import 'package:sit/design/adaptive/editor.dart';
import 'package:sit/entity/campus.dart';

import 'package:flutter/foundation.dart';
import 'package:sit/credentials/init.dart';
import 'package:sit/storage/hive/init.dart';
import 'package:sit/session/class2nd.dart';
import 'package:sit/session/gms.dart';
import 'package:sit/session/library.dart';
import 'package:sit/session/ywb.dart';
import 'package:sit/life/electricity/init.dart';
import 'package:sit/life/expense_records/init.dart';
import 'package:sit/login/init.dart';
import 'package:sit/me/edu_email/init.dart';
import 'package:sit/me/network_tool/init.dart';
import 'package:sit/school/ywb/init.dart';
import 'package:sit/school/exam_arrange/init.dart';
import 'package:sit/school/library/init.dart';
import 'package:sit/school/oa_announce/init.dart';
import 'package:sit/school/class2nd/init.dart';
import 'package:sit/school/exam_result/init.dart';
import 'package:sit/school/yellow_pages/init.dart';
import 'package:sit/session/jwxt.dart';
import 'package:sit/timetable/init.dart';
import 'dart:async';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:event_bus/event_bus.dart';
import 'package:sit/storage/hive/cookie.dart';
import 'package:sit/network/dio.dart';
import 'package:sit/route.dart';
import 'package:sit/session/sso.dart';

import '../widgets/captcha_box.dart';

class Init {
  const Init._();

  static final eventBus = EventBus();

  static late CookieJar cookieJar;
  static late Dio dio;
  static late SsoSession ssoSession;
  static late JwxtSession jwxtSession;
  static late GmsSession gmsSession;
  static late YwbSession ywbSession;
  static late LibrarySession librarySession;
  static late Class2ndSession class2ndSession;

  static Future<void> initNetwork() async {
    debugPrint("Initializing network");
    cookieJar = PersistCookieJar(
      storage: HiveCookieJar(HiveInit.cookies),
    );
    dio = await DioInit.init(config: DioConfig()..cookieJar = cookieJar);
    ssoSession = SsoSession(
      dio: dio,
      cookieJar: cookieJar,
      onError: (error, stackTrace) {
        debugPrint(error.toString());
        debugPrintStack(stackTrace: stackTrace);
      },
      inputCaptcha: (Uint8List imageBytes) async {
        final context = $Key.currentContext!;
        return await showAdaptiveDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => CaptchaDialog(captchaData: imageBytes),
        );
      },
    );
    jwxtSession = JwxtSession(
      ssoSession: ssoSession,
    );
    ywbSession = YwbSession(
      dio: dio,
    );
    librarySession = LibrarySession(
      dio: dio,
    );
    class2ndSession = Class2ndSession(
      ssoSession: ssoSession,
    );
    gmsSession = GmsSession(
      ssoSession: ssoSession,
    );
  }

  static Future<void> initModules() async {
    debugPrint("Initializing module storage");
    CredentialInit.init();
    OaAnnounceInit.init();
    ConnectivityInit.init();
    ExamResultInit.init();
    ExamArrangeInit.init();
    TimetableInit.init();
    ExpenseRecordsInit.init();
    YellowPagesInit.init();
    LibraryInit.init();
    EduEmailInit.init();
    YwbInit.init();
    Class2ndInit.init();
    LoginInit.init();
    ElectricityBalanceInit.init();
  }

  static void registerCustomEditor() {
    EditorEx.registerEnumEditor(Campus.values);
    EditorEx.registerEnumEditor(ThemeMode.values);
  }
}
