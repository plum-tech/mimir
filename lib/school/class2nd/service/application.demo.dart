import 'application.dart';

class DemoClass2ndApplicationService implements Class2ndApplicationService {
  const DemoClass2ndApplicationService();

  @override
  Future<Class2ndApplicationCheckResponse> check(int activityId) async {
    return Class2ndApplicationCheckResponse.successfulCheck;
  }

  @override
  Future<bool> apply(int activityId) async {
    return true;
  }

  @override
  Future<bool> withdraw(int applicationId) async {
    return true;
  }
}
