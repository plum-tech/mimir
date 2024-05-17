import 'package:meta/meta.dart';
import 'package:sit/game/entity/blueprint.dart';
import 'package:sit/qrcode/utils.dart';
import 'package:sit/utils/byte_io/reader.dart';
import 'package:sit/utils/byte_io/writer.dart';

import 'board.dart';
import 'mode.dart';
import 'state.dart';

@immutable
class BlueprintSudoku implements GameBlueprint {
  final SudokuBoard board;
  final GameModeSudoku mode;

  const BlueprintSudoku({
    required this.board,
    required this.mode,
  });

  factory BlueprintSudoku.from(String data) {
    final bytes = decodeBytesFromUrl(data);
    final reader = ByteReader(bytes);
    final modeRaw = reader.strUtf8();
    final mode = GameModeSudoku.fromJson(modeRaw);
    final board = SudokuBoard.readBlueprint(reader);
    return BlueprintSudoku(
      board: board,
      mode: mode,
    );
  }

  @override
  String build() {
    final writer = ByteWriter(512);
    writer.strUtf8(mode.toJson());
    board.writeBlueprint(writer);
    final bytes = writer.build();
    return encodeBytesForUrl(bytes);
  }

  @override
  GameStateSudoku create() {
    return GameStateSudoku.newGame(
      mode: mode,
      board: board,
    );
  }
}
