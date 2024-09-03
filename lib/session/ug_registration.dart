import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:mimir/init.dart';
import 'package:mimir/r.dart';
import 'package:mimir/session/sso.dart';
import 'package:mimir/utils/dio.dart';

/// jwxt.sit.edu.cn
/// Student registration system for undergraduate
class UgRegistrationSession {
  Dio get _dio => Init.schoolDio;

  CookieJar get _cookieJar => Init.schoolCookieJar;

  SsoSession get _ssoSession => Init.ssoSession;

  const UgRegistrationSession();

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
    final data = response.data;
    if (data is String && data.contains("请输入用户名")) {
      return true;
    }
    final realPath = response.realUri.path;
    return realPath.endsWith('jwglxt/xtgl/login_slogin.html');
  }

  Future<bool> checkAuthStatus() async {
    final res = await _dio.requestFollowRedirect(
      "http://jwxt.sit.edu.cn/sso/jziotlogin",
    );
    return !_isLoginRequired(res);
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
      return await _dio.request(
        url,
        queryParameters: queryParameters,
        data: data?.call(),
        options: (options ?? Options()).copyWith(
          followRedirects: false,
          validateStatus: (status) => status! < 400,
        ),
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    }

    // await _cookieJar.delete(R.ugRegUri, true);
    await _ssoSession.ssoAuth("http://jwxt.sit.edu.cn/sso/jziotlogin");
    // final authorized = await checkAuthStatus();
    // if (!authorized) {
    //   await _cookieJar.delete(R.ugRegUri, true);
    //   await _ssoSession.ssoAuth("http://jwxt.sit.edu.cn/sso/jziotlogin");
    // }
    final res = await fetch();
    return res;
  }

  Future<bool> checkConnectivity({
    String url = 'http://jwxt.sit.edu.cn/',
  }) async {
    try {
      await Init.dioNoCookie.request(
        url,
        options: Options(
          method: "GET",
          sendTimeout: const Duration(milliseconds: 8000),
          receiveTimeout: const Duration(milliseconds: 8000),
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
