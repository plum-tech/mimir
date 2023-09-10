import '../entity/application.dart';

abstract class ApplicationDao {
  Future<List<ApplicationMeta>?> getApplicationMetas();

  Future<ApplicationDetails?> getApplicationDetail(String applicationId);
}
