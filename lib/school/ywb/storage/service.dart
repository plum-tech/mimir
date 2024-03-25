import 'package:hive/hive.dart';
import 'package:sit/storage/hive/init.dart';
import 'package:sit/utils/hive.dart';

import '../entity/service.dart';

class _K {
  static const ns = "/meta";
  static const serviceList = "$ns/serviceList";

  static String details(String applicationId) => "$ns/details/$applicationId";
}

class YwbServiceStorage {
  Box get box => HiveInit.ywb;

  const YwbServiceStorage();

  YwbServiceDetails? getServiceDetails(String applicationId) => box.safeGet(_K.details(applicationId));

  void setMetaDetails(String applicationId, YwbServiceDetails? newV) => box.safePut(_K.details(applicationId), newV);

  List<YwbService>? get serviceList => (box.safeGet(_K.serviceList) as List?)?.cast<YwbService>();

  set serviceList(List<YwbService>? newV) => box.safePut(_K.serviceList, newV);
}
