import 'package:hive/hive.dart';
import 'package:mimir/cache/box.dart';

import '../entity/application.dart';

class ApplicationStorageBox with CachedBox {
  @override
  final Box<dynamic> box;
  late final details = namespace<ApplicationDetails, String>("/details", makeDetailsKey);
  late final metas = namedList<ApplicationMeta>("/metas");

  String makeDetailsKey(String applicationId) => applicationId;

  ApplicationStorageBox(this.box);
}

class ApplicationStorage {
  final ApplicationStorageBox box;

  ApplicationStorage(Box<dynamic> hive) : box = ApplicationStorageBox(hive);

  List<ApplicationMeta>? get applicationMetas => box.metas.value;

  set applicationMetas(List<ApplicationMeta>? metas) => box.metas.value = metas;

  ApplicationDetails? getApplicationDetails(String applicationId) {
    final cacheKey = box.details.make(applicationId);
    return cacheKey.value;
  }

  void setApplicationDetail(String applicationId, ApplicationDetails? detail) {
    final cacheKey = box.details.make(applicationId);
    cacheKey.value = detail;
  }
}
