import 'package:hive/hive.dart';
import 'package:mimir/cache/box.dart';

import '../entity/list.dart';

class ScActivityListStorageBox with CachedBox {
  static const _activitiesNs = "/activities";
  @override
  final Box<dynamic> box;

  ScActivityListStorageBox(this.box);

  late final activities = ListNamespace2<Activity, ActivityType, int>(_activitiesNs, makeActivityKey);

  static String makeActivityKey(ActivityType type, int page) => "$type/$page";
}

class ScActivityListStorage  {
  final ScActivityListStorageBox box;

  ScActivityListStorage(Box<dynamic> hive) : box = ScActivityListStorageBox(hive);

  Future<List<Activity>?> getActivityList(ActivityType type, int page) async {
    final key = box.activities.make(type, page);
    return key.value;
  }

  void setActivityList(ActivityType type, int page, List<Activity>? activities) {
    final key = box.activities.make(type, page);
    key.value = activities;
  }

  Future<List<Activity>?> query(String queryString) {
    throw UnimplementedError("Storage won't save query.");
  }
}
