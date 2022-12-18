import 'package:flutter/material.dart';

Future<DateTime?> pickDate(BuildContext ctx, {required DateTime initial}) async {
  return await showDatePicker(
    context: ctx,
    initialDate: initial,
    currentDate: DateTime.now(),
    firstDate: DateTime(DateTime.now().year),
    lastDate: DateTime(DateTime.now().year + 2),
    selectableDayPredicate: (DateTime dataTime) => dataTime.weekday == DateTime.monday,
  );
}
