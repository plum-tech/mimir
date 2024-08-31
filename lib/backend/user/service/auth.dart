import 'package:dio/dio.dart';
import 'package:mimir/backend/user/entity/verify.dart';
import 'package:mimir/init.dart';

import '../entity/user.dart';

// const _base = "https://api.mysit.life/v1";
// const _base = "https://beta-api.mysit.life/v1";
const _base = "http://192.168.1.5:8000/v1";

class MimirAuthService {
  Dio get _dio => Init.mimirDio;

  const MimirAuthService();

  Future<MimirAuthMethods> fetchAuthMethods({
    required SchoolCode school,
  }) async {
    final res = await _dio.get("$_base/auth/method", queryParameters: {
      "schoolCode": school.code,
    });
    return MimirAuthMethods.fromJson(res.data);
  }

  Future<bool> checkExistingBySchoolId({
    required SchoolCode school,
    required String schoolId,
  }) async {
    final res = await _dio.post("$_base/auth/check-existing/school-id", queryParameters: {
      "schoolCode": school.code,
    }, data: {
      "schoolId": schoolId,
    });
    final result = res.data as Map;
    return result["existing"] == true;
  }

  Future<void> signInBySchoolId({
    required SchoolCode school,
    required String schoolId,
    required String password,
  }) async {
    final res = await _dio.post("$_base/auth/sign-in/school-id", queryParameters: {
      "schoolCode": school.code,
    }, data: {
      "schoolId": schoolId,
      "password": password,
    });
    final result = res.data as Map<String, dynamic>;
    final token = result["token"] as String;
  }

  Future<void> signUpBySchoolId({
    required SchoolCode school,
    required String schoolId,
    required String password,
  }) async {
    final res = await _dio.post("$_base/auth/sign-up/school-id", queryParameters: {
      "schoolCode": school.code,
    }, data: {
      "schoolId": schoolId,
      "password": password,
    });
    final result = res.data as Map<String, dynamic>;
    final token = result["token"] as String;
  }
}
