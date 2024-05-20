import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:sit/game/entity/record.dart';

part "record.g.dart";

@JsonSerializable()
@immutable
class RecordWordle extends GameRecord {
  const RecordWordle({
    required super.ts,
  });

  Map<String, dynamic> toJson() => _$RecordWordleToJson(this);

  factory RecordWordle.fromJson(Map<String, dynamic> json) => _$RecordWordleFromJson(json);
}
