import 'package:dio/dio.dart';
import 'package:mimir/network/session.dart';
import 'package:mimir/session/sso/session.dart';
import 'package:mimir/utils/logger.dart';

/// Student information system of SIT
class SisSession extends ISession {
  final SsoSession ssoSession;

  SisSession(this.ssoSession);

  Future<void> _refreshCookie() async {
    await ssoSession.request('http://jwxt.sit.edu.cn/sso/jziotlogin', ReqMethod.get);
  }

  bool _isRedirectedToLoginPage(Response response) {
    return response.realUri.path == '/jwglxt/xtgl/login_slogin.html';
  }

  @override
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
      Log.info('EduSession需要登录');
      await _refreshCookie();
      response = await fetch();
    }
    // 如果还是需要登录
    if (_isRedirectedToLoginPage(response)) {
      Log.info('SsoSession需要登录');
      await ssoSession.ensureLoginLocked(url);
      await _refreshCookie();
      response = await fetch();
    }
    return response;
  }
}
