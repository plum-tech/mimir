import 'package:hive/hive.dart';
import 'package:sit/cache/box.dart';

import '../entity/list.dart';

class Class2ndActivityListStorageBox with CachedBox {
  static const _activitiesNs = "/activities";
  @override
  final Box box;

  Class2ndActivityListStorageBox(this.box);

  late final activities = listNamespace2<Class2ndActivity, Class2ndActivityCat, int>(_activitiesNs, makeActivityKey);

  static String makeActivityKey(Class2ndActivityCat type, int page) => "$type/$page";
}
class _K{
  static const ns = "/activities";
}
class Class2ndActivityListStorage {
  final Class2ndActivityListStorageBox box;

  Class2ndActivityListStorage(Box hive) : box = Class2ndActivityListStorageBox(hive);

  Future<List<Class2ndActivity>?> getActivityList(Class2ndActivityCat type, int page) async {
    final key = box.activities.make(type, page);
    return key.value;
  }

  void setActivityList(Class2ndActivityCat type, int page, List<Class2ndActivity>? activities) {
    final key = box.activities.make(type, page);
    key.value = activities;
  }
}
