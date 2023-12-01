import 'service/service.dart';
import 'service/application.dart';
import 'storage/service.dart';
import 'storage/application.dart';

class YwbInit {
  static late YwbServiceService serviceService;
  static late YwbServiceStorage serviceStorage;
  static late YwbApplicationService applicationService;
  static late YwbApplicationStorage applicationStorage;

  static void init() {
    serviceService = const YwbServiceService();
    serviceStorage = const YwbServiceStorage();
    applicationService = const YwbApplicationService();
    applicationStorage = const YwbApplicationStorage();
  }
}
