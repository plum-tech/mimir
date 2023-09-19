import 'package:mimir/school/ywb/service/application.dart';

import '../entity/application.dart';
import '../storage/application.dart';

class ApplicationCache  {
  final ApplicationService from;
  final ApplicationStorage to;
  Duration detailExpire;
  Duration listExpire;

  ApplicationCache({
    required this.from,
    required this.to,
    this.detailExpire = const Duration(minutes: 10),
    this.listExpire = const Duration(minutes: 10),
  });

  Future<List<ApplicationMeta>?> getApplicationMetas() async {
    if (to.box.metas.needRefresh(after: listExpire)) {
      try {
        final res = await from.getApplicationMetas();
        to.applicationMetas = res;
        return res;
      } catch (e) {
        return to.applicationMetas;
      }
    } else {
      return to.applicationMetas;
    }
  }

  Future<ApplicationDetails?> getApplicationDetail(String applicationId) async {
    final cacheKey = to.box.details.make(applicationId);
    if (cacheKey.needRefresh(after: detailExpire)) {
      try {
        final res = await from.getApplicationDetail(applicationId);
        to.setApplicationDetail(applicationId, res);
        return res;
      } catch (e) {
        return to.getApplicationDetail(applicationId);
      }
    } else {
      return to.getApplicationDetail(applicationId);
    }
  }
}
