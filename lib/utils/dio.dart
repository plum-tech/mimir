import 'package:dio/dio.dart';
import 'package:mimir/utils/strings.dart';

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
  List<Response>? debugDepths,
}) async {
  debugDepths?.add(response);
  // Prevent the redirect being processed by HttpClient, with the 302 response caught manually.
  final headerLocations = response.headers['location'];
  if (response.statusCode == 302 && headerLocations != null && headerLocations.isNotEmpty) {
    var location = headerLocations[0];
    if (location.isEmpty) return response;
    final locationUri = Uri.parse(location);
    if (!locationUri.isAbsolute) {
      // to prevent double-slash issue
      location = '${response.requestOptions.uri.origin.removeSuffix("/")}/${location.removePrefix("/")}';
    }
    final redirectedResponse = await dio.get(
      location,
      options: disableRedirectFormEncodedOptions(
        responseType: response.requestOptions.responseType,
        headers: headers,
      ),
    );
    return await processRedirect(
      dio,
      redirectedResponse,
      headers: headers,
      debugDepths: debugDepths,
    );
  } else {
    return response;
  }
}
