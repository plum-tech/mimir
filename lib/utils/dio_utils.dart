import 'package:dio/dio.dart';

/// Useful utils when processing network requests by dio.
class DioUtils {
  // ignore: non_constant_identifier_names
  static Options get NON_REDIRECT_OPTION_WITH_FORM_TYPE {
    return Options(
      contentType: Headers.formUrlEncodedContentType,
      followRedirects: false,
      validateStatus: (status) {
        return status! < 400;
      },
    );
  }

  // ignore: non_constant_identifier_names
  static Options NON_REDIRECT_OPTION_WITH_FORM_TYPE_AND_HEADER(Map<String, dynamic> header) => Options(
      headers: header,
      contentType: Headers.formUrlEncodedContentType,
      followRedirects: false,
      validateStatus: (status) {
        return status! < 400;
      });

  static Future<Response> processRedirect(Dio dio, Response response, {Map<String, dynamic>? headers}) async {
    //Prevent the redirect being processed by HttpClient, with the 302 response caught manually.
    if (response.statusCode == 302 &&
        response.headers['location'] != null &&
        response.headers['location']!.isNotEmpty) {
      String location = response.headers['location']![0];
      if (location.isEmpty) return response;
      if (!Uri.parse(location).isAbsolute) {
        location = '${response.requestOptions.uri.origin}/$location';
      }
      return processRedirect(
        dio,
        await dio.get(
          location,
          options: NON_REDIRECT_OPTION_WITH_FORM_TYPE.copyWith(
            responseType: response.requestOptions.responseType,
            headers: headers,
          ),
        ),
        headers: headers,
      );
    } else {
      return response;
    }
  }
}
