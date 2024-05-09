
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sit/game/sudoku/entity/state.dart';

class GameLogic extends StateNotifier<StateSudoku> {
  GameLogic([StateSudoku? initial]) : super(initial ?? StateSudoku.byDefault());
}
