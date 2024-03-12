import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sit/game/storage/storage.dart';
import 'package:version/version.dart';

part "save.g.dart";

List<int> _defaultTiles() {
  return List.generate(16, (index) => -1);
}

@JsonSerializable()
class Save2048 {
  @JsonKey(defaultValue: 0)
  final int score;
  @JsonKey(defaultValue: _defaultTiles)
  final List<int> tiles;

  const Save2048({required this.score, required this.tiles});

  Map<String, dynamic> toJson() => _$Save2048ToJson(this);

  factory Save2048.fromJson(Map<String, dynamic> json) => _$Save2048FromJson(json);

  static final storage = GameStorageBox<Save2048>(
    name: "2048",
    version: Version(1, 0, 0),
    serialize: (save) => save.toJson(),
    deserialize: Save2048.fromJson,
  );
}
