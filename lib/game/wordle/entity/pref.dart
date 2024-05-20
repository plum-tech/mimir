import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'word_set.dart';

part "pref.g.dart";

@JsonSerializable()
@CopyWith(skipFields: true)
class GamePrefWordle {
  final WordleWordSet wordSet;

  const GamePrefWordle({
    this.wordSet = WordleWordSet.all,
  });

  @override
  bool operator ==(Object other) {
    return other is GamePrefWordle && runtimeType == other.runtimeType && wordSet == other.wordSet;
  }

  @override
  int get hashCode => Object.hash(wordSet, 0);

  factory GamePrefWordle.fromJson(Map<String, dynamic> json) => _$GamePrefWordleFromJson(json);

  Map<String, dynamic> toJson() => _$GamePrefWordleToJson(this);
}
