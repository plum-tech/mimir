import 'package:dio/dio.dart';
import 'package:sit/credentials/init.dart';
import 'package:sit/exception/session.dart';
import 'package:sit/network/session.dart';
import 'package:sit/session/sso.dart';

/// gms.sit.edu.cn
/// for postgraduate
class GmsSession {
  final SsoSession ssoSession;

  const GmsSession({required this.ssoSession});

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
    final response = await fetch();
    final content = response.data;
    if (content is String && content.contains("登录") == true) {
      final credential = CredentialInit.storage.oaCredentials;
      if (credential == null) {
        throw LoginRequiredException(url: url);
      }
      await ssoSession.loginLocked(credential);
      return await fetch();
    }
    return response;
  }
}
