import 'package:catcher/catcher.dart';
import 'package:mimir/credential/init.dart';
import 'package:mimir/global/desktop_init.dart';
import 'package:mimir/global/global.dart';
import 'package:mimir/hive/init.dart';
import 'package:mimir/home/init.dart';
import 'package:mimir/migration/migrations.dart';
import 'package:mimir/module/symbol.dart';
import 'package:mimir/session/edu_session.dart';
import 'package:mimir/session/kite_session.dart';
import 'package:mimir/settings/symbol.dart';
import 'package:mimir/storage/init.dart';
import 'package:mimir/util/logger.dart';
import 'package:mimir/version.dart';
import 'package:path/path.dart' as path;
import 'package:universal_platform/universal_platform.dart';

class Initializer {
  static late AppVersion currentVersion;

  static Future<void> init({bool? debugNetwork}) async {
    // 运行前初始化
    try {
      await _init(debugNetwork: debugNetwork);
    } on Exception catch (error, stackTrace) {
      try {
        Catcher.reportCheckedError(error, stackTrace);
      } catch (e) {
        Log.error([error, stackTrace]);
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
    SettingsInit.init(
      kvStorageBox: HiveBoxInit.kv,
    );
    CredentialInit.init(
      box: HiveBoxInit.credentials,
    );
    await Global.init(
      authSetting: Kv.auth,
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

    final kiteSession = KiteSession(
      Global.dio,
      Kv.jwt,
    );

    final sharedEduSession = EduSession(
      Global.ssoSession,
    );
    await ExamResultInit.init(
      cookieJar: Global.cookieJar,
      eduSession: sharedEduSession,
      box: HiveBoxInit.examResultCache,
    );
    await ExamArrInit.init(
      eduSession: sharedEduSession,
      box: HiveBoxInit.examArrCache,
    );
    await TimetableInit.init(
      eduSession: sharedEduSession,
      box: HiveBoxInit.timetable,
      ssoSession: Global.ssoSession,
    );

    await ExpenseTrackerInit.init(
      session: Global.ssoSession2,
      expenseBox: HiveBoxInit.expense,
    );

    await HomeInit.init(
      ssoSession: Global.ssoSession,
    );
    await LibraryInit.init(
      dio: Global.dio,
      searchHistoryBox: HiveBoxInit.librarySearchHistory,
    );
    await EduEmailInit.init();
    await ApplicationInit.init(
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

    await YellowPagesInit.init(
      kiteSession: kiteSession,
      contactDataBox: HiveBoxInit.contactSetting,
    );
  }
}
