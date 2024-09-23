import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:mimir/agreements/entity/agreements.dart';
import 'package:mimir/design/adaptive/dialog.dart';
import 'package:mimir/design/adaptive/foundation.dart';
import 'package:mimir/feature/feature.dart';
import 'package:mimir/feature/utils.dart';
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
  if (!can(AppFeature.mimirUpdate)) return;
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
  final lastSkipUpdateTime = Settings.update.lastSkipUpdateTime;
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
  final latest = await BackendInit.update.getLatestVersionInfo(channel: Settings.update.updateChannel);
  if (!latest.assets.downloadAvailable) return;
  final currentVersion = R.meta.version;
  // if update checking was not manually triggered, skip it.
  if (!manually && _canSkipVersion(latest: latest, current: currentVersion)) return;
  if (!manually) {
    await Future.delayed(delayAtLeast);
  }
  if (!context.mounted) return;
  if (latest.version.compareToIncludingBuild(currentVersion) > 0) {
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

extension VersionEx on Version {
  int compareToIncludingBuild(Version other) {
    final result = compareTo(other);
    if (result == 0) {
      final thisBuild = int.tryParse(build);
      final otherBuild = int.tryParse(other.build);
      if (thisBuild != null && otherBuild == null) {
        return 1;
      } else if (thisBuild == null && otherBuild != null) {
        return -1;
      } else if (thisBuild != null && otherBuild != null) {
        return thisBuild.compareTo(otherBuild);
      }
    }
    return result;
  }
}

Version? _getSkippedVersion() {
  final skippedVersionRaw = Settings.update.skippedVersion;
  if (skippedVersionRaw != null) {
    try {
      return Version.parse(skippedVersionRaw);
    } catch (e) {
      return null;
    }
  }
  return null;
}
