import 'package:dio/dio.dart';
import 'package:sit/network/session.dart';

import '../network/download.dart';

extension DioOptionsConverter on SessionOptions {
  Options toDioOptions() {
    return Options(
      method: method,
      sendTimeout: sendTimeout,
      receiveTimeout: receiveTimeout,
      extra: extra,
      headers: headers,
      responseType: responseType,
      contentType: contentType,
    );
  }
}

class DioDownloader implements Downloader {
  Dio dio;

  DioDownloader(this.dio);

  @override
  Future<void> download(
    String url, {
    String? savePath,
    SessionProgressCallback? onReceiveProgress,
    Map<String, String>? queryParameters,
    data,
    SessionOptions? options,
  }) async {
    await dio.download(
      url,
      savePath,
      onReceiveProgress: onReceiveProgress,
      queryParameters: queryParameters,
      data: data,
      options: options?.toDioOptions(),
    );
  }
}

mixin DioDownloaderMixin implements Downloader {
  Dio get dio;

  @override
  Future<void> download(
    String url, {
    String? savePath,
    SessionProgressCallback? onReceiveProgress,
    Map<String, String>? queryParameters,
    data,
    SessionOptions? options,
  }) async {
    await DioDownloader(dio).download(
      url,
      savePath: savePath,
      onReceiveProgress: onReceiveProgress,
      queryParameters: queryParameters,
      data: data,
      options: options,
    );
  }
}

class DefaultDioSession with DioDownloaderMixin {
  @override
  Dio dio;

  DefaultDioSession(this.dio);

  Future<Response> request(
    String url,
    ReqMethod method, {
    Map<String, String>? para,
    data,
    SessionOptions? options,
    SessionProgressCallback? onSendProgress,
    SessionProgressCallback? onReceiveProgress,
  }) async {
    final response = await dio.request(
      url,
      queryParameters: para,
      data: data,
      options: options?.toDioOptions().copyWith(
            method: method.name.toUpperCase(),
          ),
    );
    return response;
  }
}
