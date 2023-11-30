import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sit/files.dart';
import 'package:sit/migration/foundation.dart';
import 'package:sit/network/proxy.dart';
import 'package:sit/storage/hive/init.dart';
import 'package:sit/init.dart';
import 'package:sit/migration/migrations.dart';
import 'package:sit/platform/desktop.dart';
import 'package:sit/school/yellow_pages/entity/contact.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sit/settings/meta.dart';
import 'package:sit/settings/settings.dart';
import 'package:sit/entity/version.dart';
import 'package:sit/storage/prefs.dart';
import 'package:system_theme/system_theme.dart';
import 'package:version/version.dart';

import 'app.dart';

import 'l10n/yaml_assets_loader.dart';
import 'r.dart';

void main() async {
  // debugRepaintRainbowEnabled = true;
  // debugRepaintTextRainbowEnabled = true;
  // debugPaintSizeEnabled = true;
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final lastSize = prefs.getLastWindowSize();
  await DesktopInit.init(size: lastSize);
  if (prefs.getInstallTime() == null) {
    await prefs.setInstallTime(DateTime.now());
  }
  // Initialize the window size before others for a better experience when loading.
  await SystemTheme.accentColor.load();
  await EasyLocalization.ensureInitialized();
  Migrations.init();

  if (!kIsWeb) {
    Files.cache = await getApplicationCacheDirectory();
    debugPrint("Cache ${Files.cache}");
    Files.temp = await getTemporaryDirectory();
    debugPrint("Temp ${Files.temp}");
    Files.internal = await getApplicationSupportDirectory();
    debugPrint("Internal ${Files.internal}");
    Files.user = await getApplicationDocumentsDirectory();
    debugPrint("User ${Files.user}");
  }
  await Files.init();
  // Perform migrations
  R.currentVersion = await getCurrentVersion();
  final currentVersion = R.currentVersion.full;
  final lastVersionRaw = prefs.getLastVersion();
  final lastVersion = lastVersionRaw != null ? Version.parse(lastVersionRaw) : currentVersion;
  final migrations = Migrations.match(from: lastVersion, to: currentVersion);

  await migrations.perform(MigrationPhrase.beforeHive);
  await prefs.setLastVersion(lastVersion.toString());

  R.roomList = await _loadRoomNumberList();
  R.userAgentList = await _loadUserAgents();
  R.yellowPages = await _loadYellowPages();

  // Initialize Hive
  await HiveInit.init(
    coreDir: Files.internal.subDir("hive", R.hiveStorageVersion),
    cacheDir: Files.cache.subDir("hive", R.hiveStorageVersion),
  );
  await HiveInit.initBox();

  // Setup Settings and Meta
  Settings.isDeveloperMode = kDebugMode;
  // The last time when user launch this app
  Meta.lastStartupTime = DateTime.now();
  await migrations.perform(MigrationPhrase.afterHive);
  Init.registerCustomEditor();
  HttpOverrides.global = SitHttpOverrides();
  await Init.initNetwork();
  await Init.initModules();
  runApp(
    const MimirApp().withEasyLocalization().withScreenUtils(),
  );
}

final _yamlAssetsLoader = YamlAssetLoader();

extension _AppX on Widget {
  Widget withEasyLocalization() {
    return EasyLocalization(
      supportedLocales: R.supportedLocales,
      path: 'assets/l10n',
      fallbackLocale: R.defaultLocale,
      useFallbackTranslations: true,
      assetLoader: _yamlAssetsLoader,
      child: this,
    );
  }

  Widget withScreenUtils() {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return this;
      },
    );
  }
}

Future<List<String>> _loadRoomNumberList() async {
  String jsonData = await rootBundle.loadString("assets/room_list.json");
  List<dynamic> list = await jsonDecode(jsonData);
  return list.map((e) => e.toString()).toList();
}

Future<List<String>> _loadUserAgents() async {
  String jsonData = await rootBundle.loadString("assets/user_agent.json");
  List<dynamic> list = await jsonDecode(jsonData);
  return list.cast<String>();
}

Future<List<SchoolContact>> _loadYellowPages() async {
  String jsonData = await rootBundle.loadString("assets/yellow_pages.json");
  List<dynamic> list = await jsonDecode(jsonData);
  return list.map((e) => SchoolContact.fromJson(e)).toList().cast<SchoolContact>();
}
