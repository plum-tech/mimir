import 'package:dio/dio.dart';
import 'package:sit/network/session.dart';

import '../network/download.dart';

extension DioOptionsConverter on Options {
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
    Options? options,
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
    Options? options,
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
