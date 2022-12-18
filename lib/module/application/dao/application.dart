import '../entity/application.dart';

abstract class ApplicationDao {
  Future<List<ApplicationMeta>?> getApplicationMetas();

  Future<ApplicationDetail?> getApplicationDetail(String applicationId);
}
