import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(createToJson: false, createFactory: false)
class GameMode {
  final String name;
  final int blanks;
  final bool enableFillerHint;
  static const beginner = GameMode._(
    name: "beginner",
    blanks: 18,
    enableFillerHint: true,
  );
  static const easy = GameMode._(
    name: "easy",
    blanks: 27,
    enableFillerHint: true,
  );
  static const medium = GameMode._(
    name: "medium",
    blanks: 36,
  );
  static const hard = GameMode._(
    name: "hard",
    blanks: 54,
  );
  static const master = GameMode._(
    name: "master",
    blanks: 57,
  );

  static final name2mode = {
    "beginner": beginner,
    "easy": easy,
    "medium": medium,
    "hard": hard,
    "master": master,
  };

  static final all = [
    beginner,
    easy,
    medium,
    hard,
    master,
  ];

  const GameMode._({
    required this.name,
    required this.blanks,
    this.enableFillerHint = false,
  });

  String toJson() => name;

  factory GameMode.fromJson(String name) => name2mode[name] ?? easy;

  @override
  bool operator ==(Object other) {
    return other is GameMode && runtimeType == other.runtimeType && name == other.name && blanks == other.blanks;
  }

  @override
  int get hashCode => Object.hash(name, blanks);
}
