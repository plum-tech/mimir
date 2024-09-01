import 'package:flutter/widgets.dart';
import 'package:mimir/intent/link/deep_link.dart';
import 'package:mimir/intent/link/utils.dart';
import 'package:mimir/r.dart';

import '../patch/entity/patch.dart';
import '../patch/page/qrcode.dart';

class TimetablePatchDeepLink implements DeepLinkHandlerProtocol {
  static const host = "timetable";
  static const path = "/patch";

  const TimetablePatchDeepLink();

  Uri encode(TimetablePatchEntry entry) => Uri(
      scheme: R.scheme, host: host, path: path, query: encodeBytesForUrl(TimetablePatchEntry.encodeByteList(entry)));

  TimetablePatchEntry decode(Uri qrCodeData) =>
      (TimetablePatchEntry.decodeByteList(decodeBytesFromUrl(qrCodeData.query)));

  @override
  bool match(Uri encoded) {
    // for backwards support
    if (encoded.host.isEmpty && encoded.path == "timetable-patch") return true;
    return encoded.host == host && encoded.path == path;
  }

  @override
  Future<void> onHandle({
    required BuildContext context,
    required Uri qrCodeData,
  }) async {
    final patch = decode(qrCodeData);
    await onTimetablePatchFromQrCode(
      context: context,
      patch: patch,
    );
  }
}
