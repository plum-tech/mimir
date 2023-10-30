import 'package:flutter/material.dart';
import 'package:sit/design/adaptive/editor.dart';
import 'package:sit/entity/campus.dart';

import 'package:flutter/foundation.dart';
import 'package:sit/credentials/init.dart';
import 'package:sit/platform/desktop.dart';
import 'package:sit/hive/init.dart';
import 'package:sit/session/class2nd.dart';
import 'package:sit/session/library.dart';
import 'package:sit/session/ywb.dart';
import 'package:sit/settings/meta.dart';
import 'package:sit/life/electricity/init.dart';
import 'package:sit/life/expense_records/init.dart';
import 'package:sit/login/init.dart';
import 'package:sit/me/edu_email/init.dart';
import 'package:sit/me/network_tool/init.dart';
import 'package:sit/migration/migrations.dart';
import 'package:sit/school/ywb/init.dart';
import 'package:sit/school/exam_arrange/init.dart';
import 'package:sit/school/library/init.dart';
import 'package:sit/school/oa_announce/init.dart';
import 'package:sit/school/class2nd/init.dart';
import 'package:sit/school/exam_result/init.dart';
import 'package:sit/school/yellow_pages/init.dart';
import 'package:sit/session/jwxt.dart';
import 'package:sit/settings/settings.dart';
import 'package:sit/timetable/init.dart';
import 'package:sit/version.dart';
import 'package:path/path.dart' as path;
import 'package:universal_platform/universal_platform.dart';
import 'dart:async';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:event_bus/event_bus.dart';
import 'package:sit/hive/cookie.dart';
import 'package:sit/network/dio.dart';
import 'package:sit/route.dart';
import 'package:sit/session/sso.dart';

import '../widgets/captcha_box.dart';

class Init {
  const Init._();

  static late AppVersion currentVersion;

  static final eventBus = EventBus();

  static late CookieJar cookieJar;
  static late Dio dio;
  static late SsoSession ssoSession;
  static late JwxtSession sisSession;
  static late YwbSession ywbSession;
  static late LibrarySession librarySession;
  static late Class2ndSession class2ndSession;

  static Future<void> init() async {
    // 运行前初始化
    try {
      await _init();
    } on Exception catch (error, stackTrace) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  static Future<void> initNetwork() async {
    debugPrint("Initializing network");
    cookieJar = PersistCookieJar(
      storage: HiveCookieJar(HiveInit.cookies),
    );
    dio = await DioInit.init(
      config: DioConfig()
        ..cookieJar = cookieJar
        ..sendTimeout = const Duration(seconds: 6)
        ..receiveTimeout = const Duration(seconds: 6)
        ..connectTimeout = const Duration(seconds: 6),
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
        return await showAdaptiveDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => CaptchaDialog(captchaData: imageBytes),
        );
      },
    );
    sisSession = JwxtSession(
      ssoSession,
    );
    ywbSession = YwbSession(
      dio: dio,
    );
    librarySession = LibrarySession(
      dio,
    );
    class2ndSession = Class2ndSession(
      ssoSession,
    );
  }

  static Future<void> _init() async {
    debugPrint("Initializing");
    await initStorage();
    // Initialize the window size before others for a better experience when loading.
    if (UniversalPlatform.isDesktop) {
      await DesktopInit.init();
    }
    _registerEditor();
    if (UniversalPlatform.isDesktop) {
      final lastWindowSize = Settings.lastWindowSize;
      if (lastWindowSize != null) {
        DesktopInit.resizeTo(lastWindowSize);
      }
    }

    await initNetwork();
    await _initModules();
    // 初始化用户首次打开时间（而不是应用安装时间）
    // ??= 表示为空时候才赋值
    Meta.installTime ??= DateTime.now();
  }

  static Future<void> initStorage() async {
    debugPrint("Initializing storage");
    await HiveInit.init(path.join("life.mysit.SITLife", "hive"));
    Settings = SettingsImpl(HiveInit.settings);
    Settings.isDeveloperMode = kDebugMode;
    Meta = MetaImpl(HiveInit.meta);
    currentVersion = await getCurrentVersion();
    await Migrations.perform(from: Meta.lastVersion, to: currentVersion.full);
    Meta.lastVersion = currentVersion.full;
    Meta.lastStartupTime = DateTime.now();
  }

  static Future<void> _initModules() async {
    debugPrint("Initializing modules");
    CredentialInit.init(
      box: HiveInit.credentials,
    );
    OaAnnounceInit.init(
      box: HiveInit.oaAnnounce,
    );

    ConnectivityInit.init();

    ExamResultInit.init(
      box: HiveInit.examResult,
    );

    ExamArrangeInit.init(
      box: HiveInit.examArrange,
    );

    TimetableInit.init(
      box: HiveInit.timetable,
    );

    ExpenseRecordsInit.init(
      box: HiveInit.expense,
    );

    YellowPagesInit.init(
      box: HiveInit.yellowPages,
    );

    LibraryInit.init(
      searchHistoryBox: HiveInit.library,
    );

    EduEmailInit.init(
      box: HiveInit.eduEmail,
    );

    YwbInit.init(
      box: HiveInit.ywb,
    );

    Class2ndInit.init(
      box: HiveInit.class2nd,
    );

    LoginInit.init();

    ElectricityBalanceInit.init(
      electricityBox: HiveInit.settings,
    );
  }

  static void _registerEditor() {
    EditorEx.registerEnumEditor(Campus.values);
    EditorEx.registerEnumEditor(ThemeMode.values);
  }
}
