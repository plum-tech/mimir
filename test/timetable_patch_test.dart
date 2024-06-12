import 'package:flutter_test/flutter_test.dart';
import 'package:sit/timetable/patch/builtin.dart';
import 'package:sit/timetable/patch/entity/patch.dart';

void main() {
  final patch = BuiltinTimetablePatchSets.vacationShift2024;
  group("Serialization", () {
    test("Serialization", () {
      final serialized = TimetablePatchEntry.encodeByteList(patch);
      print(serialized.length);
      assert(serialized.length == 195);
    });
    test("Deserialization", () {
      final serialized = TimetablePatchEntry.encodeByteList(patch);
      final entry = TimetablePatchEntry.decodeByteList(serialized);
      assert(entry is TimetablePatchSet);
      final restored = entry as TimetablePatchSet;
      assert(restored.patches.length == patch.patches.length);
      assert(restored.name == patch.name);
    });
  });
}
