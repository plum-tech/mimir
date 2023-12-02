import 'package:dio/dio.dart';
import 'package:sit/credentials/init.dart';

import 'package:sit/school/library/init.dart';

class LibraryCredentialsException implements Exception {
  final String message;

  const LibraryCredentialsException({
    required this.message,
  });

  @override
  String toString() {
    return "LibraryCredentialsException: $message";
  }
}

class LibrarySession {
  final Dio dio;

  const LibrarySession({required this.dio});

  Future<Response> request(
    String url, {
    Map<String, String>? para,
    data,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    Future<Response> fetch() {
      return dio.request(
        url,
        queryParameters: para,
        data: data,
        options: options,
      );
    }

    final response = await fetch();
    final resData = response.data;
    if (resData is String) {
      // renew login
      final credentials = CredentialInit.storage.libraryCredentials;
      if (credentials != null) {
        if (resData.contains("/opac/reader/doLogin")) {
          await LibraryInit.auth.login(credentials);
          return await fetch();
        }
      }
    }
    return response;
  }
}
