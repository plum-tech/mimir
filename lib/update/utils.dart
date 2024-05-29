import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/credentials/init.dart';
import 'package:sit/design/adaptive/dialog.dart';
import 'package:sit/design/adaptive/foundation.dart';
import 'package:sit/entity/meta.dart';
import 'package:sit/r.dart';
import 'package:sit/settings/dev.dart';
import 'package:sit/settings/settings.dart';
import 'package:sit/utils/error.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:version/version.dart';

import 'entity/artifact.dart';
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
    if (R.debugCupertino || UniversalPlatform.isIOS || UniversalPlatform.isMacOS) {
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
    handleRequestError(error, stackTrace);
  }
}

bool _canSkipVersion({
  required Version latest,
  required Version current,
}) {
  final lastSkipUpdateTime = Settings.lastSkipUpdateTime;
  if (lastSkipUpdateTime == null) return false;
  if (_getSkippedVersion() != latest) return false;
  final now = DateTime.now();
  if (lastSkipUpdateTime.difference(now).inDays < 7) return false;
  return true;
}

/// randomly delay [0,2) hours after a new version release
bool _isTimeToShow({
  required ArtifactVersionInfo latest,
}) {
  final releaseTime = latest.releaseTime;
  if (releaseTime == null) return true;
  final now = DateTime.now();
  final rand = Random(CredentialsInit.storage.oaCredentials?.account.hashCode);
  final minuteDelta = rand.nextInt(2 * 60 * 60);
  final delay = Duration(minutes: minuteDelta);
  final showAfter = releaseTime.add(delay);
  return now.isAfter(showAfter);
}

Future<void> _checkAppUpdateFromOfficial({
  required BuildContext context,
  Duration delayAtLeast = Duration.zero,
  required bool manually,
}) async {
  final latest = await UpdateInit.service.getLatestVersionFromOfficial();
  debugPrint(latest.toString());
  final currentVersion = R.meta.version;
  if (latest.downloadOf(R.meta.platform) == null) return;
  // if not manually triggered, delay a while
  if (!manually && !_isTimeToShow(latest: latest)) return;
  // if update checking was not manually triggered, skip it.
  if (!manually && _canSkipVersion(latest: latest.version, current: currentVersion)) return;
  if (!manually) {
    await Future.delayed(delayAtLeast);
  }
  if (!context.mounted) return;
  if (latest.version > currentVersion) {
    await context.showSheet((ctx) => ArtifactUpdatePage(info: latest));
  } else if (manually) {
    await context.showTip(title: i18n.title, desc: i18n.onLatestTip, primary: i18n.ok);
  }
}

Future<void> _checkAppUpdateFromApple({
  required BuildContext context,
  Duration delayAtLeast = Duration.zero,
  required bool manually,
}) async {
  final latest = await UpdateInit.service.getLatestVersionFromAppStoreAndOfficial();
  if (latest == null) {
    // if the version from iTunes isn't identical to official's
    if (manually) {
      if (!context.mounted) return;
      await context.showTip(title: i18n.title, desc: i18n.onLatestTip, primary: i18n.ok);
    }
    return;
  }
  debugPrint(latest.toString());
  final currentVersion = R.meta.version;
  // if not manually triggered, delay a while
  if (!manually && !_isTimeToShow(latest: latest)) return;
  // if update checking was not manually triggered, skip it.
  if (!manually && _canSkipVersion(latest: latest.version, current: currentVersion)) return;
  if (!manually) {
    await Future.delayed(delayAtLeast);
  }
  if (!context.mounted) return;
  final installerStore = R.meta.installerStore;
  if (!Dev.on && installerStore == InstallerStore.testFlight) {
    // commanded non-dev user to install app from App Store
    if (latest.version >= currentVersion) {
      final confirm = await _requestInstallOnAppStoreInstead(context: context, latest: latest.version);
      if (confirm == true) {
        await launchUrlString(R.iosAppStoreUrl, mode: LaunchMode.externalApplication);
      }
    }
  } else if (installerStore == InstallerStore.appStore) {
    if (latest.version > currentVersion) {
      await context.showSheet((ctx) => ArtifactUpdatePage(info: latest));
    } else if (manually) {
      await context.showTip(title: i18n.title, desc: i18n.onLatestTip, primary: i18n.ok);
    }
  }
}

Future<bool> _requestInstallOnAppStoreInstead({
  required BuildContext context,
  required Version latest,
}) async {
  return await showCupertinoModalPopup(
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
            Settings.skippedVersion = latest.toString();
            Settings.lastSkipUpdateTime = DateTime.now();
            ctx.pop(false);
          },
          child: i18n.skipThisVersionFor7Days.text(),
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
