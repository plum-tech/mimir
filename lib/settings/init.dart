import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:hive/hive.dart';
import 'package:mimir/util/hive_cache_provider.dart';

class SettingsInit {
  static void init({
    required Box<dynamic> kvStorageBox,
  }) {
    Settings.init(cacheProvider: HiveCacheProvider(kvStorageBox));
  }
}
