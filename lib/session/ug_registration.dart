import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mimir/init.dart';
import 'package:mimir/r.dart';
import 'package:mimir/session/sso.dart';

/// jwxt.sit.edu.cn
/// Student registration system for undergraduate
class UgRegistrationSession {
  final SsoSession _ssoSession;

  const UgRegistrationSession({
    required SsoSession ssoSession,
  }) : _ssoSession = ssoSession;

  // Future<Response> importTimetable(String url, SemesterInfo info) async {
  //   await Init.schoolCookieJar.deleteAll();
  //   final loginRes = await _ssoSession.loginLocked(CredentialsInit.storage.oa.credentials!);
  //   final response = await Init.schoolDio.request(
  //     "http://jwxt.sit.edu.cn/sso/jziotlogin",
  //     options: Options(
  //       followRedirects: false,
  //       validateStatus: (status) {
  //         return status! < 400;
  //       },
  //     ),
  //   );
  //   final debugDepths = <Response>[];
  //   final finalResponse = await Init.schoolDio.processRedirect(
  //     response,
  //     debugDepths: debugDepths,
  //   );
  //   print(debugDepths);
  //   final timetableRes = await Init.schoolDio.get(
  //     url,
  //     options: Options(
  //       method: "POST",
  //     ),
  //     queryParameters: {'gnmkdm': 'N253508'},
  //     data: FormData.fromMap({
  //       // 学年名
  //       'xnm': info.exactYear.toString(),
  //       // 学期名
  //       'xqm': info.semester.toUgRegFormField()
  //     }),
  //   );
  //   return timetableRes;
  // }

  bool _isLoginRequired(Response response) {
    final realPath = response.realUri.path;
    return realPath.endsWith('jwglxt/xtgl/login_slogin.html');
  }

  Future<Response> request(
    String url, {
    Map<String, String>? queryParameters,
    FormData Function()? data,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    Future<Response> fetch() async {
      return await _ssoSession.request(
        url,
        queryParameters: queryParameters,
        data: data,
        options: (options ?? Options()).copyWith(
          followRedirects: false,
          validateStatus: (status) => status! < 400,
        ),
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    }

    var response = await fetch();
    if (_isLoginRequired(response)) {
      debugPrint('JwxtSession requires login');
      await Init.schoolCookieJar.delete(R.ugRegUri, true);
      await _ssoSession.request('http://jwxt.sit.edu.cn/sso/jziotlogin');
      // re-fetch the same
      response = await fetch();
    }
    return response;
  }

  Future<bool> checkConnectivity({
    String url = 'http://jwxt.sit.edu.cn/',
  }) async {
    try {
      await Init.dioNoCookie.request(
        url,
        options: Options(
          method: "GET",
          sendTimeout: const Duration(milliseconds: 6000),
          receiveTimeout: const Duration(milliseconds: 6000),
          followRedirects: false,
          validateStatus: (status) => status! < 400,
        ),
      );
      return true;
    } catch (e) {
      return false;
    }
  }
}
