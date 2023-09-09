import '../dao/detail.dart';
import '../entity/detail.dart';
import '../storage/detail.dart';

class ScActivityDetailCache extends ScActivityDetailDao {
  final ScActivityDetailDao from;
  final ScActivityDetailStorage to;
  Duration expiration;

  ScActivityDetailCache({
    required this.from,
    required this.to,
    this.expiration = const Duration(minutes: 10),
  });

  @override
  Future<ActivityDetail?> getActivityDetail(int activityId) async {
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
