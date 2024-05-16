import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:sit/game/minesweeper/storage.dart';
import 'package:sit/qrcode/deep_link.dart';
import 'package:sit/r.dart';

import '../entity/blueprint.dart';

class BlueprintMinesweeperDeepLink implements DeepLinkHandlerProtocol {
  static const host = "game";
  static const path = "/minesweeper/blueprint";

  const BlueprintMinesweeperDeepLink();

  Uri encode(BlueprintMinesweeper blueprint) => Uri(
        scheme: R.scheme,
        host: host,
        path: path,
        query: blueprint.build(),
      );

  Uri encodeString(String blueprint) => Uri(
        scheme: R.scheme,
        host: host,
        path: path,
        query: blueprint,
      );

  @override
  bool match(Uri encoded) {
    // for backwards support
    if (encoded.host.isEmpty && encoded.path == "timetable") return true;
    return encoded.host == host && encoded.path == path;
  }

  @override
  Future<void> onHandle({
    required BuildContext context,
    required Uri qrCodeData,
  }) async {
    final blueprint = qrCodeData.query;
    await onBlueprintMinesweeper(
      context: context,
      blueprint: blueprint,
    );
  }
}

Future<void> onBlueprintMinesweeper({
  required BuildContext context,
  required String blueprint,
}) async {
  final blueprintObj = BlueprintMinesweeper.from(blueprint);
  final state = blueprintObj.create();
  StorageMinesweeper.save.save(state.toSave());
  context.push("/game/minesweeper?continue");
}
