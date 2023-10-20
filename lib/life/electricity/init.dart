import 'package:hive/hive.dart';

import 'service/electricity.dart';
import 'storage/electricity.dart';

class ElectricityBalanceInit {
  static late ElectricityStorage storage;
  static late ElectricityService service;

  static void init({
    required Box electricityBox,
  }) {
    service = const ElectricityService();
    storage = ElectricityStorage(electricityBox);
  }
}
