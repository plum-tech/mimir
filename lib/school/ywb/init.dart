import 'service/meta.dart';
import 'service/application.dart';
import 'storage/meta.dart';
import 'storage/application.dart';

class YwbInit {
  static late YwbApplicationMetaService metaService;
  static late YwbApplicationMetaStorage metaStorage;
  static late YwbApplicationService applicationService;
  static late YwbApplicationStorage applicationStorage;

  static void init() {
    metaService = const YwbApplicationMetaService();
    metaStorage = const YwbApplicationMetaStorage();
    applicationService = const YwbApplicationService();
    applicationStorage = const YwbApplicationStorage();
  }
}
