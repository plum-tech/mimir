import 'package:hive/hive.dart';
import 'package:mimir/mini_apps/activity/using.dart';

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
  late final catalogues = NamedList<AnnounceCatalogue>(_Key.catalogues);
  late final details = Namespace2<AnnounceDetail, String, String>(_Key.detailsNs, makeDetailKey);

  static String makeDetailKey(String catalogueId, String uuid) => "$catalogueId/$uuid";

  AnnounceStorageBox(this.box);
}

class AnnounceStorage extends AnnounceDao {
  final AnnounceStorageBox box;

  AnnounceStorage(Box<dynamic> hive) : box = AnnounceStorageBox(hive);

  /// 获取所有的分类信息
  @override
  Future<List<AnnounceCatalogue>?> getAllCatalogues() async {
    return box.catalogues.value;
  }

  /// 获取某篇文章内容
  @override
  Future<AnnounceDetail?> getAnnounceDetail(String catalogueId, String uuid) async {
    final details = box.details.make(catalogueId, uuid);
    return details.value;
  }

  void setAnnounceDetail(String catalogueId, String uuid, AnnounceDetail? detail) {
    final details = box.details.make(catalogueId, uuid);
    details.value = detail;
  }

  /// 检索文章列表
  @override
  Future<AnnounceListPage?> queryAnnounceList(int pageIndex, String catalogueId) async {
    throw UnimplementedError("Storage won't query.");
  }

  void setAllCatalogues(List<AnnounceCatalogue>? catalogues) {
    box.catalogues.value = catalogues;
  }
}
