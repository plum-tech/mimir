import 'package:flutter_test/flutter_test.dart';
import 'package:sit/utils/format.dart';

void main() {
  group("One file", () {
    test("duplicate", () {
      assert("Test 2" == getDuplicateFileName("Test", all: ["Test"]));
    });
  });
  group("files", () {
    test("Without space", () {
      assert("TestB 2" == getDuplicateFileName("TestB", all: ["TestA", "TestB"]));
    });
    test("With space", () {
      assert("Test B 2" == getDuplicateFileName("Test B", all: ["Test A", "Test B"]));
    });
    test("Duplicate again", () {
      assert("Test B 3" == getDuplicateFileName("Test B", all: ["Test A", "Test B", "Test B 2"]));
    });
    test("Duplicate new one again", () {
      assert("Test B 3" == getDuplicateFileName("Test B 2", all: ["Test A", "Test B", "Test B 2"]));
    });
    test("Duplicate another", () {
      assert("Test A 2" == getDuplicateFileName("Test A", all: ["Test A", "Test B", "Test B 2"]));
    });
  });
}
