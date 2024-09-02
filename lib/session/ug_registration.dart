import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mimir/credentials/entity/credential.dart';
import 'package:mimir/credentials/init.dart';
import 'package:mimir/init.dart';
import 'package:mimir/r.dart';
import 'package:mimir/school/entity/school.dart';

import 'package:mimir/session/sso.dart';
import 'package:mimir/utils/dio.dart';

/// jwxt.sit.edu.cn
/// Student registration system for undergraduate
class UgRegistrationSession {
  final SsoSession _ssoSession;

  const UgRegistrationSession({
    required SsoSession ssoSession,
  }) : _ssoSession = ssoSession;

  Future<Response> importTimetable(String url, SemesterInfo info) async {
    await Init.schoolCookieJar.deleteAll();
    final loginRes = await _ssoSession.loginLocked(CredentialsInit.storage.oa.credentials!);
    final response = await Init.schoolDio.request(
      "http://jwxt.sit.edu.cn/sso/jziotlogin",
      options: Options(
        followRedirects: false,
        validateStatus: (status) {
          return status! < 400;
        },
      ),
    );
    final debugDepths = <Response>[];
    final finalResponse = await processRedirect(
      Init.schoolDio,
      response,
      debugDepths: debugDepths,
    );
    print(debugDepths);
    final timetableRes = await Init.schoolDio.get(
      url,
      options: Options(
        method: "POST",
      ),
      queryParameters: {'gnmkdm': 'N253508'},
      data: FormData.fromMap({
        // 学年名
        'xnm': info.exactYear.toString(),
        // 学期名
        'xqm': info.semester.toUgRegFormField()
      }),
    );
    return timetableRes;
  }

  Future<void> _refreshCookie() async {
    await Init.schoolCookieJar.delete(R.ugRegUri, true);
    await _ssoSession.request(
      'http://jwxt.sit.edu.cn/sso/jziotlogin',
      options: Options(
        method: "GET",
      ),
    );
  }

  bool _isRedirectedToLoginPage(Response response) {
    final realPath = response.realUri.path;
    return realPath.endsWith('jwglxt/xtgl/login_slogin.html');
  }

  Future<Response> request(
    String url, {
    Map<String, String>? queryParameters,
    data,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    options ??= Options();
    // TODO: is this really necessary?
    options.contentType = 'application/x-www-form-urlencoded;charset=utf-8';
    Future<Response> fetch() async {
      return await _ssoSession.request(
        url,
        queryParameters: queryParameters,
        data: data,
        options: options?.copyWith(
          followRedirects: false,
          validateStatus: (status) {
            return status! < 400;
          },
        ),
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    }

    await _refreshCookie();
    final response = await fetch();
    if (_isRedirectedToLoginPage(response)) {
      debugPrint('JwxtSession requires login');
      await _refreshCookie();
      return await fetch();
    }
    return response;
  }

  Future<bool> checkConnectivity({
    String url = 'http://jwxt.sit.edu.cn/',
  }) async {
    return true;
    try {
      await Init.dioNoCookie.request(
        url,
        options: Options(
          method: "GET",
          sendTimeout: const Duration(milliseconds: 3000),
          receiveTimeout: const Duration(milliseconds: 3000),
          contentType: Headers.formUrlEncodedContentType,
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
