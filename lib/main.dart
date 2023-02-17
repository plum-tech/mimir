import 'package:catcher/catcher.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:mimir/global/init.dart';
import 'package:mimir/migration/migrations.dart';
import 'package:mimir/mimir/mimir.dart';
import 'package:mimir/util/catcher_handler.dart';

import 'app.dart';

import 'l10n/yaml_assets_loader.dart';
import 'mimir_plugins.dart';
import 'r.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  Migrations.init();
  mimir.install(DefaultFlutterDataAdapterPlugin);
  mimir.install(DataAdapterPlugin);
  mimir.install(DebugPlugin);
  await Init.init();
  CatcherOptions buildCatcherConfig(bool releaseMode) => CatcherOptions(
        SilentReportMode(),
        [
          ConsoleHandler(),
          MimirDialogHandler(),
          MimirToastHandler(),
        ],
      );
  Catcher(
    rootWidget: Phoenix(
      child: const MimirApp(),
    ).withEasyLocalization(),
    releaseConfig: buildCatcherConfig(true),
    debugConfig: buildCatcherConfig(false),
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
}
