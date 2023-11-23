import 'package:dio/dio.dart';
import 'package:sit/credentials/init.dart';
import 'package:sit/network/session.dart';
import 'package:sit/school/library/init.dart';
import 'package:sit/session/common.dart';

class LibrarySession {
  final Dio dio;

  const LibrarySession({required this.dio});

  Future<Response> request(
    String url,
    ReqMethod method, {
    Map<String, String>? para,
    data,
    SessionOptions? options,
    SessionProgressCallback? onSendProgress,
    SessionProgressCallback? onReceiveProgress,
  }) async {
    Future<Response> fetch() async {
      return await dio.request(
        url,
        queryParameters: para,
        data: data,
        options: options?.toDioOptions().copyWith(
              method: method.name.toUpperCase(),
            ),
      );
    }

    final response = await fetch();
    if (response.data.toString().contains("用户名或密码错误")) {
      final credentials = CredentialInit.storage.libraryCredentials;
      if (credentials != null) {
        LibraryInit.auth.login(credentials);
      }
      return await fetch();
    }
    return response;
  }
}
