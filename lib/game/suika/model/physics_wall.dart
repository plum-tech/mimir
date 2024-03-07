import 'package:flame_forge2d/flame_forge2d.dart';
import '../model/wall.dart';

class PhysicsWall extends BodyComponent {
  PhysicsWall({
    required this.wall,
  }) : super(paint: Wall.color.paint());

  final Wall wall;

  @override
  Body createBody() {
    final shape = PolygonShape()
      ..setAsBox(wall.size.x, wall.size.y, wall.pos, 0);
    final fixtureDef = FixtureDef(shape, friction: Wall.friction);
    final bodyDef = BodyDef(userData: this);
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
