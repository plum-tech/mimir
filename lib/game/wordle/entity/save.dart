import 'package:json_annotation/json_annotation.dart';

part "save.g.dart";

@JsonSerializable()
class SaveWordle {
  final Duration playtime;

  const SaveWordle({
    required this.playtime,
  });

  Map<String, dynamic> toJson() => _$SaveWordleToJson(this);

  factory SaveWordle.fromJson(Map<String, dynamic> json) => _$SaveWordleFromJson(json);
}
