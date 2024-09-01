import 'package:flutter_test/flutter_test.dart';
import 'package:mimir/intent/deep_link/utils.dart';
import 'package:mimir/timetable/p13n/builtin.dart';

void main() {
  group("Timetable palette", () {
    for (final palette in BuiltinTimetablePalettes.all) {
      test(palette.name, () {
        final bytes = encodeBytesForUrl(palette.encodeByteList(), compress: false);
      });
    }
  });
  group("Parsing URI", () {
    test("Go Route", () {
      final uri = Uri.parse("sit-life://app/go?/login&3.0.0=/oa/login");
      print(uri.query);
      print(uri.queryParameters);
      print(uri.queryParametersAll);
    });
  });
}
