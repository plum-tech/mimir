import 'package:easy_localization/easy_localization.dart';

enum Weekday {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday;

  int toJson() => index;

  factory Weekday.fromJson(int json) => Weekday.values.elementAtOrNull(json) ?? Weekday.monday;

  String l10n() => "weekday.$index".tr();

  String l10nShort() => "weekdayShort.$index".tr();
}
