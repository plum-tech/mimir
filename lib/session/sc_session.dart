import '../network/session.dart';
import '../util/logger.dart';

class ScSession extends ISession {
  final ISession _session;

  ScSession(this._session) {
    Log.info('初始化 ScSession');
  }

  Future<void> _refreshCookie() async {
    await _session.request(
      'https://authserver.sit.edu.cn/authserver/login?service=http%3A%2F%2Fsc.sit.edu.cn%2Flogin.jsp',
      ReqMethod.get,
    );
  }

  bool _isRedirectedToLoginPage(String data) {
    return data.startsWith('<script');
  }

  @override
  Future<SessionRes> request(
    String url,
    ReqMethod method, {
    Map<String, String>? para,
    data,
    SessionOptions? options,
    SessionProgressCallback? onSendProgress,
    SessionProgressCallback? onReceiveProgress,
  }) async {
    Future<SessionRes> fetch() async {
      return await _session.request(
        url,
        method,
        para: para,
        data: data,
        options: options,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    }

    SessionRes response = await fetch();
    // 如果返回值是登录页面，那就从 SSO 跳转一次以登录.
    if (_isRedirectedToLoginPage(response.data as String)) {
      await _refreshCookie();
      response = await fetch();
    }
    return response;
  }
}
