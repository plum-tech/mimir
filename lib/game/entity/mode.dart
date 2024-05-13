import 'package:meta/meta.dart';

abstract class GameMode {
  final String name;

  @protected
  const GameMode({
    required this.name,
  });

  String toJson() => name;

  @override
  bool operator ==(Object other) {
    return other is GameMode && runtimeType == other.runtimeType && name == other.name;
  }

  @override
  int get hashCode => name.hashCode;

  String l10n();
}
