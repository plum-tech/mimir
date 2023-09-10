import 'package:hive/hive.dart';
import 'package:mimir/cache/box.dart';

import '../entity/detail.dart';

class Class2ndActivityDetailStorageBox with CachedBox {
  static const id2DetailKey = "/id2Detail";
  @override
  final Box<dynamic> box;
  late final id2Detail = Namespace<Class2ndActivityDetail, int>(id2DetailKey, makeId2Detail);

  String makeId2Detail(int activityId) => "$activityId";

  Class2ndActivityDetailStorageBox(this.box);
}

class Class2ndActivityDetailStorage {
  final Class2ndActivityDetailStorageBox box;

  Class2ndActivityDetailStorage(Box<dynamic> hive) : box = Class2ndActivityDetailStorageBox(hive);

  Future<Class2ndActivityDetail?> getActivityDetail(int activityId) async {
    final cacheKey = box.id2Detail.make(activityId);
    return cacheKey.value;
  }

  void setActivityDetail(int activityId, Class2ndActivityDetail? detail) {
    final cacheKey = box.id2Detail.make(activityId);
    cacheKey.value = detail;
  }
}
