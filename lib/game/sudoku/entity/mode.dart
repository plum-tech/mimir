import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(createToJson: false, createFactory: false)
class GameMode {
  final String name;
  final int blanks;
  static const beginner = GameMode._(
    name: "beginner",
    blanks: 18,
  );
  static const easy = GameMode._(
    name: "easy",
    blanks: 27,
  );
  static const medium = GameMode._(
    name: "medium",
    blanks: 36,
  );
  static const hard = GameMode._(
    name: "hard",
    blanks: 54,
  );

  static final name2mode = {
    "beginner": beginner,
    "easy": easy,
    "medium": medium,
    "hard": hard,
  };

  static final all = [
    beginner,
    easy,
    medium,
    hard,
  ];

  const GameMode._({
    required this.name,
    required this.blanks,
  });

  String toJson() => name;

  factory GameMode.fromJson(String name) => name2mode[name] ?? easy;

  @override
  bool operator ==(Object other) {
    return other is GameMode &&
        runtimeType == other.runtimeType &&
        name == other.name &&
        blanks == other.blanks;
  }

  @override
  int get hashCode => Object.hash(name, blanks);

}
