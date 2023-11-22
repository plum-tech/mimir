import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sit/files.dart';
import 'package:sit/hive/init.dart';
import 'package:sit/init.dart';
import 'package:sit/migration/migrations.dart';
import 'package:sit/platform/desktop.dart';
import 'package:sit/school/yellow_pages/entity/contact.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sit/settings/meta.dart';
import 'package:sit/settings/settings.dart';
import 'package:sit/entity/version.dart';
import 'package:system_theme/system_theme.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:version/version.dart';

import 'app.dart';

import 'l10n/yaml_assets_loader.dart';
import 'r.dart';

void main() async {
  // debugRepaintRainbowEnabled = true;
  // debugRepaintTextRainbowEnabled = true;
  // debugPaintSizeEnabled = true;
  WidgetsFlutterBinding.ensureInitialized();
  Migrations.init();
  // Initialize the window size before others for a better experience when loading.
  await DesktopInit.init();
  await SystemTheme.accentColor.load();
  await EasyLocalization.ensureInitialized();

  if (!kIsWeb) {
    Files.cache = await getApplicationCacheDirectory();
    Files.temp = await getTemporaryDirectory();
    Files.internal = await getApplicationSupportDirectory();
    Files.user = await getApplicationDocumentsDirectory();
  }
  await Files.init();
  final prefs = await SharedPreferences.getInstance();

  R.roomList = await _loadRoomNumberList();
  R.userAgentList = await _loadUserAgents();
  R.yellowPages = await _loadYellowPages();
  R.currentVersion = await getCurrentVersion();

  // Perform migrations
  final currentVersion = R.currentVersion.full;
  final lastVersionRaw = prefs.getString("${R.appId}.lastVersion");
  final lastVersion = lastVersionRaw != null ? Version.parse(lastVersionRaw) : currentVersion;
  await Migrations.perform(from: lastVersion, to: currentVersion);
  await prefs.setString("${R.appId}.lastVersion", lastVersion.toString());

  // Initialize Hive
  await HiveInit.init(Files.internal.subDir("hive", R.hiveStorageVersion));
  await HiveInit.initBox();

  // Setup Settings and Meta
  Settings.isDeveloperMode = kDebugMode;
  // The first time when user launch this app
  Meta.installTime ??= DateTime.now();
  // The last time when user launch this app
  Meta.lastStartupTime = DateTime.now();
  if (UniversalPlatform.isDesktop) {
    final lastWindowSize = Settings.lastWindowSize;
    if (lastWindowSize != null) {
      DesktopInit.resizeTo(lastWindowSize);
    }
  }
  await DesktopInit.postInit();
  Init.registerCustomEditor();
  await Init.initNetwork();
  await Init.initModuleStorage();
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
