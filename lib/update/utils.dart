import 'package:flutter/cupertino.dart';
import 'package:sit/design/adaptive/dialog.dart';
import 'package:sit/design/adaptive/foundation.dart';
import 'package:sit/r.dart';
import 'package:sit/settings/dev.dart';
import 'package:sit/settings/settings.dart';
import 'package:sit/utils/error.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:version/version.dart';

import 'init.dart';
import 'i18n.dart';
import 'page/update.dart';

Future<void> checkAppUpdate({
  required BuildContext context,
  Duration delayAtLeast = Duration.zero,
  required bool manually,
}) async {
  if (UniversalPlatform.isIOS || UniversalPlatform.isMacOS) return;
  try {
    final (latest, _) = await (
      UpdateInit.service.getLatestVersion(),
      Future.delayed(delayAtLeast),
    ).wait;
    debugPrint(latest.toString());
    if (Dev.on && manually) {
      if (!context.mounted) return;
      await context.show$Sheet$((ctx) => ArtifactUpdatePage(info: latest));
    } else {
      final currentVersion = R.currentVersion.version;
      if (latest.downloadOf(R.currentVersion.platform) == null) return;
      // if update checking was not manually triggered, skip it.
      if (!manually && _getSkippedVersion() == latest.version) return;
      final canUpdate = latest.version > currentVersion;
      if (!context.mounted) return;
      if (canUpdate) {
        await context.show$Sheet$((ctx) => ArtifactUpdatePage(info: latest));
      } else if (manually) {
        await context.showTip(title: i18n.title, desc: i18n.onLatestTip, ok: i18n.ok);
      }
    }
  } catch (error, stackTrace) {
    if (!context.mounted) return;
    handleRequestError(context, error, stackTrace);
  }
}

Version? _getSkippedVersion() {
  final skippedVersionRaw = Settings.skippedVersion;
  if (skippedVersionRaw != null) {
    try {
      return Version.parse(skippedVersionRaw);
    } catch (e) {
      return null;
    }
  }
  return null;
}
