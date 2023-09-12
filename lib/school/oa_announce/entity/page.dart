import 'package:mimir/hive/type_id.dart';

import 'announce.dart';

part 'page.g.dart';

/// 获取到的通知页
@HiveType(typeId: HiveTypeOaAnnounce.listPage)
class OaAnnounceListPage {
  @HiveField(0)
  final int currentPage;
  @HiveField(1)
  final int totalPage;

  @HiveField(2)
  final List<OaAnnounceRecord> bulletinItems;

  const OaAnnounceListPage({
    required this.currentPage,
    required this.totalPage,
    required this.bulletinItems,
  });

  @override
  String toString() {
    return 'OaAnnounceListPage{currentPage: $currentPage, totalPage: $totalPage, bulletinItems: $bulletinItems}';
  }
}
