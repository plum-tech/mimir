import 'package:json_annotation/json_annotation.dart';
import 'package:sit/game/wordle/entity/status.dart';

part "letter.g.dart";

@JsonSerializable()
class WordleLetter {
  final String letter;
  final LetterStatus status;

  const WordleLetter({
    required this.letter,
    required this.status,
  });

  Map<String, dynamic> toJson() => _$WordleLetterToJson(this);

  factory WordleLetter.fromJson(Map<String, dynamic> json) => _$WordleLetterFromJson(json);
}
