import 'package:flutter/widgets.dart';
import 'package:mimir/intent/deep_link/protocol.dart';
import 'package:mimir/intent/deep_link/utils.dart';
import 'package:mimir/r.dart';

import '../p13n/entity/palette.dart';
import '../p13n/page/palette.dart';

class TimetablePaletteDeepLink implements DeepLinkHandlerProtocol {
  static const host = "timetable";
  static const path = "/palette";

  const TimetablePaletteDeepLink();

  Uri encode(TimetablePalette palette) => Uri(
      scheme: R.scheme,
      host: host,
      path: path,
      query: encodeBytesForUrl(
        palette.encodeByteList(),
        compress: false,
      ));

  TimetablePalette decode(Uri qrCodeData) => TimetablePalette.decodeFromByteList(decodeBytesFromUrl(
        qrCodeData.query,
        compress: false,
      ));

  @override
  bool match(Uri encoded) {
    // for backwards support
    if (encoded.host.isEmpty && encoded.path == "timetable-palette") return true;
    return encoded.host == host && encoded.path == path;
  }

  @override
  Future<void> onHandle({
    required BuildContext context,
    required Uri data,
  }) async {
    final palette = decode(data);
    await onTimetablePaletteFromQrCode(
      context: context,
      palette: palette,
    );
  }
}
