import '../model/fruit.dart';

int getScore(Fruit? fruit) {
  if (fruit == null) {
    return 66;
  }
  if (fruit.radius == FruitType.cherry.radius) {
    return 0;
  }
  if (fruit.radius == FruitType.strawberry.radius) {
    return 1;
  }
  if (fruit.radius == FruitType.grape.radius) {
    return 3;
  }
  if (fruit.radius == FruitType.orange.radius) {
    return 6;
  }
  if (fruit.radius == FruitType.kaki.radius) {
    return 10;
  }
  if (fruit.radius == FruitType.apple.radius) {
    return 15;
  }
  if (fruit.radius == FruitType.applePear.radius) {
    return 21;
  }
  if (fruit.radius == FruitType.peach.radius) {
    return 28;
  }
  if (fruit.radius == FruitType.pineapple.radius) {
    return 36;
  }
  if (fruit.radius == FruitType.melon.radius) {
    return 45;
  }
  if (fruit.radius == FruitType.watermelon.radius) {
    return 55;
  }
  return 66;
}
