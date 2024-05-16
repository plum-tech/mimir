import 'package:meta/meta.dart';
import 'package:sit/game/entity/blueprint.dart';
import 'package:sit/game/minesweeper/entity/mode.dart';
import 'package:sit/qrcode/utils.dart';
import 'package:sit/utils/byte_io/reader.dart';
import 'package:sit/utils/byte_io/writer.dart';

import 'board.dart';
import 'state.dart';

@immutable
class BlueprintMinesweeper implements GameBlueprint {
  final CellBoardBuilder builder;
  final GameModeMinesweeper mode;

  const BlueprintMinesweeper({
    required this.builder,
    required this.mode,
  });

  factory BlueprintMinesweeper.from(String data) {
    final bytes = decodeBytesFromUrl(data);
    final reader = ByteReader(bytes);
    final modeRaw = reader.strUtf8();
    final mode = GameModeMinesweeper.fromJson(modeRaw);
    final builder = CellBoardBuilder.readBlueprint(reader);
    return BlueprintMinesweeper(builder: builder, mode: mode);
  }

  String build() {
    final writer = ByteWriter(512);
    writer.strUtf8(mode.toJson());
    builder.writeBlueprint(writer);
    final bytes = writer.build();
    return encodeBytesForUrl(bytes);
  }

  GameStateMinesweeper create() {
    builder.updateCells();
    return GameStateMinesweeper(
      mode: mode,
      board: builder.build(),
    );
  }
}
