import 'package:flutter/material.dart';
import 'package:mimir/backend/init.dart';
import 'package:mimir/backend/network/ua.dart';
import 'package:mimir/credentials/entity/credential.dart';
import 'package:mimir/credentials/entity/login_status.dart';
import 'package:mimir/credentials/entity/user_type.dart';
import 'package:mimir/design/adaptive/editor.dart';
import 'package:mimir/entity/campus.dart';

import 'package:flutter/foundation.dart';
import 'package:mimir/credentials/init.dart';
import 'package:mimir/lifecycle.dart';
import 'package:mimir/settings/entity/proxy.dart';
import 'package:mimir/storage/hive/init.dart';
import 'package:mimir/session/class2nd.dart';
import 'package:mimir/session/pg_registration.dart';
import 'package:mimir/session/library.dart';
import 'package:mimir/session/ywb.dart';
import 'package:mimir/life/electricity/init.dart';
import 'package:mimir/life/expense_records/init.dart';
import 'package:mimir/login/init.dart';
import 'package:mimir/me/edu_email/init.dart';
import 'package:mimir/school/ywb/init.dart';
import 'package:mimir/school/exam_arrange/init.dart';
import 'package:mimir/school/library/init.dart';
import 'package:mimir/school/oa_announce/init.dart';
import 'package:mimir/school/class2nd/init.dart';
import 'package:mimir/school/exam_result/init.dart';
import 'package:mimir/school/yellow_pages/init.dart';
import 'package:mimir/session/ug_registration.dart';
import 'package:mimir/timetable/init.dart';
import 'dart:async';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:mimir/storage/hive/cookie.dart';
import 'package:mimir/network/dio.dart';
import 'package:mimir/session/sso.dart';

import '../widgets/captcha_box.dart';

class Init {
  const Init._();

  static late CookieJar schoolCookieJar;
  static late CookieJar cookieJar;
  static late Dio schoolDio;
  static late Dio mimirDio;
  static late Dio dioNoCookie;
  static late SsoSession ssoSession;
  static late UgRegistrationSession ugRegSession;
  static late PgRegistrationSession pgRegSession;
  static late YwbSession ywbSession;
  static late LibrarySession librarySession;
  static late Class2ndSession class2ndSession;

  static Future<void> initNetwork() async {
    debugPrint("Initializing network");
    if (kIsWeb) {
      schoolCookieJar = WebCookieJar();
      cookieJar = WebCookieJar();
    } else {
      schoolCookieJar = PersistCookieJar(
        storage: HiveCookieJar(HiveInit.schoolCookies),
      );
      cookieJar = PersistCookieJar(
        storage: HiveCookieJar(HiveInit.cookies),
      );
    }
    final uaForSchoolServer = await getUserAgentForSchoolServer();
    schoolDio = Dio(BaseOptions(
      connectTimeout: const Duration(milliseconds: 8000),
      receiveTimeout: const Duration(milliseconds: 8000),
      sendTimeout: const Duration(milliseconds: 8000),
      headers: {
        "User-Agent": uaForSchoolServer,
      },
    )).withCookieJar(schoolCookieJar).withDebugging();

    dioNoCookie = Dio(BaseOptions(
      connectTimeout: const Duration(milliseconds: 8000),
      receiveTimeout: const Duration(milliseconds: 8000),
      sendTimeout: const Duration(milliseconds: 8000),
      headers: {
        "User-Agent": uaForSchoolServer,
      },
    )).withDebugging();

    mimirDio = Dio(BaseOptions(
      headers: {
        "User-Agent": getMimirUa(),
      },
    )).withCookieJar(cookieJar).withDebugging();

    mimirDio.interceptors.add(MimirUALanguageDioInterceptor());

    ssoSession = SsoSession(
      dio: schoolDio,
      cookieJar: schoolCookieJar,
      inputCaptcha: _inputCaptcha,
    );
    ugRegSession = UgRegistrationSession(
      ssoSession: ssoSession,
    );
    ywbSession = YwbSession(
      dio: schoolDio,
    );
    librarySession = LibrarySession(
      dio: schoolDio,
    );
    class2ndSession = Class2ndSession(
      ssoSession: ssoSession,
    );
    pgRegSession = PgRegistrationSession(
      ssoSession: ssoSession,
    );
  }

  static Future<void> initModules() async {
    debugPrint("Initializing modules");
    CredentialsInit.init();
    TimetableInit.init();
    if (!kIsWeb) {
      BackendInit.init();
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
    debugPrint("Initializing module storage");
    CredentialsInit.initStorage();
    TimetableInit.initStorage();
    if (!kIsWeb) {
      BackendInit.initStorage();
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
    EditorEx.registerEnumEditor(ProxyMode.values);
    Editor.registerEditor<Credentials>((ctx, desc, initial) => StringsEditor(
          fields: [
            (name: "account", initial: initial.account),
            (name: "password", initial: initial.password),
          ],
          title: desc,
          ctor: (values) => Credentials(account: values[0], password: values[1]),
        ));
    EditorEx.registerEnumEditor(LoginStatus.values);
    EditorEx.registerEnumEditor(OaUserType.values);
  }
}

Future<String?> _inputCaptcha(Uint8List imageBytes) async {
  final context = $key.currentContext!;
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
}
