import 'package:flutter_test/flutter_test.dart';
import 'package:sit/utils/format.dart';

void main() {
  group("Test duplicate names", () {
    test("only one", () {
      assert("Test 2" == getDuplicateFileName("Test", all: ["Test"]));
    });
    test("two or more without space", () {
      assert("TestB 2" == getDuplicateFileName("TestB", all: ["TestA", "TestB"]));
    });
    test("two or more with space", () {
      assert("Test B 2" == getDuplicateFileName("Test B", all: ["Test A", "Test B"]));
    });
    test("two or more", () {
      assert("Test B 2" == getDuplicateFileName("Test B", all: ["Test A", "Test B"]));
    });
  });
}
