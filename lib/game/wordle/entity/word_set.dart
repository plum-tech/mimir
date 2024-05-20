import 'package:easy_localization/easy_localization.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sit/game/entity/game_mode.dart';

@JsonSerializable(createToJson: false, createFactory: false)
class WordleWordSet extends GameMode {
  const WordleWordSet._({
    required super.name,
  });

  static const all = WordleWordSet._(
    name: "all",
  );
  static const cet4 = WordleWordSet._(
    name: "cet-4",
  );
  static const cet6 = WordleWordSet._(
    name: "cet-6",
  );
  static const toefl = WordleWordSet._(
    name: "toefl",
  );
  static final name2mode = {
    "all": all,
    "cet-4": cet4,
    "cet-6": cet6,
    "toefl": toefl,
  };

  static final values = [
    all,
    cet4,
    cet6,
    toefl,
  ];

  factory WordleWordSet.fromJson(String name) => name2mode[name] ?? all;

  @override
  bool operator ==(Object other) {
    return other is WordleWordSet && runtimeType == other.runtimeType && name == other.name;
  }

  @override
  int get hashCode => Object.hash(name, 0);

  @override
  String l10n() => "game.wordle.wordSet.$name".tr();
}
