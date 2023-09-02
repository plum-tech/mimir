import 'package:hive_flutter/hive_flutter.dart';
import 'package:mimir/storage/dao/develop.dart';
import 'package:mimir/storage/storage/develop.dart';
import 'package:mimir/storage/storage/version.dart';

import 'dao/index.dart';
import 'dao/version.dart';
import 'storage/index.dart';

export 'dao/index.dart';
export 'storage/index.dart';

class Kv {
  static late ThemeSettingDao theme;
  static late NetworkSettingDao network;
  static late HomeSettingDao home;
  static late DevelopOptionsDao developOptions;
  static late VersionDao version;

  static late Box<dynamic> kvStorageBox;

  static Future<void> init({
    required Box<dynamic> kvStorageBox,
  }) async {
    Kv.kvStorageBox = kvStorageBox;
    Kv.home = HomeSettingStorage(kvStorageBox);
    Kv.theme = ThemeSettingStorage(kvStorageBox);
    Kv.network = NetworkSettingStorage(kvStorageBox);
    Kv.developOptions = DevelopOptionsStorage(kvStorageBox);
    Kv.version = VersionStorage(kvStorageBox);
  }
}
