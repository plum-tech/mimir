import '../model/fruit.dart';
import 'package:uuid/uuid.dart';

Fruit? getNextSizeFruit({
  required Fruit fruit1,
  required Fruit fruit2,
}) {
  final id = const Uuid().v4();
  final pos = (fruit1.pos + fruit2.pos) / 2;
  final radius = fruit1.radius;
  if (radius == FruitType.$1.radius) {
    return Fruit.$2(id: id, pos: pos);
  }
  if (radius == FruitType.$2.radius) {
    return Fruit.$3(id: id, pos: pos);
  }
  if (radius == FruitType.$3.radius) {
    return Fruit.$4(id: id, pos: pos);
  }
  if (radius == FruitType.$4.radius) {
    return Fruit.$5(id: id, pos: pos);
  }
  if (radius == FruitType.$5.radius) {
    return Fruit.$6(id: id, pos: pos);
  }
  if (radius == FruitType.$6.radius) {
    return Fruit.$7(id: id, pos: pos);
  }
  if (radius == FruitType.$7.radius) {
    return Fruit.$8(id: id, pos: pos);
  }
  if (radius == FruitType.$8.radius) {
    return Fruit.$9(id: id, pos: pos);
  }
  if (radius == FruitType.$9.radius) {
    return Fruit.$10(id: id, pos: pos);
  }
  if (radius == FruitType.$10.radius) {
    return Fruit.$11(id: id, pos: pos);
  }
  return null;
}
