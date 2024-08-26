import 'package:meta/meta.dart';
import 'package:mimir/game/entity/blueprint.dart';
import 'package:mimir/qrcode/utils.dart';
import 'package:mimir/utils/byte_io/reader.dart';
import 'package:mimir/utils/byte_io/writer.dart';

import 'board.dart';
import 'state.dart';
import 'mode.dart';

@immutable
class BlueprintMinesweeper implements GameBlueprint<GameStateMinesweeper> {
  final ({int row, int column}) firstClick;
  final CellBoardBuilder builder;
  final GameModeMinesweeper mode;

  const BlueprintMinesweeper({
    required this.firstClick,
    required this.builder,
    required this.mode,
  });

  factory BlueprintMinesweeper.from(String data) {
    final bytes = decodeBytesFromUrl(data);
    final reader = ByteReader(bytes);
    final modeRaw = reader.strUtf8();
    final firstClick = (
      row: reader.uint8(),
      column: reader.uint8(),
    );
    final mode = GameModeMinesweeper.fromJson(modeRaw);
    final builder = CellBoardBuilder.readBlueprint(reader);
    return BlueprintMinesweeper(
      firstClick: firstClick,
      builder: builder,
      mode: mode,
    );
  }

  @override
  String build() {
    final writer = ByteWriter(512);
    writer.strUtf8(mode.toJson());
    writer.uint8(firstClick.row);
    writer.uint8(firstClick.column);
    builder.writeBlueprint(writer);
    final bytes = writer.build();
    return encodeBytesForUrl(bytes);
  }

  @override
  GameStateMinesweeper create() {
    builder.updateCells();
    return GameStateMinesweeper(
      mode: mode,
      board: builder.build(),
      firstClick: firstClick,
    );
  }
}
