import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:sit/design/adaptive/foundation.dart';
import 'package:sit/r.dart';
import 'package:sit/utils/error.dart';
import 'package:universal_platform/universal_platform.dart';

import 'init.dart';
import 'page/update.dart';

Future<void> checkAppUpdate({
  required BuildContext context,
  Duration delayAtLeast = Duration.zero,
}) async {
  if (UniversalPlatform.isIOS || UniversalPlatform.isMacOS) return;
  try {
    final (latest, _) = await (UpdateInit.service.getLatestVersion(), Future.delayed(delayAtLeast)).wait;
    debugPrint(latest.toString());
    if (latest.downloadOf(R.currentVersion.platform) == null) return;
    final canUpdate = latest.version > R.currentVersion.version;
    if (!context.mounted) return;
    if (canUpdate || kDebugMode) {
      await context.show$Sheet$((ctx) => ArtifactUpdatePage(info: latest));
    }
  } catch (error, stackTrace) {
    debugPrintError(error, stackTrace);
  }
}
