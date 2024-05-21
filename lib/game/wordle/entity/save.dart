import 'package:json_annotation/json_annotation.dart';

part "save.g.dart";

@JsonSerializable()
class SaveWordle {
  final Duration playtime;
  final String word;
  final List<String> attempts;
  const SaveWordle({
    required this.playtime,
    required this.word,
    this.attempts = const [],
  });

  Map<String, dynamic> toJson() => _$SaveWordleToJson(this);

  factory SaveWordle.fromJson(Map<String, dynamic> json) => _$SaveWordleFromJson(json);
}
