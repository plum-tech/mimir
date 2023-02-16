import 'using.dart';

const _ns = "activity";
const i18n = _I18n();

class _I18n with CommonI18nMixin {
  const _I18n();

  final navigation = const _Navigation();
  final apply = const _Apply();
  final application = const _Application();

  String get id => "id".tr();

  String get contactInfo => "contactInfo".tr();

  String get detailEmptyTip => "detailEmptyTip".tr();

  String get details => "details".tr();

  String get duration => "duration".tr();

  String get location => "location".tr();

  String get myScoreTitle => "myScoreTitle".tr();

  String get organizer => "organizer".tr();

  String get principal => "principal".tr();

  String get signInTime => "signInTime".tr();

  String get signOutTime => "signOutTime".tr();

  String get startTime => "startTime".tr();

  String get tags => "tags".tr();

  String get undertaker => "undertaker".tr();
}

class _Navigation {
  const _Navigation();

  static const _n = "$_ns.navigation";

  String get all => "$_n.all".tr();

  String get mine => "$_n.all".tr();
}

class _Apply {
  const _Apply();

  static const _n = "$_ns.apply";

  String get btn => "$_n.btn".tr();

  String get replyTip => "$_n.replyTip".tr();

  String get request => "$_n.request".tr();

  String get requestDesc => "$_n.requestDesc".tr();
}

class _Application {
  const _Application();

  static const _n = "$_ns.application";

  String get id => "$_n.id".tr();

  String get time => "$_n.time".tr();
}
