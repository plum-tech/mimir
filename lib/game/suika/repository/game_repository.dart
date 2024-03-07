import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/foundation.dart';
import '../model/physics_fruit.dart';

class GameRepository {
  final List<CollidedFruits> _collidedFruits = [];

  List<CollidedFruits> getCollidedFruits() {
    return _collidedFruits;
  }

  void addCollidedFruits(CollidedFruits collidedFruits) {
    if (collidedFruits.fruit1.userData is! PhysicsFruit ||
        collidedFruits.fruit2.userData is! PhysicsFruit) {
      return;
    }
    final newFruit1 = collidedFruits.fruit1.userData! as PhysicsFruit;
    final newFruit2 = collidedFruits.fruit2.userData! as PhysicsFruit;
    if (_collidedFruits.any((element) {
      final fruit1 = element.fruit1.userData! as PhysicsFruit;
      final fruit2 = element.fruit2.userData! as PhysicsFruit;
      return fruit1.fruit.id == newFruit1.fruit.id ||
          fruit1.fruit.id == newFruit2.fruit.id ||
          fruit2.fruit.id == newFruit1.fruit.id ||
          fruit2.fruit.id == newFruit2.fruit.id;
    })) {
      return;
    }

    _collidedFruits.add(collidedFruits);
  }

  void removeCollidedFruits(CollidedFruits collidedFruits) {
    _collidedFruits.remove(collidedFruits);
  }

  void clearCollidedFruits() {
    _collidedFruits.clear();
  }
}

@immutable
class CollidedFruits {
  const CollidedFruits(this.fruit1, this.fruit2);
  final Body fruit1;
  final Body fruit2;
}
