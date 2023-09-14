import '../entity/announce.dart';
import '../entity/page.dart';

abstract class AnnounceDao {
  /// 获取所有的分类信息
  Future<List<OaAnnounceCatalogue>?> getAllCatalogues();

  /// 获取某篇文章内容
  Future<OaAnnounceDetails?> getAnnounceDetail(String catalogueId, String uuid);

  /// 检索文章列表
  Future<OaAnnounceListPayload?> queryAnnounceList(int pageIndex, String catalogueId);
}
