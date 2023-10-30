import 'package:dio/dio.dart';
import 'package:sit/credentials/init.dart';
import 'package:sit/exception/session.dart';
import 'package:sit/network/session.dart';
import 'package:sit/session/sso.dart';
import 'package:sit/utils/logger.dart';

/// jwxt.sit.edu.cn
/// for undergraduate
class JwxtSession {
  final SsoSession ssoSession;

  const JwxtSession({required this.ssoSession});

  Future<void> _refreshCookie() async {
    await ssoSession.request('http://jwxt.sit.edu.cn/sso/jziotlogin', ReqMethod.get);
  }

  bool _isRedirectedToLoginPage(Response response) {
    return response.realUri.path == '/jwglxt/xtgl/login_slogin.html';
  }

  Future<Response> request(
    String url,
    ReqMethod method, {
    Map<String, String>? para,
    data,
    SessionOptions? options,
    SessionProgressCallback? onSendProgress,
    SessionProgressCallback? onReceiveProgress,
  }) async {
    options ??= SessionOptions();
    options.contentType = 'application/x-www-form-urlencoded;charset=utf-8';
    Future<Response> fetch() async {
      return await ssoSession.request(
        url,
        method,
        para: para,
        data: data,
        options: options,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    }

    var response = await fetch();
    // 如果返回值是登录页面，那就从 SSO 跳转一次以登录.
    if (_isRedirectedToLoginPage(response)) {
      Log.info('JwxtSession requires login');
      await _refreshCookie();
      response = await fetch();
    }
    // 如果还是需要登录
    if (_isRedirectedToLoginPage(response)) {
      Log.info('SsoSession login');
      final credential = CredentialInit.storage.oaCredentials;
      if (credential == null) {
        throw LoginRequiredException(url: url);
      }
      await ssoSession.loginLocked(credential);
      await _refreshCookie();
      response = await fetch();
    }
    return response;
  }
}
