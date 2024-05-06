import 'package:flutter_test/flutter_test.dart';
import 'package:sit/qrcode/utils.dart';
import 'package:sit/timetable/palette.dart';

void main() {
  group("Timetable palette", () {
    for (final palette in BuiltinTimetablePalettes.all) {
      test(palette.name, () {
        final bytes = encodeBytesForUrl(palette.encodeByteList(), compress: false);
      });
    }
  });
}
