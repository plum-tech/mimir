import 'package:hive/hive.dart';
import 'package:sit/hive/init.dart';

import '../entity/details.dart';

class _K {
  static const ns = "/details";

  static String details(int activityId) => "$ns/$activityId";
}

class Class2ndActivityDetailsStorage {
  Box get box => HiveInit.class2nd;

  const Class2ndActivityDetailsStorage();

  Class2ndActivityDetails? getActivityDetail(int activityId) => box.get(_K.details(activityId));

  void setActivityDetail(int activityId, Class2ndActivityDetails? details) => box.put(_K.details(activityId), details);
}
