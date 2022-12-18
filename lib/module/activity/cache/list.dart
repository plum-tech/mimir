import '../dao/list.dart';
import '../entity/list.dart';
import '../storage/list.dart';

class ScActivityListCache extends ScActivityListDao {
  final ScActivityListDao from;
  final ScActivityListStorage to;
  Duration expiration;

  ScActivityListCache({
    required this.from,
    required this.to,
    this.expiration = const Duration(minutes: 10),
  });

  final Map<String, List<Activity>> _queried = {};

  @override
  Future<List<Activity>?> getActivityList(ActivityType type, int page) async {
    final cacheKey = to.box.activities.make(type, page);
    if (cacheKey.needRefresh(after: expiration)) {
      try {
        final res = await from.getActivityList(type, page);
        to.setActivityList(type, page, res);
        return res;
      } catch (e) {
        return to.getActivityList(type, page);
      }
    } else {
      return to.getActivityList(type, page);
    }
  }

  @override
  Future<List<Activity>?> query(String queryString) async {
    var res = _queried[queryString];
    res ??= await from.query(queryString);
    if (res != null) {
      _queried[queryString] = res;
    }
    return res;
  }
}
