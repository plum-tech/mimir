import 'package:hive/hive.dart';
import 'package:mimir/storage/dao/admin.dart';

class AdminKeys {
  static const namespace = '/admin';
  static const bbsSecret = '$namespace/bbsSecret';
}

class AdminSettingStorage implements AdminSettingDao {
  final Box<dynamic> box;

  AdminSettingStorage(this.box);

  @override
  String? get bbsSecret => box.get(AdminKeys.bbsSecret);

  @override
  set bbsSecret(String? newSecret) => box.put(AdminKeys.bbsSecret, newSecret);
}
