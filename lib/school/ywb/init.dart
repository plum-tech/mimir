import 'package:sit/school/ywb/service/application.demo.dart';
import 'package:sit/settings/settings.dart';

import 'service/service.dart';
import 'service/application.dart';
import 'service/service.demo.dart';
import 'storage/service.dart';
import 'storage/application.dart';

class YwbInit {
  static late YwbServiceService serviceService;
  static late YwbServiceStorage serviceStorage;
  static late YwbApplicationService applicationService;
  static late YwbApplicationStorage applicationStorage;

  static void init() {
    serviceService = Settings.demoMode ? const DemoYwbServiceService() : const YwbServiceService();
    serviceStorage = const YwbServiceStorage();
    applicationService = Settings.demoMode ? const DemoYwbApplicationService() : const YwbApplicationService();
    applicationStorage = const YwbApplicationStorage();
  }
}
