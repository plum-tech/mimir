import 'package:flutter_test/flutter_test.dart';
import 'package:sit/r.dart';

void main() {
  group("Parse URL", () {
    test("Test parse wechat", () {
      const url = "weixin://dl/publicaccount?username=gh_61f7fd217d36";
      final uri = Uri.parse(url);
      _printUri(uri);
    });
  });
  group("Create URL", () {
    final uri =  Uri(scheme: R.scheme,path: "timetable-patch");
    _printUri(uri);
  });
}

void _printUri(Uri uri) {
  print('$uri');
  print('isAbsolute=${uri.isAbsolute}');
  print('scheme="${uri.scheme}"');
  print('authority="${uri.authority}"');
  print('userInfo="${uri.userInfo}"');
  print('host="${uri.host}"');
  print('port="${uri.port}"');
  print('path="${uri.path}"');
  print('query="${uri.query}"');
  print('fragment="${uri.fragment}"');
  print('pathSegments="${uri.pathSegments}"');
  print('queryParametersAll="${uri.queryParametersAll}"');
}
