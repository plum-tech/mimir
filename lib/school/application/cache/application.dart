import '../dao/application.dart';
import '../entity/application.dart';
import '../storage/application.dart';

class ApplicationCache extends ApplicationDao {
  final ApplicationDao from;
  final ApplicationStorage to;
  Duration detailExpire;
  Duration listExpire;

  ApplicationCache({
    required this.from,
    required this.to,
    this.detailExpire = const Duration(minutes: 10),
    this.listExpire = const Duration(minutes: 10),
  });

  @override
  Future<List<ApplicationMeta>?> getApplicationMetas() async {
    if (to.box.metas.needRefresh(after: listExpire)) {
      try {
        final res = await from.getApplicationMetas();
        to.setApplicationMetas(res);
        return res;
      } catch (e) {
        return to.getApplicationMetas();
      }
    } else {
      return to.getApplicationMetas();
    }
  }

  @override
  Future<ApplicationDetail?> getApplicationDetail(String applicationId) async {
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
