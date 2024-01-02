import 'package:dio/dio.dart';

/// mysit.life
class BackendSession {
  final Dio dio;

  const BackendSession({required this.dio});

  /// get.mysit.life is a static server, authentication is not required.
  Future<Response> get(
    String url, {
    Map<String, String>? para,
    data,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    return await dio.request(
      url,
      queryParameters: para,
      data: data,
      options: options,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }
}
