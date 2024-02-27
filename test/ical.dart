import 'package:enough_icalendar/enough_icalendar.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("Test VAlarm triggerDate", () {
    final alarm = VAlarm();
    alarm.triggerDate = DateTime.now();
  });
}
