import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/game/minesweeper/r.dart';
import 'package:mimir/game/deep_link/blueprint.dart';

import '../entity/blueprint.dart';
import '../storage.dart';

const blueprintMinesweeperDeepLink = GameBlueprintDeepLink<BlueprintMinesweeper>(
  RMinesweeper.name,
  onHandleBlueprintMinesweeper,
);

Future<void> onHandleBlueprintMinesweeper({
  required BuildContext context,
  required String blueprint,
}) async {
  final blueprintObj = BlueprintMinesweeper.from(blueprint);
  final state = blueprintObj.create();
  StorageMinesweeper.save.save(state.toSave());
  context.push("/game/minesweeper?continue");
}
