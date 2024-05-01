import 'package:flutter/widgets.dart';
import 'package:sit/qrcode/protocol.dart';
import 'package:sit/qrcode/utils.dart';
import 'package:sit/r.dart';

import '../entity/platte.dart';
import '../page/p13n/palette.dart';

class TimetablePaletteDeepLink implements DeepLinkHandlerProtocol {
  static const path = "timetable-palette";

  const TimetablePaletteDeepLink();

  Uri encode(TimetablePalette palette) => Uri(
      scheme: R.scheme,
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
    return encoded.path == path;
  }

  @override
  Future<void> onHandle({
    required BuildContext context,
    required Uri qrCodeData,
  }) async {
    final palette = decode(qrCodeData);
    await onTimetablePaletteFromQrCode(
      context: context,
      palette: palette,
    );
  }
}
