import '../using.dart';
import 'announce.dart';

part 'page.g.dart';

/// 获取到的通知页
@HiveType(typeId: HiveTypeId.announceListPage)
class AnnounceListPage {
  @HiveField(0)
  int currentPage = 1;
  @HiveField(1)
  int totalPage = 10;
  @HiveField(2)
  List<AnnounceRecord> bulletinItems = [];

  @override
  String toString() {
    return 'BulletinListPage{currentPage: $currentPage, totalPage: $totalPage, bulletinItems: $bulletinItems}';
  }
}
