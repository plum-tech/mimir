import 'package:json_annotation/json_annotation.dart';
import 'package:mimir/entity/uuid.dart';
import 'package:uuid/uuid.dart';

String genUuidV4() => const Uuid().v4();

class GameRecord implements WithUuid {
  @JsonKey(defaultValue: genUuidV4)
  @override
  final String uuid;
  @JsonKey()
  final DateTime ts;

  const GameRecord({
    required this.uuid,
    required this.ts,
  });
}
