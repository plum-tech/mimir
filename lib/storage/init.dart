import 'package:hive_flutter/hive_flutter.dart';
import 'package:mimir/storage/dao/admin.dart';
import 'package:mimir/storage/dao/develop.dart';
import 'package:mimir/storage/dao/pref.dart';
import 'package:mimir/storage/storage/admin.dart';
import 'package:mimir/storage/storage/develop.dart';
import 'package:mimir/storage/storage/pref.dart';
import 'package:mimir/storage/storage/report.dart';
import 'package:mimir/storage/storage/version.dart';

import 'dao/index.dart';
import 'dao/report.dart';
import 'dao/version.dart';
import 'storage/index.dart';

export 'dao/index.dart';
export 'storage/index.dart';

class Kv {
  static late ThemeSettingDao theme;
  static late AuthSettingDao auth;
  static late AdminSettingDao admin;
  static late NetworkSettingDao network;
  static late JwtDao jwt;
  static late HomeSettingDao home;
  static late LoginTimeDao loginTime;
  static late DevelopOptionsDao developOptions;
  static late ReportStorageDao report;
  static late PrefDao pref;
  static late VersionDao version;

  static late Box<dynamic> kvStorageBox;

  static Future<void> init({
    required Box<dynamic> kvStorageBox,
  }) async {
    Kv.kvStorageBox = kvStorageBox;
    Kv.auth = AuthSettingStorage(kvStorageBox);
    Kv.admin = AdminSettingStorage(kvStorageBox);
    Kv.home = HomeSettingStorage(kvStorageBox);
    Kv.theme = ThemeSettingStorage(kvStorageBox);
    Kv.network = NetworkSettingStorage(kvStorageBox);
    Kv.jwt = JwtStorage(kvStorageBox);
    Kv.loginTime = LoginTimeStorage(kvStorageBox);
    Kv.developOptions = DevelopOptionsStorage(kvStorageBox);
    Kv.report = ReportStorage(kvStorageBox);
    Kv.pref = PrefStorage(kvStorageBox);
    Kv.version = VersionStorage(kvStorageBox);
  }
}
