import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mimir/global/init.dart';
import 'package:mimir/migration/migrations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:receive_intent/receive_intent.dart';
import 'package:uri_to_file/uri_to_file.dart';

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
  Migrations.init();
  await Init.init();
  await _initReceiveIntent();
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

late StreamSubscription _sub;

Future<void> _initReceiveIntent() async {
  // ... check initialIntent

  // Attach a listener to the stream
  _sub = ReceiveIntent.receivedIntentStream.listen((intent) async {
    // Validate receivedIntent and warn the user, if it is not correct,
    print(">>>>>>>>>>>>>>>>>>${intent}");
    if (intent == null) return;
    final data = intent.data;
    if (data == null) return;
    final fi = await toFile(data);
    final content = fi.readAsStringSync();
    print(content);
  }, onError: (err) {
    // Handle exception
  });

  // NOTE: Don't forget to call _sub.cancel() in dispose()
}
