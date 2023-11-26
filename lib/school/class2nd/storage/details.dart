import 'package:hive/hive.dart';
import 'package:sit/storage/hive/init.dart';

import '../entity/details.dart';

class _K {
  static const ns = "/details";

  static String details(int activityId) => "$ns/$activityId";
}

class Class2ndActivityDetailsStorage {
  Box get box => HiveInit.class2nd;

  const Class2ndActivityDetailsStorage();

  Class2ndActivityDetails? getActivityDetails(int activityId) => box.get(_K.details(activityId));

  void setActivityDetails(int activityId, Class2ndActivityDetails? details) => box.put(_K.details(activityId), details);
}
