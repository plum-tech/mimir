import 'package:dio/dio.dart';

Options disableRedirectFormEncodedOptions({
  Map<String, dynamic>? headers,
  ResponseType? responseType,
}) {
  return Options(
    headers: headers,
    contentType: Headers.formUrlEncodedContentType,
    followRedirects: false,
    responseType: responseType,
    validateStatus: (status) {
      return status! < 400;
    },
  );
}

Future<Response> processRedirect(
  Dio dio,
  Response response, {
  Map<String, dynamic>? headers,
}) async {
  //Prevent the redirect being processed by HttpClient, with the 302 response caught manually.
  if (response.statusCode == 302 && response.headers['location'] != null && response.headers['location']!.isNotEmpty) {
    String location = response.headers['location']![0];
    if (location.isEmpty) return response;
    if (!Uri.parse(location).isAbsolute) {
      location = '${response.requestOptions.uri.origin}/$location';
    }
    return processRedirect(
      dio,
      await dio.get(
        location,
        options: disableRedirectFormEncodedOptions(
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
