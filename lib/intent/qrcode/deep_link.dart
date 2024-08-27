import 'package:flutter/cupertino.dart';
import 'package:mimir/game/minesweeper/qrcode/blueprint.dart';
import 'package:mimir/game/sudoku/qrcode/blueprint.dart';
import 'package:mimir/r.dart';
import 'package:mimir/settings/qrcode/proxy.dart';
import 'package:mimir/timetable/qrcode/palette.dart';
import 'package:mimir/timetable/qrcode/patch.dart';
import 'package:mimir/timetable/qrcode/timetable.dart';

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
