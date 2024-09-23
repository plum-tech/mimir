import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/agreements/entity/agreements.dart';
import 'package:rettulf/rettulf.dart';
import 'package:mimir/design/adaptive/dialog.dart';
import 'package:mimir/design/adaptive/foundation.dart';
import 'package:mimir/r.dart';
import 'package:mimir/settings/settings.dart';
import 'package:mimir/utils/error.dart';
import 'package:version/version.dart';

import '../init.dart';
import '../i18n.dart';
import 'entity/version.dart';
import 'page/update.dart';

Future<void> checkAppUpdate({
  required BuildContext context,
  Duration delayAtLeast = Duration.zero,
  required bool manually,
}) async {
  if (kIsWeb) return;
  if (Settings.agreements.getBasicAcceptanceOf(AgreementVersion.current) != true) return;
  try {
    await _checkAppUpdate(
      context: context,
      delayAtLeast: delayAtLeast,
      manually: manually,
    );
  } catch (error, stackTrace) {
    handleRequestError(error, stackTrace);
  }
}

bool _canSkipVersion({
  required VersionInfo latest,
  required Version current,
}) {
  final lastSkipUpdateTime = Settings.lastSkipUpdateTime;
  if (lastSkipUpdateTime == null) return false;
  if (_getSkippedVersion() != latest.version) return false;
  final now = DateTime.now();
  if (lastSkipUpdateTime.difference(now).inMinutes >= latest.minuteCanDelay) return false;
  return true;
}

Future<void> _checkAppUpdate({
  required BuildContext context,
  Duration delayAtLeast = Duration.zero,
  required bool manually,
}) async {
  final latest = await BackendInit.update.getLatestVersionInfo();
  if (!latest.assets.downloadAvailable) return;
  final currentVersion = R.meta.version;
  // if update checking was not manually triggered, skip it.
  if (!manually && _canSkipVersion(latest: latest, current: currentVersion)) return;
  if (!manually) {
    await Future.delayed(delayAtLeast);
  }
  if (!context.mounted) return;
  if (latest.version > currentVersion) {
    await context.showSheet(
      (ctx) => ArtifactUpdatePage(info: latest),
      dismissible: false,
    );
  } else if (manually) {
    await context.showTip(
      title: i18n.up.title,
      desc: i18n.up.onLatestTip,
      primary: i18n.ok,
    );
  }
}

Future<bool> _requestInstallOnAppStoreInstead({
  required BuildContext context,
  required Version latest,
}) async {
  return await showCupertinoModalPopup(
    context: context,
    builder: (ctx) => CupertinoActionSheet(
      message: i18n.up.installOnAppStoreInsteadTip.text(),
      actions: [
        CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () {
            ctx.pop(true);
          },
          child: i18n.up.openAppStore.text(),
        ),
        CupertinoActionSheetAction(
          onPressed: () {
            Settings.skippedVersion = latest.toString();
            Settings.lastSkipUpdateTime = DateTime.now();
            ctx.pop(false);
          },
          child: i18n.up.skipThisVersionFor7Days.text(),
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
