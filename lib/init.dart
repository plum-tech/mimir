import 'package:flutter/material.dart';
import 'package:sit/design/adaptive/editor.dart';
import 'package:sit/entity/campus.dart';

import 'package:flutter/foundation.dart';
import 'package:sit/credentials/init.dart';
import 'package:sit/session/backend.dart';
import 'package:sit/storage/hive/init.dart';
import 'package:sit/session/class2nd.dart';
import 'package:sit/session/gms.dart';
import 'package:sit/session/library.dart';
import 'package:sit/session/ywb.dart';
import 'package:sit/life/electricity/init.dart';
import 'package:sit/life/expense_records/init.dart';
import 'package:sit/login/init.dart';
import 'package:sit/me/edu_email/init.dart';
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
import 'package:sit/storage/hive/cookie.dart';
import 'package:sit/network/dio.dart';
import 'package:sit/route.dart';
import 'package:sit/session/sso.dart';
import 'package:sit/update/init.dart';

import '../widgets/captcha_box.dart';

class Init {
  const Init._();

  static late CookieJar cookieJar;
  static late Dio dio;
  static late BackendSession backend;
  static late SsoSession ssoSession;
  static late JwxtSession jwxtSession;
  static late GmsSession gmsSession;
  static late YwbSession ywbSession;
  static late LibrarySession librarySession;
  static late Class2ndSession class2ndSession;

  static Future<void> initNetwork() async {
    debugPrint("Initializing network");
    if (kIsWeb) {
      cookieJar = WebCookieJar();
    } else {
      cookieJar = PersistCookieJar(
        storage: HiveCookieJar(HiveInit.cookies),
      );
    }
    dio = await DioInit.init(
      cookieJar: cookieJar,
      config: BaseOptions(
        connectTimeout: const Duration(milliseconds: 8000),
        receiveTimeout: const Duration(milliseconds: 8000),
        sendTimeout: const Duration(milliseconds: 8000),
      ),
    );
    backend = BackendSession(
      dio: dio,
    );
    ssoSession = SsoSession(
      dio: dio,
      cookieJar: cookieJar,
      onError: (error, stackTrace) {
        debugPrint(error.toString());
        debugPrintStack(stackTrace: stackTrace);
      },
      inputCaptcha: (Uint8List imageBytes) async {
        final context = $Key.currentContext!;
        // return await context.show$Sheet$(
        //   (ctx) => CaptchaSheetPage(
        //     captchaData: imageBytes,
        //   ),
        // );
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
    CredentialsInit.init();
    TimetableInit.init();
    if (!kIsWeb) {
      UpdateInit.init();
      OaAnnounceInit.init();
      ExamResultInit.init();
      ExamArrangeInit.init();
      ExpenseRecordsInit.init();
      LibraryInit.init();
      YwbInit.init();
      Class2ndInit.init();
      ElectricityBalanceInit.init();
    }
    YellowPagesInit.init();
    EduEmailInit.init();
    LoginInit.init();
  }

  static Future<void> initStorage() async {
    CredentialsInit.initStorage();
    TimetableInit.initStorage();
    if (!kIsWeb) {
      UpdateInit.initStorage();
      OaAnnounceInit.initStorage();
      ExamResultInit.initStorage();
      ExamArrangeInit.initStorage();
      ExpenseRecordsInit.initStorage();
      LibraryInit.initStorage();
      YwbInit.initStorage();
      Class2ndInit.initStorage();
      ElectricityBalanceInit.initStorage();
    }
    YellowPagesInit.initStorage();
    EduEmailInit.initStorage();
    LoginInit.initStorage();
  }

  static void registerCustomEditor() {
    EditorEx.registerEnumEditor(Campus.values);
    EditorEx.registerEnumEditor(ThemeMode.values);
  }
}
