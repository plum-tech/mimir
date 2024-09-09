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
      assert(tree.find("mimir") == true);
      assert(tree.find("mimir.bulletin") == true);
      assert(tree.find("school.secondClass") == true);
      assert(tree.find("notFound") == false);
      assert(tree.find("mimir.notFound") == false);
    });
  });
}
