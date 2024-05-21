import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'vocabulary.dart';

part "pref.g.dart";

@JsonSerializable()
@CopyWith(skipFields: true)
class GamePrefWordle {
  final WordleVocabulary vocabulary;

  const GamePrefWordle({
    this.vocabulary = WordleVocabulary.all,
  });

  @override
  bool operator ==(Object other) {
    return other is GamePrefWordle && runtimeType == other.runtimeType && vocabulary == other.vocabulary;
  }

  @override
  int get hashCode => Object.hash(vocabulary, 0);

  factory GamePrefWordle.fromJson(Map<String, dynamic> json) => _$GamePrefWordleFromJson(json);

  Map<String, dynamic> toJson() => _$GamePrefWordleToJson(this);
}
