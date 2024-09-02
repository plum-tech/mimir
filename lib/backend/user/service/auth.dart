import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mimir/backend/user/entity/verify.dart';
import 'package:mimir/init.dart';
import 'package:mimir/settings/dev.dart';

import '../../entity/user.dart';

String get _base => Dev.betaBackendAPI
    ? "https://beta-api.mysit.life/v1"
    : kDebugMode
        ? "http://192.168.3.17:8000/v1"
        : "https://api.mysit.life/v1";

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
    return;
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
    return;
  }

  Future<bool> verify() async {
    try {
      final res = await _dio.get("$_base/auth/verify");
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
