import 'package:mimir/school/class2nd/service/detail.dart';

import '../entity/details.dart';
import '../storage/detail.dart';

class Class2ndActivityDetailCache {
  final Class2ndActivityDetailService from;
  final Class2ndActivityDetailStorage to;
  Duration expiration;

  Class2ndActivityDetailCache({
    required this.from,
    required this.to,
    this.expiration = const Duration(minutes: 10),
  });

  Future<Class2ndActivityDetails?> getActivityDetail(int activityId) async {
    final cacheKey = to.box.id2Detail.make(activityId);
    if (cacheKey.needRefresh(after: expiration)) {
      try {
        final res = await from.getActivityDetail(activityId);
        to.setActivityDetail(activityId, res);
        return res;
      } catch (e) {
        return to.getActivityDetail(activityId);
      }
    } else {
      return to.getActivityDetail(activityId);
    }
  }
}
