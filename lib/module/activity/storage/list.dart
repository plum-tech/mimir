import '../dao/list.dart';
import '../entity/list.dart';
import '../using.dart';

class ScActivityListStorageBox with CachedBox {
  static const _activitiesNs = "/activities";
  @override
  final Box<dynamic> box;

  ScActivityListStorageBox(this.box);

  late final activities = ListNamespace2<Activity, ActivityType, int>(_activitiesNs, makeActivityKey);

  static String makeActivityKey(ActivityType type, int page) => "$type/$page";
}

class ScActivityListStorage extends ScActivityListDao {
  final ScActivityListStorageBox box;

  ScActivityListStorage(Box<dynamic> hive) : box = ScActivityListStorageBox(hive);

  @override
  Future<List<Activity>?> getActivityList(ActivityType type, int page) async {
    final key = box.activities.make(type, page);
    return key.value;
  }

  void setActivityList(ActivityType type, int page, List<Activity>? activities) {
    final key = box.activities.make(type, page);
    key.value = activities;
  }

  @override
  Future<List<Activity>?> query(String queryString) {
    throw UnimplementedError("Storage won't save query.");
  }
}
