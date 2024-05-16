import 'package:meta/meta.dart';

@immutable
abstract class GameBlueprint<TGame> {
  const GameBlueprint();

  String build();

  TGame create();
}
