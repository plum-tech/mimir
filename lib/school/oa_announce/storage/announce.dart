import 'package:hive/hive.dart';
import 'package:mimir/cache/box.dart';

import '../dao/announce.dart';
import '../entity/announce.dart';
import '../entity/page.dart';

class _Key {
  static const catalogues = "/catalogues";
  static const detailsNs = "/details";
}

class AnnounceStorageBox with CachedBox {
  @override
  final Box box;
  late final catalogues = namedList<OaAnnounceCatalogue>(_Key.catalogues);
  late final details = namespace2<OaAnnounceDetails, String, String>(_Key.detailsNs, makeDetailKey);

  static String makeDetailKey(String catalogueId, String uuid) => "$catalogueId/$uuid";

  AnnounceStorageBox(this.box);
}

class AnnounceStorage extends AnnounceDao {
  final AnnounceStorageBox box;

  AnnounceStorage(Box<dynamic> hive) : box = AnnounceStorageBox(hive);

  /// 获取所有的分类信息
  @override
  Future<List<OaAnnounceCatalogue>?> getAllCatalogues() async {
    return box.catalogues.value;
  }

  /// 获取某篇文章内容
  @override
  Future<OaAnnounceDetails?> getAnnounceDetail(String catalogueId, String uuid) async {
    final details = box.details.make(catalogueId, uuid);
    return details.value;
  }

  void setAnnounceDetail(String catalogueId, String uuid, OaAnnounceDetails? detail) {
    final details = box.details.make(catalogueId, uuid);
    details.value = detail;
  }

  /// 检索文章列表
  @override
  Future<OaAnnounceListPage?> queryAnnounceList(int pageIndex, String catalogueId) async {
    throw UnimplementedError("Storage won't query.");
  }

  void setAllCatalogues(List<OaAnnounceCatalogue>? catalogues) {
    box.catalogues.value = catalogues;
  }
}
