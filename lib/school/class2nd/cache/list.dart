import 'package:sit/school/class2nd/service/activity.dart';

import '../entity/list.dart';
import '../storage/list.dart';

class Class2ndActivityListCache {
  final Class2ndActivityListService from;
  final Class2ndActivityListStorage to;
  Duration expiration;

  Class2ndActivityListCache({
    required this.from,
    required this.to,
    this.expiration = const Duration(minutes: 10),
  });

  final Map<String, List<Class2ndActivity>> _queried = {};

  Future<List<Class2ndActivity>?> getActivityList(Class2ndActivityCat type, int page) async {
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

  Future<List<Class2ndActivity>> query(String queryString) async {
    final cached = _queried[queryString];
    if (cached != null) {
      return cached;
    } else {
      final justQueried = await from.query(queryString);
      _queried[queryString] = justQueried;
      return justQueried;
    }
  }
}
