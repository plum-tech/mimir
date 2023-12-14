import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:sit/session/sso.dart';

/// jwxt.sit.edu.cn
/// for undergraduate
class JwxtSession {
  final SsoSession ssoSession;

  const JwxtSession({required this.ssoSession});

  Future<void> refreshCookie() async {
    await ssoSession.request(
      'http://jwxt.sit.edu.cn/sso/jziotlogin',
      options: Options(
        method: "GET",
      ),
    );
  }

  bool _isRedirectedToLoginPage(Response response) {
    return response.realUri.path == '/jwglxt/xtgl/login_slogin.html';
  }

  Future<Response> request(
    String url, {
    Map<String, String>? para,
    data,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    Future<Response> fetch() async {
      return await ssoSession.request(
        url,
        para: para,
        data: data,
        options: options,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    }

    final response = await fetch();
    // 如果返回值是登录页面，那就从 SSO 跳转一次以登录.
    if (_isRedirectedToLoginPage(response)) {
      debugPrint('JwxtSession requires login');
      await refreshCookie();
      return await fetch();
    }
    // 如果还是需要登录
    if (_isRedirectedToLoginPage(response)) {
      debugPrint('JwxtSession still requires login');
      await refreshCookie();
      return await fetch();
    }
    return response;
  }
}
