import 'package:flutter/cupertino.dart';
import 'package:sit/game/minesweeper/qrcode/blueprint.dart';
import 'package:sit/game/sudoku/qrcode/blueprint.dart';
import 'package:sit/r.dart';
import 'package:sit/settings/qrcode/proxy.dart';
import 'package:sit/timetable/qrcode/palette.dart';
import 'package:sit/timetable/qrcode/timetable.dart';

import '../timetable/qrcode/patch.dart';

/// convert any data to a URI with [R.scheme].
abstract class DeepLinkHandlerProtocol {
  const DeepLinkHandlerProtocol();

  bool match(Uri encoded);

  Future<void> onHandle({
    required BuildContext context,
    required Uri qrCodeData,
  });

  static final List<DeepLinkHandlerProtocol> all = [
    const ProxyDeepLink(),
    const TimetablePaletteDeepLink(),
    const TimetablePatchDeepLink(),
    const TimetableDeepLink(),
    blueprintMinesweeperDeepLink,
    blueprintSudokuDeepLink,
  ];
}
