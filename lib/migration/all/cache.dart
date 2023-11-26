import 'package:sit/storage/hive/init.dart';
import 'package:sit/migration/foundation.dart';

// ignore: non_constant_identifier_names
final ClearCacheMigration = _ClearCacheMigrationImpl();

class _ClearCacheMigrationImpl extends Migration {
  @override
  Future<void> perform() async {
    await HiveInit.clearCache();
  }
}
