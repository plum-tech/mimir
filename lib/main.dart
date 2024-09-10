import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/storage/objectbox/init.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mimir/files.dart';
import 'package:mimir/network/proxy.dart';
import 'package:mimir/platform/windows/windows.dart';
import 'package:mimir/storage/hive/init.dart';
import 'package:mimir/init.dart';
import 'package:mimir/migration/migrations.dart';
import 'package:mimir/platform/desktop.dart';
import 'package:mimir/school/yellow_pages/entity/contact.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mimir/settings/meta.dart';
import 'package:mimir/settings/dev.dart';
import 'package:mimir/entity/meta.dart';
import 'package:mimir/storage/prefs.dart';
import 'package:mimir/utils/error.dart';
import 'package:system_theme/system_theme.dart';
import 'package:uuid/uuid.dart';
import 'package:version/version.dart';

import 'app.dart';

import 'l10n/yaml_assets_loader.dart';
import 'r.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb && kDebugMode) {
    // waiting for debugger connecting to chrome
    await Future.delayed(const Duration(seconds: 5));
  }
  // debugRepaintRainbowEnabled = true;
  // debugRepaintTextRainbowEnabled = true;
  // debugPaintSizeEnabled = true;
  GoRouter.optionURLReflectsImperativeAPIs = kDebugMode;
  if (kDebugMode && !kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    await InAppWebViewController.setWebContentsDebuggingEnabled(kDebugMode);
  }
  final prefs = await SharedPreferences.getInstance();
  final lastSize = prefs.getLastWindowSize();
  await DesktopInit.init(size: lastSize);
  await WindowsInit.registerCustomScheme(R.scheme);
  final installationTime = prefs.getInstallTime();
  debugPrint("First installation time: $installationTime");
  if (installationTime == null) {
    await prefs.setInstallTime(DateTime.now());
  }
  final uuid = prefs.getUuid();
  if (uuid == null) {
    final newUuid = const Uuid().v4();
    await prefs.setUuid(newUuid);
    R.uuid = newUuid;
  } else {
    R.uuid = uuid;
  }

  // Initialize the window size before others for a better experience when loading.
  try {
    await SystemTheme.accentColor.load();
  } catch (error, stackTrace) {
    debugPrintError(error, stackTrace);
  }
  await EasyLocalization.ensureInitialized();
  Migrations.init();

  if (!kIsWeb) {
    await Files.init(
      temp: await getTemporaryDirectory(),
      cache: await getApplicationCacheDirectory(),
      internal: await getApplicationSupportDirectory(),
      user: await getApplicationDocumentsDirectory(),
    );
  }
  // Perform migrations
  R.meta = await getCurrentVersion();
  final currentVersion = R.meta.version;
  final lastVersionRaw = prefs.getLastVersion();
  final lastVersion = lastVersionRaw != null ? Version.parse(lastVersionRaw) : currentVersion;
  debugPrint("Last version: $lastVersion");
  await prefs.setLastVersion(currentVersion.toString());
  final migrations = Migrations.match(from: lastVersion, to: currentVersion);
  // final migrations = Migrations.match(from: Version(2, 3, 2), to: currentVersion);

  await migrations.perform(MigrationPhrase.beforeHive);

  R.roomList = await _loadRoomNumberList();
  R.yellowPages = await _loadYellowPages();

  // Initialize Hive
  if (!kIsWeb) {
    await HiveInit.initLocalStorage(
      coreDir: Files.internal.subDir("hive", R.hiveStorageVersionCore),
      // iOS will clear the cache under [getApplicationCacheDirectory()] when device has no enough storage.
      cacheDir: Files.internal.subDir("hive-cache", R.hiveStorageVersionCache),
    );
    if (kDebugMode) {
      final objectBoxDir = Files.internal.subDir("obx", R.objectBoxStorageVersion);
      await objectBoxDir.create(recursive: true);
      await ObjectBoxInit.init(
        dir: objectBoxDir,
      );
    }
  }
  HiveInit.initAdapters();
  await HiveInit.initBox();

  // Setup Settings and Meta
  if (kDebugMode) {
    Dev.on = true;
  }
  // The last time when user launch this app
  Meta.lastLaunchTime = Meta.thisLaunchTime;
  Meta.thisLaunchTime = DateTime.now();
  Init.registerCustomEditor();
  await migrations.perform(MigrationPhrase.afterHive);
  HttpOverrides.global = SitHttpOverrides();
  await Init.initNetwork();
  await Init.initModules();
  await Init.initStorage();
  await migrations.perform(MigrationPhrase.afterInitStorage);
  runApp(
    ProviderScope(
      child: EasyLocalization(
        supportedLocales: R.supportedLocales,
        path: 'assets/l10n',
        fallbackLocale: R.defaultLocale,
        useFallbackTranslations: true,
        assetLoader: _yamlAssetsLoader,
        child: const MimirApp(),
      ),
    ),
  );
}

final _yamlAssetsLoader = YamlAssetLoader();

Future<List<String>> _loadRoomNumberList() async {
  String jsonData = await rootBundle.loadString("assets/room_list.json");
  List<dynamic> list = jsonDecode(jsonData);
  return list.map((e) => e.toString()).toList();
}

Future<List<SchoolContact>> _loadYellowPages() async {
  String jsonData = await rootBundle.loadString("assets/yellow_pages.json");
  List<dynamic> list = jsonDecode(jsonData);
  return list.map((e) => SchoolContact.fromJson(e)).toList().cast<SchoolContact>();
}
