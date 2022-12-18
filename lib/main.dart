import 'package:catcher/catcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:mimir/global/init.dart';
import 'package:mimir/migration/migrations.dart';
import 'package:mimir/mimir/mimir.dart';
import 'package:mimir/util/catcher_handler.dart';

import 'app.dart';

import 'mimir_plugins.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Migrations.init();
  mimir.install(DefaultFlutterDataAdapterPlugin);
  mimir.install(DataAdapterPlugin);
  mimir.install(DebugPlugin);
  await Initializer.init();
  CatcherOptions buildCatcherConfig(bool releaseMode) => CatcherOptions(
        SilentReportMode(),
        [
          ConsoleHandler(),
          KiteDialogHandler(),
          KiteToastHandler(),
        ],
      );
  Catcher(
    rootWidget: Phoenix(child: const MimirApp()),
    releaseConfig: buildCatcherConfig(true),
    debugConfig: buildCatcherConfig(false),
  );
}
