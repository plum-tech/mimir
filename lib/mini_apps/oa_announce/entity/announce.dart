import 'package:mimir/hive/type_id.dart';
import 'attachment.dart';

part 'announce.g.dart';

@HiveType(typeId: HiveTypeId.announceDetail)
class AnnounceDetail {
  /// 标题
  @HiveField(0)
  String title = '';

  /// 发布时间
  @HiveField(1)
  DateTime dateTime = DateTime.now();

  /// 发布部门
  @HiveField(2)
  String department = '';

  /// 发布者
  @HiveField(3)
  String author = '';

  /// 阅读人数
  @HiveField(4)
  int readNumber = 0;

  /// 内容(html格式)
  @HiveField(5)
  String content = '';

  /// 附件
  @HiveField(6)
  List<AnnounceAttachment> attachments = [];

  @override
  String toString() {
    return 'BulletinDetail{title: $title, dateTime: $dateTime, department: $department, author: $author, readNumber: $readNumber, content: $content, attachments: $attachments}';
  }
}

/// 通知分类
@HiveType(typeId: HiveTypeId.announceCatalogue)
class AnnounceCatalogue {
  /// 分类名
  @HiveField(0)
  final String name;

  /// 分类代号(OA上命名为pen，以pe打头)
  @HiveField(1)
  final String id;

  const AnnounceCatalogue(this.name, this.id);
}

/// 某篇通知的记录信息，根据该信息可寻找到对应文章
@HiveType(typeId: HiveTypeId.announceRecord)
class AnnounceRecord {
  /// 标题
  @HiveField(0)
  String title = '';

  /// 文章id
  @HiveField(1)
  String uuid = '';

  /// 目录id
  @HiveField(2)
  String bulletinCatalogueId = '';

  /// 发布时间
  @HiveField(3)
  DateTime dateTime = DateTime.now();

  /// 发布部门
  @HiveField(4)
  String department = '';

  @override
  String toString() {
    return 'BulletinRecord{title: $title, uuid: $uuid, bulletinCatalogueId: $bulletinCatalogueId, dateTime: $dateTime, department: $department}';
  }
}
