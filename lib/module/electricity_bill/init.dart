import 'package:hive/hive.dart';

import 'dao/local.dart';
import 'dao/remote.dart';
import 'service/electricity.dart';
import 'storage/electricity.dart';
import 'using.dart';

class ElectricityBillInit {
  static late ElectricityStorageDao electricityStorage;
  static late ElectricityServiceDao electricityService;

  static void init({
    required Box<dynamic> electricityBox,
  }) {
    electricityService = ElectricityService();
    electricityStorage = ElectricityStorage(electricityBox);
  }
}
