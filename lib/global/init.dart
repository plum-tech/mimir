import 'package:flutter/foundation.dart';
import 'package:mimir/credential/init.dart';
import 'package:mimir/global/desktop_init.dart';
import 'package:mimir/global/global.dart';
import 'package:mimir/hive/init.dart';
import 'package:mimir/life/electricity/init.dart';
import 'package:mimir/login/init.dart';
import 'package:mimir/main/init.dart';
import 'package:mimir/main/network_tool/init.dart';
import 'package:mimir/migration/migrations.dart';
import 'package:mimir/mini_apps/symbol.dart';
import 'package:mimir/session/sis.dart';
import 'package:mimir/storage/settings.dart';
import 'package:mimir/timetable/init.dart';
import 'package:mimir/version.dart';
import 'package:path/path.dart' as path;
import 'package:universal_platform/universal_platform.dart';

import '../storage/meta.dart';

class Init {
  static late AppVersion currentVersion;

  static Future<void> init({bool? debugNetwork}) async {
    // 运行前初始化
    try {
      await _init(debugNetwork: debugNetwork);
    } on Exception catch (error, stackTrace) {
      if (kDebugMode) {
        print(error);
        print(stackTrace);
      }
    }
  }

  static Future<void> _init({bool? debugNetwork}) async {
    // Initialize the window size before others for a better experience when loading.
    if (UniversalPlatform.isDesktop && !GlobalConfig.isTestEnv) {
      await DesktopInit.init();
    }

    // 初始化Hive数据库
    await HiveBoxInit.init(path.join("net.liplum.Mimir", "hive"));
    Settings = SettingsImpl(HiveBoxInit.settings);
    Meta = MetaImpl(HiveBoxInit.meta);
    currentVersion = await getCurrentVersion();
    await Migrations.perform(from: Meta.lastVersion, to: currentVersion.full);
    Meta.lastVersion = currentVersion.full;
    Meta.lastStartupTime = DateTime.now();
    if (UniversalPlatform.isDesktop) {
      final lastWindowSize = Settings.lastWindowSize;
      if (lastWindowSize != null) {
        DesktopInit.resizeTo(lastWindowSize);
      }
    }

    CredentialInit.init(
      box: HiveBoxInit.credentials,
    );

    await Global.init(
      debugNetwork: debugNetwork ?? Settings.isGlobalProxy,
      cookieBox: HiveBoxInit.cookies,
      credentials: CredentialInit.storage,
    );

    // 初始化用户首次打开时间（而不是应用安装时间）
    // ??= 表示为空时候才赋值
    Meta.installTime ??= DateTime.now();

    OaAnnounceInit.init(
      ssoSession: Global.ssoSession,
      box: HiveBoxInit.oaAnnounceCache,
    );

    ConnectivityInit.init(
      ssoSession: Global.ssoSession,
    );

    final sisSessionSession = SisSession(
      Global.ssoSession,
    );

    ExamResultInit.init(
      cookieJar: Global.cookieJar,
      sisSession: sisSessionSession,
      box: HiveBoxInit.examResultCache,
    );

    ExamArrInit.init(
      eduSession: sisSessionSession,
      box: HiveBoxInit.examArrCache,
    );

    TimetableInit.init(
      eduSession: sisSessionSession,
      box: HiveBoxInit.timetable,
      ssoSession: Global.ssoSession,
    );

    ExpenseTrackerInit.init(
      session: Global.ssoSession,
      expenseBox: HiveBoxInit.expense,
    );

    HomeInit.init(
      ssoSession: Global.ssoSession,
    );

    await LibraryInit.init(
      dio: Global.dio,
      searchHistoryBox: HiveBoxInit.librarySearchHistory,
    );

    await EduEmailInit.init(
      box: HiveBoxInit.eduEmail,
    );

    ApplicationInit.init(
      dio: Global.dio,
      cookieJar: Global.cookieJar,
      box: HiveBoxInit.applicationCache,
    );

    ScInit.init(
      ssoSession: Global.ssoSession,
      box: HiveBoxInit.activityCache,
    );

    LoginInit.init(
      ssoSession: Global.ssoSession,
    );

    ElectricityBalanceInit.init(
      dio: Global.dio,
      electricityBox: HiveBoxInit.settings,
    );
  }
}
