import 'package:intl/intl.dart';

extension FormatToString on DateTime {
  String get yyyyMMdd {
    return DateFormat('yyyyMMdd').format(this);
  }
}
