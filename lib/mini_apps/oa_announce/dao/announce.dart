import '../entity/announce.dart';
import '../entity/page.dart';

abstract class AnnounceDao {
  /// 获取所有的分类信息
  Future<List<AnnounceCatalogue>?> getAllCatalogues();

  /// 获取某篇文章内容
  Future<AnnounceDetail?> getAnnounceDetail(String catalogueId, String uuid);

  /// 检索文章列表
  Future<AnnounceListPage?> queryAnnounceList(int pageIndex, String catalogueId);
}
