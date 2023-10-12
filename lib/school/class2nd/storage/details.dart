import 'package:hive/hive.dart';

import '../entity/details.dart';

class _K {
  static const ns = "/details";

  static String details(int activityId) => "$ns/$activityId";
}

class Class2ndActivityDetailsStorage {
  final Box box;

  const Class2ndActivityDetailsStorage(this.box);

  Class2ndActivityDetails? getActivityDetail(int activityId) => box.get(_K.details(activityId));

  void setActivityDetail(int activityId, Class2ndActivityDetails? details) => box.put(_K.details(activityId), details);
}
