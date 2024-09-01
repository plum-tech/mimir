import 'package:meta/meta.dart';
import 'package:mimir/game/entity/blueprint.dart';
import 'package:mimir/game/wordle/entity/state.dart';
import 'package:mimir/intent/link/utils.dart';
import 'package:mimir/utils/byte_io/reader.dart';
import 'package:mimir/utils/byte_io/writer.dart';

@immutable
class BlueprintWordle implements GameBlueprint<GameStateWordle> {
  final String word;

  const BlueprintWordle({
    required this.word,
  });

  factory BlueprintWordle.from(String data) {
    final bytes = decodeBytesFromUrl(data);
    final reader = ByteReader(bytes);
    final word = reader.strUtf8();
    return BlueprintWordle(
      word: word,
    );
  }

  @override
  String build() {
    final writer = ByteWriter(64);
    writer.strUtf8(word);
    final bytes = writer.build();
    return encodeBytesForUrl(bytes);
  }

  @override
  GameStateWordle create() {
    return GameStateWordle(
      word: word,
    );
  }
}
