import 'package:hive/hive.dart';

import '../dao/detail.dart';
import '../entity/detail.dart';
import '../using.dart';

class ScActivityDetailStorageBox with CachedBox {
  static const id2DetailKey = "/id2Detail";
  @override
  final Box<dynamic> box;
  late final id2Detail = Namespace<ActivityDetail, int>(id2DetailKey, makeId2Detail);

  String makeId2Detail(int activityId) => "$activityId";

  ScActivityDetailStorageBox(this.box);
}

class ScActivityDetailStorage extends ScActivityDetailDao {
  final ScActivityDetailStorageBox box;

  ScActivityDetailStorage(Box<dynamic> hive) : box = ScActivityDetailStorageBox(hive);

  @override
  Future<ActivityDetail?> getActivityDetail(int activityId) async {
    final cacheKey = box.id2Detail.make(activityId);
    return cacheKey.value;
  }

  void setActivityDetail(int activityId, ActivityDetail? detail) {
    final cacheKey = box.id2Detail.make(activityId);
    cacheKey.value = detail;
  }
}
