import 'package:mimir/cache/box.dart';

import '../dao/application.dart';
import '../entity/application.dart';
import '../using.dart';

class ApplicationStorageBox with CachedBox {
  @override
  final Box<dynamic> box;
  late final details = Namespace<ApplicationDetail, String>("/details", makeDetailsKey);
  late final metas = NamedList<ApplicationMeta>("/metas");

  String makeDetailsKey(String applicationId) => applicationId;

  ApplicationStorageBox(this.box);
}

class ApplicationStorage extends ApplicationDao {
  final ApplicationStorageBox box;

  ApplicationStorage(Box<dynamic> hive) : box = ApplicationStorageBox(hive);

  @override
  Future<List<ApplicationMeta>?> getApplicationMetas() async {
    return box.metas.value;
  }

  void setApplicationMetas(List<ApplicationMeta>? metas) {
    box.metas.value = metas;
  }

  @override
  Future<ApplicationDetail?> getApplicationDetail(String applicationId) async {
    final cacheKey = box.details.make(applicationId);
    return cacheKey.value;
  }

  void setApplicationDetail(String applicationId, ApplicationDetail? detail) {
    final cacheKey = box.details.make(applicationId);
    cacheKey.value = detail;
  }
}
