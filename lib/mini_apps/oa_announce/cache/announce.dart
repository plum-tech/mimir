import 'package:mimir/mini_apps/oa_announce/entity/announce.dart';
import 'package:mimir/mini_apps/oa_announce/entity/page.dart';

import '../dao/announce.dart';
import '../storage/announce.dart';

class AnnounceCache extends AnnounceDao {
  final AnnounceDao from;
  final AnnounceStorage to;
  Duration detailExpire;
  Duration catalogueExpire;

  AnnounceCache({
    required this.from,
    required this.to,
    this.detailExpire = const Duration(minutes: 10),
    this.catalogueExpire = const Duration(minutes: 10),
  });

  final Map<String, AnnounceListPage?> _queried = {};

  @override
  Future<List<AnnounceCatalogue>?> getAllCatalogues() async {
    final cacheKey = to.box.catalogues;
    if (cacheKey.needRefresh(after: detailExpire)) {
      try {
        final res = await from.getAllCatalogues();
        to.setAllCatalogues(res);
        return res;
      } catch (e) {
        return to.getAllCatalogues();
      }
    } else {
      return to.getAllCatalogues();
    }
  }

  @override
  Future<AnnounceDetail?> getAnnounceDetail(String catalogueId, String uuid) async {
    final cacheKey = to.box.details.make(catalogueId, uuid);
    if (cacheKey.needRefresh(after: detailExpire)) {
      try {
        final res = await from.getAnnounceDetail(catalogueId, uuid);
        to.setAnnounceDetail(catalogueId, uuid, res);
        return res;
      } catch (e) {
        return to.getAnnounceDetail(catalogueId, uuid);
      }
    } else {
      return to.getAnnounceDetail(catalogueId, uuid);
    }
  }

  @override
  Future<AnnounceListPage?> queryAnnounceList(int pageIndex, String catalogueId) async {
    final key = "$pageIndex&$catalogueId";
    var res = _queried[key];
    res ??= await from.queryAnnounceList(pageIndex, catalogueId);
    _queried[key] = res;
    return res;
  }
}
