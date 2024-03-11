import '../model/fruit.dart';

int getScore(Fruit? fruit) {
  if (fruit == null) {
    return 66;
  }
  if (fruit.radius == FruitType.$1.radius) {
    return 0;
  }
  if (fruit.radius == FruitType.$2.radius) {
    return 1;
  }
  if (fruit.radius == FruitType.$3.radius) {
    return 3;
  }
  if (fruit.radius == FruitType.$4.radius) {
    return 6;
  }
  if (fruit.radius == FruitType.$5.radius) {
    return 10;
  }
  if (fruit.radius == FruitType.$6.radius) {
    return 15;
  }
  if (fruit.radius == FruitType.$7.radius) {
    return 21;
  }
  if (fruit.radius == FruitType.$8.radius) {
    return 28;
  }
  if (fruit.radius == FruitType.$9.radius) {
    return 36;
  }
  if (fruit.radius == FruitType.$10.radius) {
    return 45;
  }
  if (fruit.radius == FruitType.$11.radius) {
    return 55;
  }
  return 66;
}
