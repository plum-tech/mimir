import 'package:flutter_test/flutter_test.dart';
import 'package:mimir/utils/format.dart';

void main() {
  group("One file", () {
    test("Duplicate", () {
      assert("Test 2" == getDuplicateFileName("Test", all: ["Test"]));
    });

    test("ending with number", () {
      assert("Test 3" == getDuplicateFileName("Test 2", all: ["Test 2"]));
    });
  });
  group("Two or more files, format", () {
    test("Without space", () {
      assert("TestB 2" == getDuplicateFileName("TestB", all: ["TestA", "TestB"]));
    });
    test("With space", () {
      assert("Test B 2" == getDuplicateFileName("Test B", all: ["Test A", "Test B"]));
    });
  });
  group("Two or more files, already existing", () {
    test("Duplicate again", () {
      assert("Test B 3" == getDuplicateFileName("Test B", all: ["Test A", "Test B", "Test B 2"]));
    });
    test("Duplicate new one again", () {
      assert("Test B 3" == getDuplicateFileName("Test B 2", all: ["Test A", "Test B", "Test B 2"]));
    });
    test("Duplicate another", () {
      assert("Test A 2" == getDuplicateFileName("Test A", all: ["Test A", "Test B", "Test B 2"]));
    });
    test("Already have 3, but duplicate 2", () {
      assert("Test 4" == getDuplicateFileName("Test 2", all: ["Test", "Test 2", "Test 3"]));
    });
  });
}
