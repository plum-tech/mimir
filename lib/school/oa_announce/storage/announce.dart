import 'package:hive/hive.dart';

import '../entity/announce.dart';

class _K {
  static const catalogues = "/catalogues";
  static const recordList = "/recordList";

  static String details(String catalogueId, String uuid) => "/details/$catalogueId/$uuid";
}

class OaAnnounceStorage {
  final Box box;

  const OaAnnounceStorage(this.box);

  /// 获取所有的分类信息
  List<OaAnnounceCatalogue>? get allCatalogues => (box.get(_K.catalogues) as List?)?.cast<OaAnnounceCatalogue>();

  set allCatalogues(List<OaAnnounceCatalogue>? newV) => box.put(_K.catalogues, newV);

  List<OaAnnounceRecord>? get recordList => (box.get(_K.recordList) as List?)?.cast<OaAnnounceRecord>();

  set recordList(List<OaAnnounceRecord>? newV) => box.put(_K.recordList, newV);

  /// 获取某篇文章内容
  OaAnnounceDetails? getAnnounceDetails(String catalogueId, String uuid) => box.get(_K.details(catalogueId, uuid));

  void setAnnounceDetails(String catalogueId, String uuid, OaAnnounceDetails? newV) =>
      box.put(_K.details(catalogueId, uuid), newV);
}
