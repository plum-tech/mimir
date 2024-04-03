import 'package:json_annotation/json_annotation.dart';

class GameRecord {
  @JsonKey()
  final DateTime ts;

  const GameRecord({
    required this.ts,
  });
}
