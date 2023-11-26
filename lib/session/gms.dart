import 'package:dio/dio.dart';
import 'package:sit/credentials/init.dart';
import 'package:sit/exception/session.dart';
import 'package:sit/init.dart';
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
    // TODO: is this really necessary?
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
    if (content is String && content.contains("正在登录") == true) {
      await authGmsService();
      return await fetch();
    }
    return response;
  }

  Future<bool> authGmsService() async {
    final authRes = await ssoSession.request(
      "https://authserver.sit.edu.cn/authserver/login?service=http%3A%2F%2Fgms.sit.edu.cn%2Fepstar%2Fweb%2Fswms%2Fmainframe%2Fhome%2Findex.jsp",
      ReqMethod.get,
    );
    return authRes.statusCode == 302;
  }
}
