import 'package:mimir/game/minesweeper/qrcode/blueprint.dart';
import 'package:mimir/game/sudoku/qrcode/blueprint.dart';
import 'package:mimir/r.dart';
import 'package:mimir/settings/deep_link/proxy.dart';
import 'package:mimir/timetable/deep_link/palette.dart';
import 'package:mimir/timetable/deep_link/patch.dart';
import 'package:mimir/timetable/deep_link/timetable.dart';

import 'handler/go_route.dart';
import 'handler/webview.dart';
import 'protocol.dart';

/// convert any data to a URI with [R.scheme].
class DeepLinkHandlers {
  static final List<DeepLinkHandlerProtocol> all = [
    const ProxyDeepLink(),
    const TimetablePaletteDeepLink(),
    const TimetablePatchDeepLink(),
    const TimetableDeepLink(),
    const GoRouteDeepLink(),
    const WebviewDeepLink(),
    blueprintMinesweeperDeepLink,
    blueprintSudokuDeepLink,
  ];
}
