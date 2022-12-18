import 'package:hive/hive.dart';

import 'dao/local.dart';
import 'dao/remote.dart';
import 'service/electricity.dart';
import 'storage/electricity.dart';
import 'using.dart';

class ElectricityBillInit {
  static late ElectricityStorageDao electricityStorage;
  static late ElectricityServiceDao electricityService;
  static late KiteSession kiteSession;
  static Future<void> init({
    required KiteSession kiteSession,
    required Box<dynamic> electricityBox,
  }) async {
    ElectricityBillInit.kiteSession = kiteSession;

    electricityService = ElectricityService(kiteSession);

    electricityStorage = ElectricityStorage(electricityBox);
  }
}
