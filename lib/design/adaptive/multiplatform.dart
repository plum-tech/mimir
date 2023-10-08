import 'package:flutter/cupertino.dart';
import 'package:mimir/r.dart';
import 'package:universal_platform/universal_platform.dart';

bool get isCupertino => R.debugCupertino || UniversalPlatform.isIOS || UniversalPlatform.isMacOS;

extension ShareX on BuildContext {
  Rect? getSharePositionOrigin() {
    final box = findRenderObject() as RenderBox?;
    final sharePositionOrigin = box == null ? null : box.localToGlobal(Offset.zero) & box.size;
    if (UniversalPlatform.isIOS || UniversalPlatform.isMacOS) {
      assert(sharePositionOrigin != null, "sharePositionOrigin should be nonnull on iPad and macOS");
    }
    return sharePositionOrigin;
  }
}
