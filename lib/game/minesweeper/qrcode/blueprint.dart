import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:sit/game/minesweeper/storage.dart';
import 'package:sit/game/qrcode/blueprint.dart';

import '../entity/blueprint.dart';

const blueprintMinesweeperDeepLink = GameBlueprintDeepLink(
  "minesweeper",
  onBlueprintMinesweeper,
);

Future<void> onBlueprintMinesweeper({
  required BuildContext context,
  required String blueprint,
}) async {
  final blueprintObj = BlueprintMinesweeper.from(blueprint);
  final state = blueprintObj.create();
  StorageMinesweeper.save.save(state.toSave());
  context.push("/game/minesweeper?continue");
}
