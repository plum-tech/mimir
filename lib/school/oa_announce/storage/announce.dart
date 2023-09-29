import 'package:hive/hive.dart';

import '../entity/announce.dart';

class _K {
  static const catalogues = "/catalogues";

  static String details(String catalogueId, String uuid) => "/details/$catalogueId/$uuid";
}

class AnnounceStorage {
  final Box<dynamic> box;

  const AnnounceStorage(this.box);

  /// 获取所有的分类信息
  List<OaAnnounceCatalogue>? get allCatalogues => (box.get(_K.catalogues) as List?)?.cast<OaAnnounceCatalogue>();

  set allCatalogues(List<OaAnnounceCatalogue>? newV) => box.put(_K.catalogues, newV);

  /// 获取某篇文章内容
  OaAnnounceDetails? getAnnounceDetail(String catalogueId, String uuid) => box.get(_K.details(catalogueId, uuid));

  void setAnnounceDetails(String catalogueId, String uuid, OaAnnounceDetails? newV) =>
      box.put(_K.details(catalogueId, uuid), newV);
}
