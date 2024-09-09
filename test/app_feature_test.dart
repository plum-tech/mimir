import 'package:flutter_test/flutter_test.dart';
import 'package:mimir/feature/feature.dart';

void main() {
  group("Building", () {
    test("Building AppFeature trees", () {
      final tree = AppFeature.tree;
    });
  });
  group("Querying", () {
    test("Querying AppFeature trees", () {
      final tree = AppFeature.tree;
      assert(tree.has("mimir") == true);
      assert(tree.has("mimir.bulletin") == true);
      assert(tree.has("school.secondClass") == true);
      assert(tree.has("notFound") == false);
      assert(tree.has("mimir.notFound") == false);
    });
  });
}
