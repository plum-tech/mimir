import 'application.dart';

class DemoClass2ndApplicationService implements Class2ndApplicationService {
  const DemoClass2ndApplicationService();

  @override
  Future<Class2ndApplicationCheckResponse> check(int activityId) async {
    return Class2ndApplicationCheckResponse.successfulCheck;
  }

  @override
  Future<bool> apply(int activityId) async {
    await Future.delayed(const Duration(milliseconds: 1350));
    return true;
  }

  @override
  Future<bool> withdraw(int applicationId) async {
    await Future.delayed(const Duration(milliseconds: 1400));
    return true;
  }
}
