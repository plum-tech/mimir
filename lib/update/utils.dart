import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/adaptive/dialog.dart';
import 'package:sit/design/adaptive/foundation.dart';
import 'package:sit/entity/version.dart';
import 'package:sit/r.dart';
import 'package:sit/settings/dev.dart';
import 'package:sit/settings/settings.dart';
import 'package:sit/utils/error.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:version/version.dart';

import 'init.dart';
import 'i18n.dart';
import 'page/update.dart';

Future<void> checkAppUpdate({
  required BuildContext context,
  Duration delayAtLeast = Duration.zero,
  required bool manually,
}) async {
  if (kIsWeb) return;
  try {
    if (UniversalPlatform.isIOS || UniversalPlatform.isMacOS) {
      await _checkAppUpdateFromApple(
        context: context,
        delayAtLeast: delayAtLeast,
        manually: manually,
      );
    } else {
      await _checkAppUpdateFromOfficial(
        context: context,
        delayAtLeast: delayAtLeast,
        manually: manually,
      );
    }
  } catch (error, stackTrace) {
    handleRequestError(context, error, stackTrace);
  }
}

Future<void> _checkAppUpdateFromOfficial({
  required BuildContext context,
  Duration delayAtLeast = Duration.zero,
  required bool manually,
}) async {
  final service = UpdateInit.service;
  final latest = await service.getLatestVersionFromOfficial();
  debugPrint(latest.toString());
  if (kDebugMode && manually) {
    if (!context.mounted) return;
    await context.show$Sheet$((ctx) => ArtifactUpdatePage(info: latest));
    return;
  }
  final currentVersion = R.currentVersion.version;
  if (latest.downloadOf(R.currentVersion.platform) == null) return;
  // if update checking was not manually triggered, skip it.
  if (!manually && _getSkippedVersion() == latest.version) return;
  if (!manually) {
    await Future.delayed(delayAtLeast);
  }
  if (!context.mounted) return;
  if (latest.version > currentVersion) {
    await context.show$Sheet$((ctx) => ArtifactUpdatePage(info: latest));
  } else if (manually) {
    await context.showTip(title: i18n.title, desc: i18n.onLatestTip, ok: i18n.ok);
  }
}

Future<void> _checkAppUpdateFromApple({
  required BuildContext context,
  Duration delayAtLeast = Duration.zero,
  required bool manually,
}) async {
  final (latest, _) = await (
    UpdateInit.service.getLatestVersionFromAppStore(),
    Future.delayed(delayAtLeast),
  ).wait;
  if (latest == null) return;
  debugPrint(latest.toString());
  if (kDebugMode && manually) {
    if (!context.mounted) return;
    await context.show$Sheet$((ctx) => ArtifactUpdatePage(info: latest));
    return;
  }
  final currentVersion = R.currentVersion.version;
  // if update checking was not manually triggered, skip it.
  if (!manually && _getSkippedVersion() == latest.version) return;

  if (!context.mounted) return;
  if (!Dev.on && R.currentVersion.installerStore == InstallerStore.testFlight) {
    if (latest.version >= currentVersion) {
      final res = await showCupertinoModalPopup(
        context: context,
        builder: (ctx) => CupertinoActionSheet(
          message: i18n.installOnAppStoreInsteadTip.text(),
          actions: [
            CupertinoActionSheetAction(
              isDefaultAction: true,
              onPressed: () {
                ctx.pop(true);
              },
              child: i18n.openAppStore.text(),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Settings.skippedVersion = latest.version.toString();
                ctx.pop(false);
              },
              child: i18n.skipThisVersion.text(),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              ctx.pop(false);
            },
            child: i18n.cancel.text(),
          ),
        ),
      );
      if (res == true) {
        await launchUrlString(R.iosAppStoreUrl, mode: LaunchMode.externalApplication);
      }
    }
  } else {
    if (latest.version > currentVersion) {
      await context.show$Sheet$((ctx) => ArtifactUpdatePage(info: latest));
    } else if (manually) {
      await context.showTip(title: i18n.title, desc: i18n.onLatestTip, ok: i18n.ok);
    }
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
