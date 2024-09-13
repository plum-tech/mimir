import 'package:flutter_test/flutter_test.dart';
import 'package:mimir/credentials/entity/user_type.dart';
import 'package:mimir/feature/feature.dart';

void main() {
  group("Building", () {
    test("Building AppFeature trees", () {
      final tree = AppFeature.tree;
    });
    test("Building empty", () {
      final tree = AppFeatureTree.build({});
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
    test("Querying OaUserType tree", () {
      const type = OaUserType.undergraduate;
      assert(type.allow("school.secondClass") == true);
      assert(type.allow("mimir.notFound") == false);
      assert(type.allow("school.library") == true);
      assert(type.allow("school.library.account") == true);
    });
    test("Querying empty tree", () {
      final tree = AppFeatureTree.build({});
      assert(tree.has("mimir") == false);
      assert(tree.has("mimir.bulletin") == false);
      assert(tree.has("school.secondClass") == false);
      assert(tree.has("notFound") == false);
      assert(tree.has("mimir.notFound") == false);
    });
  });
}
