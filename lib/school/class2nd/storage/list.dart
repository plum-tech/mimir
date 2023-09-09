import 'package:hive/hive.dart';
import 'package:mimir/cache/box.dart';

import '../entity/list.dart';

class ScActivityListStorageBox with CachedBox {
  static const _activitiesNs = "/activities";
  @override
  final Box<dynamic> box;

  ScActivityListStorageBox(this.box);

  late final activities = ListNamespace2<Class2ndActivity, Class2ndActivityType, int>(_activitiesNs, makeActivityKey);

  static String makeActivityKey(Class2ndActivityType type, int page) => "$type/$page";
}

class Class2ndActivityListStorage {
  final ScActivityListStorageBox box;

  Class2ndActivityListStorage(Box<dynamic> hive) : box = ScActivityListStorageBox(hive);

  Future<List<Class2ndActivity>?> getActivityList(Class2ndActivityType type, int page) async {
    final key = box.activities.make(type, page);
    return key.value;
  }

  void setActivityList(Class2ndActivityType type, int page, List<Class2ndActivity>? activities) {
    final key = box.activities.make(type, page);
    key.value = activities;
  }
}
