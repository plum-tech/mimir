import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mimir/global/init.dart';
import 'package:mimir/migration/migrations.dart';

import 'app.dart';

import 'l10n/yaml_assets_loader.dart';
import 'r.dart';

void main() async {
  debugRepaintRainbowEnabled = true;
  debugRepaintTextRainbowEnabled = true;
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  Migrations.init();
  await Init.init();
  runApp(const MimirApp().withEasyLocalization());
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
}
