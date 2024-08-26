import 'package:mimir/school/ywb/service/application.demo.dart';
import 'package:mimir/settings/dev.dart';

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
    serviceService = Dev.demoMode ? const DemoYwbServiceService() : const YwbServiceService();
    applicationService = Dev.demoMode ? const DemoYwbApplicationService() : const YwbApplicationService();
  }

  static void initStorage() {
    applicationStorage = YwbApplicationStorage();
    serviceStorage = const YwbServiceStorage();
  }
}
