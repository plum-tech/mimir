import 'package:dio/dio.dart';
import 'package:mimir/init.dart';
import 'package:mimir/session/sso.dart';

class Class2ndSession {
  final SsoSession ssoSession;

  Class2ndSession({required this.ssoSession});

  bool _needRedirectToLoginPage(String data) {
    return data.contains('<meta http-equiv="refresh" content="0;URL=http://my.sit.edu.cn"/>');
  }

  Future<Response> request(
    String url, {
    Map<String, String>? para,
    data,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    Future<Response> fetch() {
      return ssoSession.request(
        url,
        queryParameters: para,
        data: data,
        options: options,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    }

    var res = await fetch();
    final responseData = res.data;
    // 如果返回值是登录页面，那就从 SSO 跳转一次以登录.
    if (responseData is String && _needRedirectToLoginPage(responseData)) {
      await Init.schoolCookieJar.delete(Uri.parse(url), true);
      // the response has been already redirected to the originally-requested one.
      res = await ssoSession.request(
        'https://authserver.sit.edu.cn/authserver/login?service=http%3A%2F%2Fsc.sit.edu.cn%2Flogin.jsp',
        options: Options(
          method: "GET",
        ),
      );
      // res = await fetch();
    }
    return res;
  }
}
