import 'package:hive/hive.dart';

import 'service/meta.dart';
import 'service/application.dart';
import 'storage/meta.dart';
import 'storage/application.dart';

class YwbInit {
  static late YwbApplicationMetaService metaService;
  static late YwbApplicationMetaStorage metaStorage;
  static late YwbApplicationService applicationService;
  static late YwbApplicationStorage applicationStorage;

  static void init({
    required Box box,
  }) {
    metaService = const YwbApplicationMetaService();
    metaStorage = YwbApplicationMetaStorage(box);
    applicationService = const YwbApplicationService();
    applicationStorage = YwbApplicationStorage(box);
  }
}
