import 'package:hive/hive.dart';

import '../entity/meta.dart';

class _K {
  static const ns = "/meta";
  static const metaList = "$ns/metaList";

  static String details(String applicationId) => "$ns/details/$applicationId";
}

class YwbApplicationMetaStorage {
  final Box<dynamic> box;

  const YwbApplicationMetaStorage(this.box);

  YwbApplicationMetaDetails? getMetaDetails(String applicationId) => box.get(_K.details(applicationId));

  void setMetaDetails(String applicationId, YwbApplicationMetaDetails? newV) =>
      box.put(_K.details(applicationId), newV);

  List<YwbApplicationMeta>? get metaList => box.get(_K.metaList);

  set metaList(List<YwbApplicationMeta>? newV) => box.put(_K.metaList, newV);
}
