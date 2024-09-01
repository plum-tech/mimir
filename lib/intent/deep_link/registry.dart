import 'package:mimir/game/minesweeper/qrcode/blueprint.dart';
import 'package:mimir/game/sudoku/qrcode/blueprint.dart';
import 'package:mimir/r.dart';
import 'package:mimir/settings/qrcode/proxy.dart';
import 'package:mimir/timetable/qrcode/palette.dart';
import 'package:mimir/timetable/qrcode/patch.dart';
import 'package:mimir/timetable/qrcode/timetable.dart';

import 'handler/go_route.dart';
import 'protocol.dart';

/// convert any data to a URI with [R.scheme].
class DeepLinkHandlers {
  static final List<DeepLinkHandlerProtocol> all = [
    const ProxyDeepLink(),
    const TimetablePaletteDeepLink(),
    const TimetablePatchDeepLink(),
    const TimetableDeepLink(),
    const GoRouteDeepLink(),
    blueprintMinesweeperDeepLink,
    blueprintSudokuDeepLink,
  ];
}
