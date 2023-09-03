import 'package:dio/dio.dart';
import 'package:mimir/network/session.dart';

import '../network/download.dart';

extension DioResTypeConverter on SessionResType {
  ResponseType toDioResponseType() {
    return (const {
      SessionResType.json: ResponseType.json,
      SessionResType.stream: ResponseType.stream,
      SessionResType.plain: ResponseType.plain,
      SessionResType.bytes: ResponseType.bytes,
    })[this]!;
  }
}

extension DioOptionsConverter on SessionOptions {
  Options toDioOptions() {
    return Options(
      method: method,
      sendTimeout: sendTimeout,
      receiveTimeout: receiveTimeout,
      extra: extra,
      headers: headers,
      responseType: responseType?.toDioResponseType(),
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

class DefaultDioSession with DioDownloaderMixin implements ISession {
  @override
  Dio dio;

  DefaultDioSession(this.dio);

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
