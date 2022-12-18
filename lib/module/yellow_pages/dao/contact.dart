import '../entity/contact.dart';

/// 远程的常用电话数据访问层的接口
abstract class ContactRemoteDao {
  /// 拉取常用电话列表
  Future<List<ContactData>> getAllContacts();
}

/// 本地的常用电话数据访问接口
abstract class ContactStorageDao {
  /// 添加常用电话记录
  void add(ContactData data);

  /// 批量添加电话记录
  void addAll(List<ContactData> data);

  /// 获取所有常用电话记录
  List<ContactData> getAllContacts();

  /// 清除本地存储的常用电话记录
  void clear();
}
