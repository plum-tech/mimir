import 'package:flutter/foundation.dart';
import 'package:mimir/credential/init.dart';
import 'package:mimir/global/desktop_init.dart';
import 'package:mimir/global/global.dart';
import 'package:mimir/hive/init.dart';
import 'package:mimir/main/init.dart';
import 'package:mimir/main/network_tool/init.dart';
import 'package:mimir/migration/migrations.dart';
import 'package:mimir/mini_apps/symbol.dart';
import 'package:mimir/session/sis.dart';
import 'package:mimir/storage/init.dart';
import 'package:mimir/version.dart';
import 'package:path/path.dart' as path;
import 'package:universal_platform/universal_platform.dart';

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
    Kv.init(kvStorageBox: HiveBoxInit.kv);
    currentVersion = await getCurrentVersion();
    await Migrations.perform(from: Kv.version.lastVersion, to: currentVersion.full);
    Kv.version.lastVersion = currentVersion.full;
    Kv.version.lastStartupTime = DateTime.now();
    if (UniversalPlatform.isDesktop) {
      final lastWindowSize = Kv.theme.lastWindowSize;
      if (lastWindowSize != null) {
        DesktopInit.resizeTo(lastWindowSize);
      }
    }

    CredentialInit.init(
      box: HiveBoxInit.credentials,
    );

    await Global.init(
      debugNetwork: debugNetwork ?? Kv.network.isGlobalProxy,
      cookieBox: HiveBoxInit.cookiesBox,
      credentials: CredentialInit.credential,
    );

    // 初始化用户首次打开时间（而不是应用安装时间）
    // ??= 表示为空时候才赋值
    Kv.home.installTime ??= DateTime.now();

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
      session: Global.ssoSession2,
      expenseBox: HiveBoxInit.expense,
    );

    HomeInit.init(
      ssoSession: Global.ssoSession,
    );

    await LibraryInit.init(
      dio: Global.dio,
      searchHistoryBox: HiveBoxInit.librarySearchHistory,
    );

    await EduEmailInit.init();

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

    ElectricityBillInit.init(
      electricityBox: HiveBoxInit.kv,
    );
  }
}
