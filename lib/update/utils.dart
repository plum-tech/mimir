import 'package:flutter/cupertino.dart';
import 'package:sit/design/adaptive/foundation.dart';
import 'package:sit/r.dart';
import 'package:universal_platform/universal_platform.dart';

import 'init.dart';
import 'page/update.dart';

Future<void> checkAppUpdate({
  required BuildContext context,
}) async {
  final latest = await UpdateInit.service.getLatestVersion();
  debugPrint(latest.toString());
  final canUpdate = latest.version > R.currentVersion.version;
  if (!context.mounted) return;
  if (canUpdate) {
    debugPrint("Can update");
  }
  if (UniversalPlatform.isIOS || UniversalPlatform.isMacOS || latest.downloadOf(R.currentVersion.platform) == null) {
    return;
  }
  context.show$Sheet$((ctx) => ArtifactUpdatePage(info: latest));
}

