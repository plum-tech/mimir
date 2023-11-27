import 'package:sit/storage/hive/type_id.dart';

part 'announce.g.dart';

/// 通知分类
enum OaAnnounceCatalogue {
  studentAffairs(name: '学生事务', id: 'pe2362'),
  learning(name: '学习课堂', id: 'pe2364'),
  collegeNotification(name: '二级学院通知', id: 'pe2368'),
  culture(name: '校园文化', id: 'pe2366'),
  announcement(name: '公告信息', id: 'pe2367'),
  life(name: '生活服务', id: 'pe2365'),
  download(name: '文件下载专区', id: 'pe2382');

  /// 分类名
  final String name;

  /// 分类代号(OA上命名为pen，以pe打头)
  final String id;

  const OaAnnounceCatalogue({
    required this.name,
    required this.id,
  });
}

/// 某篇通知的记录信息，根据该信息可寻找到对应文章
@HiveType(typeId: CacheHiveType.oaAnnounceRecord)
class OaAnnounceRecord {
  /// 标题
  @HiveField(0)
  final String title;

  /// 文章id
  @HiveField(1)
  final String uuid;

  /// 目录id
  @HiveField(2)
  final String catalogId;

  /// 发布时间
  @HiveField(3)
  final DateTime dateTime;

  /// 发布部门
  @HiveField(4)
  final List<String> departments;

  const OaAnnounceRecord({
    required this.title,
    required this.uuid,
    required this.catalogId,
    required this.dateTime,
    required this.departments,
  });

  @override
  String toString() {
    return {
      "title": title,
      "uuid": uuid,
      "bulletinCatalogueId": catalogId,
      "dateTime": dateTime,
      "departments": departments,
    }.toString();
  }
}

@HiveType(typeId: CacheHiveType.oaAnnounceDetails)
class OaAnnounceDetails {
  /// 标题
  @HiveField(0)
  final String title;

  /// 发布时间
  @HiveField(1)
  final DateTime dateTime;

  /// 发布部门
  @HiveField(2)
  final String department;

  /// 发布者
  @HiveField(3)
  final String author;

  /// 阅读人数
  @HiveField(4)
  final int readNumber;

  /// 内容(html格式)
  @HiveField(5)
  final String content;

  /// 附件
  @HiveField(6)
  final List<OaAnnounceAttachment> attachments;

  const OaAnnounceDetails({
    required this.title,
    required this.dateTime,
    required this.department,
    required this.author,
    required this.readNumber,
    required this.content,
    required this.attachments,
  });

  @override
  String toString() {
    return {
      "title": title,
      "dateTime": dateTime,
      "department": department,
      "author": author,
      "readNumber": readNumber,
      "content": content,
      "attachments": attachments,
    }.toString();
  }
}

@HiveType(typeId: CacheHiveType.oaAnnounceAttachment)
class OaAnnounceAttachment {
  /// 附件标题
  @HiveField(0)
  final String name;

  /// 附件下载网址
  @HiveField(1)
  final String url;

  const OaAnnounceAttachment({
    required this.name,
    required this.url,
  });

  @override
  String toString() {
    return {
      "name": name,
      "url": url,
    }.toString();
  }
}
