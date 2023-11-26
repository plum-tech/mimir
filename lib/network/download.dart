import 'package:dio/dio.dart';

abstract class Downloader {
  Future<void> download(
    String url, {
    String? savePath,
    ProgressCallback? onReceiveProgress,
    Map<String, String>? queryParameters,
    dynamic data,
    Options? options,
  });
}

class DioDownloader implements Downloader {
  Dio dio;

  DioDownloader(this.dio);

  @override
  Future<void> download(
      String url, {
        String? savePath,
        ProgressCallback? onReceiveProgress,
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
      options: options,
    );
  }
}

mixin DioDownloaderMixin implements Downloader {
  Dio get dio;

  @override
  Future<void> download(
      String url, {
        String? savePath,
        ProgressCallback? onReceiveProgress,
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
