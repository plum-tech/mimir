import '../model/fruit.dart';
import 'package:uuid/uuid.dart';

Fruit? getNextSizeFruit({
  required Fruit fruit1,
  required Fruit fruit2,
}) {
  final id = const Uuid().v4();
  final pos = (fruit1.pos + fruit2.pos) / 2;
  final radius = fruit1.radius;
  if (radius == FruitType.cherry.radius) {
    return Fruit.strawberry(id: id, pos: pos);
  }
  if (radius == FruitType.strawberry.radius) {
    return Fruit.grape(id: id, pos: pos);
  }
  if (radius == FruitType.grape.radius) {
    return Fruit.orange(id: id, pos: pos);
  }
  if (radius == FruitType.orange.radius) {
    return Fruit.kaki(id: id, pos: pos);
  }
  if (radius == FruitType.kaki.radius) {
    return Fruit.apple(id: id, pos: pos);
  }
  if (radius == FruitType.apple.radius) {
    return Fruit.applePear(id: id, pos: pos);
  }
  if (radius == FruitType.applePear.radius) {
    return Fruit.peach(id: id, pos: pos);
  }
  if (radius == FruitType.peach.radius) {
    return Fruit.pineapple(id: id, pos: pos);
  }
  if (radius == FruitType.pineapple.radius) {
    return Fruit.melon(id: id, pos: pos);
  }
  if (radius == FruitType.melon.radius) {
    return Fruit.watermelon(id: id, pos: pos);
  }
  return null;
}
