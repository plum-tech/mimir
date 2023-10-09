import 'package:flutter/foundation.dart';
import 'package:sit/credential/init.dart';
import 'package:sit/global/desktop_init.dart';
import 'package:sit/global/global.dart';
import 'package:sit/hive/init.dart';
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
import 'package:sit/session/sis.dart';
import 'package:sit/settings/settings.dart';
import 'package:sit/timetable/init.dart';
import 'package:sit/version.dart';
import 'package:path/path.dart' as path;
import 'package:universal_platform/universal_platform.dart';

class Init {
  static late AppVersion currentVersion;

  // TODO: Separate network initialization from it
  static Future<void> init() async {
    // 运行前初始化
    try {
      await _init();
    } on Exception catch (error, stackTrace) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  static Future<void> _init() async {
    debugPrint("Initializing");
    // Initialize the window size before others for a better experience when loading.
    if (UniversalPlatform.isDesktop) {
      await DesktopInit.init();
    }

    // 初始化Hive数据库
    await HiveInit.init(path.join("net.liplum.Mimir", "hive"));
    Settings = SettingsImpl(HiveInit.settings);
    Settings.isDeveloperMode = kDebugMode;
    Meta = MetaImpl(HiveInit.meta);
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
      box: HiveInit.credentials,
    );

    await Global.init(
      cookieBox: HiveInit.cookies,
      credentials: CredentialInit.storage,
    );

    // 初始化用户首次打开时间（而不是应用安装时间）
    // ??= 表示为空时候才赋值
    Meta.installTime ??= DateTime.now();

    OaAnnounceInit.init(
      ssoSession: Global.ssoSession,
      box: HiveInit.oaAnnounce,
    );

    ConnectivityInit.init(
      ssoSession: Global.ssoSession,
    );

    final sisSession = SisSession(
      Global.ssoSession,
    );

    ExamResultInit.init(
      cookieJar: Global.cookieJar,
      sisSession: sisSession,
      box: HiveInit.examResult,
    );

    ExamArrangeInit.init(
      session: sisSession,
      box: HiveInit.examArrange,
    );

    TimetableInit.init(
      eduSession: sisSession,
      box: HiveInit.timetable,
      ssoSession: Global.ssoSession,
    );

    ExpenseRecordsInit.init(
      session: Global.ssoSession,
      box: HiveInit.expense,
    );

    YellowPagesInit.init(
      box: HiveInit.yellowPages,
    );

    LibraryInit.init(
      dio: Global.dio,
      searchHistoryBox: HiveInit.library,
    );

    EduEmailInit.init(
      box: HiveInit.eduEmail,
    );

    YwbInit.init(
      session: YwbSession(dio: Global.dio),
      cookieJar: Global.cookieJar,
      box: HiveInit.ywb,
    );

    Class2ndInit.init(
      ssoSession: Global.ssoSession,
      box: HiveInit.class2nd,
    );

    LoginInit.init(
      ssoSession: Global.ssoSession,
    );

    ElectricityBalanceInit.init(
      dio: Global.dio,
      electricityBox: HiveInit.settings,
    );
  }
}
