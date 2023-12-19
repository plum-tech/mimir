import 'package:sit/life/electricity/service/electricity.demo.dart';
import 'package:sit/settings/settings.dart';

import 'service/electricity.dart';
import 'storage/electricity.dart';

class ElectricityBalanceInit {
  static late ElectricityStorage storage;
  static late ElectricityService service;

  static void init() {
    service = Settings.demoMode ? const DemoElectricityService() : const ElectricityService();
    storage = const ElectricityStorage();
  }
}
