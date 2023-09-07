import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mimir/global/init.dart';
import 'package:mimir/migration/migrations.dart';
import 'package:mimir/school/yellow_pages/entity/contact.dart';
import 'package:path_provider/path_provider.dart';

import 'app.dart';

import 'l10n/yaml_assets_loader.dart';
import 'r.dart';

void main() async {
  // debugRepaintRainbowEnabled = true;
  // debugRepaintTextRainbowEnabled = true;
  // debugPaintSizeEnabled = true;
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  final appDocDir = await getApplicationDocumentsDirectory();
  R.appDir = appDocDir.path;
  final tmpDir = await getTemporaryDirectory();
  R.tmpDir = tmpDir.path;
  R.roomList = await _loadRoomNumberList();
  R.userAgents = await _loadUserAgents();
  R.yellowPages = await _loadYellowPages();
  Migrations.init();
  await Init.init();
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
  String jsonData = await rootBundle.loadString("assets/ua.json");
  List<dynamic> list = await jsonDecode(jsonData);
  return list.cast<String>();
}

Future<List<SchoolContact>> _loadYellowPages() async {
  String jsonData = await rootBundle.loadString("assets/yellow_pages.json");
  List<dynamic> list = await jsonDecode(jsonData);
  return list.map((e) => SchoolContact.fromJson(e)).toList().cast<SchoolContact>();
}
