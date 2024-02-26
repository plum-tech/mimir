import 'package:flutter/cupertino.dart';
import 'package:sit/design/adaptive/foundation.dart';
import 'package:sit/r.dart';
import 'package:sit/settings/settings.dart';
import 'package:sit/utils/error.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:version/version.dart';

import 'init.dart';
import 'page/update.dart';

Future<void> checkAppUpdate({
  required BuildContext context,
  Duration delayAtLeast = Duration.zero,
}) async {
  if (UniversalPlatform.isIOS || UniversalPlatform.isMacOS) return;
  try {
    final (latest, _) = await (
      UpdateInit.service.getLatestVersion(),
      Future.delayed(delayAtLeast),
    ).wait;
    debugPrint(latest.toString());
    if (!Settings.devMode) {
      final currentVersion = R.currentVersion.version;
      if (latest.downloadOf(R.currentVersion.platform) == null) return;
      final skippedVersionRaw = Settings.skippedVersion;
      if (skippedVersionRaw != null) {
        final skippedVersion = Version.parse(skippedVersionRaw);
        if (skippedVersion == latest.version) return;
      }
      final canUpdate = latest.version > currentVersion;
      if (!canUpdate) return;
    }
    if (!context.mounted) return;
    await context.show$Sheet$((ctx) => ArtifactUpdatePage(info: latest));
  } catch (error, stackTrace) {
    debugPrintError(error, stackTrace);
  }
}
