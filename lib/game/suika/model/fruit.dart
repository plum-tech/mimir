import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'fruit.freezed.dart';

// const _baseFruitRadius = 1.2;
// const _factor = 1.215;
const _baseFruitRadius = 1.0;
const _factor = 1.25;

enum FruitType {
  cherry(_baseFruitRadius, BasicPalette.red, 'cherry.png'),
  strawberry(_baseFruitRadius * _factor, BasicPalette.pink, 'strawberry.png'),
  grape(_baseFruitRadius * _factor * _factor, BasicPalette.purple, 'grape.png'),
  orange(
    _baseFruitRadius * _factor * _factor * _factor,
    BasicPalette.orange,
    'orange.png',
  ),
  kaki(
    _baseFruitRadius * _factor * _factor * _factor * _factor,
    BasicPalette.lightOrange,
    'kaki.png',
  ),
  apple(
    _baseFruitRadius * _factor * _factor * _factor * _factor * _factor,
    BasicPalette.red,
    'apple.png',
  ),
  applePear(
    _baseFruitRadius *
        _factor *
        _factor *
        _factor *
        _factor *
        _factor *
        _factor,
    BasicPalette.lightGreen,
    'apple-pear.png',
  ),
  peach(
    _baseFruitRadius *
        _factor *
        _factor *
        _factor *
        _factor *
        _factor *
        _factor *
        _factor,
    BasicPalette.orange,
    'peach.png',
  ),
  pineapple(
    _baseFruitRadius *
        _factor *
        _factor *
        _factor *
        _factor *
        _factor *
        _factor *
        _factor *
        _factor,
    BasicPalette.yellow,
    'pineapple.png',
  ),
  melon(
    _baseFruitRadius *
        _factor *
        _factor *
        _factor *
        _factor *
        _factor *
        _factor *
        _factor *
        _factor *
        _factor,
    BasicPalette.green,
    'melon.png',
  ),
  watermelon(
    _baseFruitRadius *
        _factor *
        _factor *
        _factor *
        _factor *
        _factor *
        _factor *
        _factor *
        _factor *
        _factor *
        _factor,
    BasicPalette.darkGreen,
    'watermelon.png',
  );

  const FruitType(
    this.radius,
    this.color,
    this.image,
  );

  final double radius;
  final PaletteEntry color;
  final String image;
}

@freezed
class Fruit with _$Fruit {
  factory Fruit({
    required String id,
    required Vector2 pos,
    required double radius,
    required PaletteEntry color,
    required String image,
  }) = _Fruit;
  Fruit._();

  factory Fruit.cherry({
    required String id,
    required Vector2 pos,
  }) {
    return Fruit(
      id: id,
      pos: pos,
      radius: FruitType.cherry.radius,
      color: FruitType.cherry.color,
      image: FruitType.cherry.image,
    );
  }

  factory Fruit.strawberry({
    required String id,
    required Vector2 pos,
  }) {
    return Fruit(
      id: id,
      pos: pos,
      radius: FruitType.strawberry.radius,
      color: FruitType.strawberry.color,
      image: FruitType.strawberry.image,
    );
  }

  factory Fruit.grape({
    required String id,
    required Vector2 pos,
  }) {
    return Fruit(
      id: id,
      pos: pos,
      radius: FruitType.grape.radius,
      color: FruitType.grape.color,
      image: FruitType.grape.image,
    );
  }

  factory Fruit.orange({
    required String id,
    required Vector2 pos,
  }) {
    return Fruit(
      id: id,
      pos: pos,
      radius: FruitType.orange.radius,
      color: FruitType.orange.color,
      image: FruitType.orange.image,
    );
  }

  factory Fruit.kaki({
    required String id,
    required Vector2 pos,
  }) {
    return Fruit(
      id: id,
      pos: pos,
      radius: FruitType.kaki.radius,
      color: FruitType.kaki.color,
      image: FruitType.kaki.image,
    );
  }

  factory Fruit.apple({
    required String id,
    required Vector2 pos,
  }) {
    return Fruit(
      id: id,
      pos: pos,
      radius: FruitType.apple.radius,
      color: FruitType.apple.color,
      image: FruitType.apple.image,
    );
  }

  factory Fruit.applePear({
    required String id,
    required Vector2 pos,
  }) {
    return Fruit(
      id: id,
      pos: pos,
      radius: FruitType.applePear.radius,
      color: FruitType.applePear.color,
      image: FruitType.applePear.image,
    );
  }

  factory Fruit.peach({
    required String id,
    required Vector2 pos,
  }) {
    return Fruit(
      id: id,
      pos: pos,
      radius: FruitType.peach.radius,
      color: FruitType.peach.color,
      image: FruitType.peach.image,
    );
  }

  factory Fruit.pineapple({
    required String id,
    required Vector2 pos,
  }) {
    return Fruit(
      id: id,
      pos: pos,
      radius: FruitType.pineapple.radius,
      color: FruitType.pineapple.color,
      image: FruitType.pineapple.image,
    );
  }

  factory Fruit.melon({
    required String id,
    required Vector2 pos,
  }) {
    return Fruit(
      id: id,
      pos: pos,
      radius: FruitType.melon.radius,
      color: FruitType.melon.color,
      image: FruitType.melon.image,
    );
  }

  factory Fruit.watermelon({
    required String id,
    required Vector2 pos,
  }) {
    return Fruit(
      id: id,
      pos: pos,
      radius: FruitType.watermelon.radius,
      color: FruitType.watermelon.color,
      image: FruitType.watermelon.image,
    );
  }

  static const double friction = 0.4;
  static const double density = 0.5;
  static const double restitution = 0.3;
}
