import 'package:flutter/foundation.dart';
import 'package:mimir/credential/init.dart';
import 'package:mimir/global/desktop_init.dart';
import 'package:mimir/global/global.dart';
import 'package:mimir/hive/init.dart';
import 'package:mimir/settings/meta.dart';
import 'package:mimir/life/electricity/init.dart';
import 'package:mimir/life/expense_records/init.dart';
import 'package:mimir/login/init.dart';
import 'package:mimir/me/edu_email/init.dart';
import 'package:mimir/me/network_tool/init.dart';
import 'package:mimir/migration/migrations.dart';
import 'package:mimir/school/ywb/init.dart';
import 'package:mimir/school/exam_arrange/init.dart';
import 'package:mimir/school/library/init.dart';
import 'package:mimir/school/oa_announce/init.dart';
import 'package:mimir/school/class2nd/init.dart';
import 'package:mimir/school/exam_result/init.dart';
import 'package:mimir/school/yellow_pages/init.dart';
import 'package:mimir/session/sis.dart';
import 'package:mimir/settings/settings.dart';
import 'package:mimir/timetable/init.dart';
import 'package:mimir/version.dart';
import 'package:path/path.dart' as path;
import 'package:universal_platform/universal_platform.dart';

class Init {
  static late AppVersion currentVersion;

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
      dio: Global.dio,
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
