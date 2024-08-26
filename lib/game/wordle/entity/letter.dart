import 'package:flutter/animation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mimir/game/wordle/entity/status.dart';

part "letter.g.dart";

const maxLetters = 5;
const maxAttempts = 6;

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

class WordleLetterLegacy {
  late String letter = "";
  late LetterStatus status = LetterStatus.neutral;
  late AnimationController animation;

  WordleLetterLegacy();
}
