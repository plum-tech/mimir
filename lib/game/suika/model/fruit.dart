import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'fruit.freezed.dart';

// const _baseFruitRadius = 1.2;
// const _factor = 1.215;
const _baseFruitRadius = 1.5;
const _factor = 1.15;

enum FruitType {
  $1(_baseFruitRadius, BasicPalette.red, 'fruit-1.png'),
  $2(_baseFruitRadius * _factor, BasicPalette.pink, 'fruit-2.png'),
  $3(_baseFruitRadius * _factor * _factor, BasicPalette.purple, 'fruit-3.png'),
  $4(
    _baseFruitRadius * _factor * _factor * _factor,
    BasicPalette.orange,
    'fruit-4.png',
  ),
  $5(
    _baseFruitRadius * _factor * _factor * _factor * _factor,
    BasicPalette.lightOrange,
    'fruit-5.png',
  ),
  $6(
    _baseFruitRadius * _factor * _factor * _factor * _factor * _factor,
    BasicPalette.red,
    'fruit-6.png',
  ),
  $7(
    _baseFruitRadius * _factor * _factor * _factor * _factor * _factor * _factor,
    BasicPalette.lightGreen,
    'fruit-7.png',
  ),
  $8(
    _baseFruitRadius * _factor * _factor * _factor * _factor * _factor * _factor * _factor,
    BasicPalette.orange,
    'fruit-8.png',
  ),
  $9(
    _baseFruitRadius * _factor * _factor * _factor * _factor * _factor * _factor * _factor * _factor,
    BasicPalette.yellow,
    'fruit-9.png',
  ),
  $10(
    _baseFruitRadius * _factor * _factor * _factor * _factor * _factor * _factor * _factor * _factor * _factor,
    BasicPalette.green,
    'fruit-10.png',
  ),
  $11(
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
    'fruit-11.png',
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
  static const double friction = 0.5;
  static const double density = 5;
  static const double restitution = 0.1;

  factory Fruit({
    required String id,
    required Vector2 pos,
    required double radius,
    required PaletteEntry color,
    required String image,
  }) = _Fruit;
  Fruit._();

  factory Fruit.$1({
    required String id,
    required Vector2 pos,
  }) {
    return Fruit(
      id: id,
      pos: pos,
      radius: FruitType.$1.radius,
      color: FruitType.$1.color,
      image: FruitType.$1.image,
    );
  }

  factory Fruit.$2({
    required String id,
    required Vector2 pos,
  }) {
    return Fruit(
      id: id,
      pos: pos,
      radius: FruitType.$2.radius,
      color: FruitType.$2.color,
      image: FruitType.$2.image,
    );
  }

  factory Fruit.$3({
    required String id,
    required Vector2 pos,
  }) {
    return Fruit(
      id: id,
      pos: pos,
      radius: FruitType.$3.radius,
      color: FruitType.$3.color,
      image: FruitType.$3.image,
    );
  }

  factory Fruit.$4({
    required String id,
    required Vector2 pos,
  }) {
    return Fruit(
      id: id,
      pos: pos,
      radius: FruitType.$4.radius,
      color: FruitType.$4.color,
      image: FruitType.$4.image,
    );
  }

  factory Fruit.$5({
    required String id,
    required Vector2 pos,
  }) {
    return Fruit(
      id: id,
      pos: pos,
      radius: FruitType.$5.radius,
      color: FruitType.$5.color,
      image: FruitType.$5.image,
    );
  }

  factory Fruit.$6({
    required String id,
    required Vector2 pos,
  }) {
    return Fruit(
      id: id,
      pos: pos,
      radius: FruitType.$6.radius,
      color: FruitType.$6.color,
      image: FruitType.$6.image,
    );
  }

  factory Fruit.$7({
    required String id,
    required Vector2 pos,
  }) {
    return Fruit(
      id: id,
      pos: pos,
      radius: FruitType.$7.radius,
      color: FruitType.$7.color,
      image: FruitType.$7.image,
    );
  }

  factory Fruit.$8({
    required String id,
    required Vector2 pos,
  }) {
    return Fruit(
      id: id,
      pos: pos,
      radius: FruitType.$8.radius,
      color: FruitType.$8.color,
      image: FruitType.$8.image,
    );
  }

  factory Fruit.$9({
    required String id,
    required Vector2 pos,
  }) {
    return Fruit(
      id: id,
      pos: pos,
      radius: FruitType.$9.radius,
      color: FruitType.$9.color,
      image: FruitType.$9.image,
    );
  }

  factory Fruit.$10({
    required String id,
    required Vector2 pos,
  }) {
    return Fruit(
      id: id,
      pos: pos,
      radius: FruitType.$10.radius,
      color: FruitType.$10.color,
      image: FruitType.$10.image,
    );
  }

  factory Fruit.$11({
    required String id,
    required Vector2 pos,
  }) {
    return Fruit(
      id: id,
      pos: pos,
      radius: FruitType.$11.radius,
      color: FruitType.$11.color,
      image: FruitType.$11.image,
    );
  }
}
