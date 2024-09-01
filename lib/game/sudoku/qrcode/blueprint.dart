import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/game/deep_link/blueprint.dart';
import 'package:mimir/game/sudoku/r.dart';

import '../entity/blueprint.dart';
import '../storage.dart';

const blueprintSudokuDeepLink = GameBlueprintDeepLink<BlueprintSudoku>(
  RSudoku.name,
  onHandleBlueprintSudoku,
);

Future<void> onHandleBlueprintSudoku({
  required BuildContext context,
  required String blueprint,
}) async {
  final blueprintObj = BlueprintSudoku.from(blueprint);
  final state = blueprintObj.create();
  StorageSudoku.save.save(state.toSave());
  context.push("/game/sudoku?continue");
}
