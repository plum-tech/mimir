import 'package:flutter_test/flutter_test.dart';
import 'package:mimir/migration/migrations.dart';
import 'package:version/version.dart';

void main() {
  group("Migrations", () {
    Migrations.init();
    test("Resolve migrations from v2.6.3 to v2.6.4", () {
      final matched = Migrations.match(from: Version(2, 5, 2, build: "470"), to: Version(2, 6, 3, build: "12"));
      assert(matched.length == 1);
    });

    test("Resolve migrations from v2.5.2 to v2.6.4", () {
      final matched = Migrations.match(from: Version(2, 5, 2, build: "470"), to: Version(2, 6, 4, build: "501"));
      assert(matched.length == 1);
    });

    test("Resolve migrations from v2.6.3 to v2.6.4", () {
      final matched = Migrations.match(from: Version(2, 6, 3, build: "12"), to: Version(2, 6, 4, build: "500"));
      assert(matched.length == 0);
    });
  });
}
