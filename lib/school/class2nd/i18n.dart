import 'package:easy_localization/easy_localization.dart';
import 'package:mimir/l10n/common.dart';

const i18n = _I18n();

class _I18n with CommonI18nMixin {
  const _I18n();

  static const ns = "class2nd";

  final apply = const _Apply();
  final application = const _Application();
  final activity = const _Activity();

  String get title => "$ns.title".tr();

  String get id => "$ns.id".tr();

  String get contactInfo => "$ns.contactInfo".tr();

  String get detailEmptyTip => "$ns.detailEmptyTip".tr();

  String get details => "$ns.details".tr();

  String get duration => "$ns.duration".tr();

  String get location => "$ns.location".tr();

  String get myScoreTitle => "$ns.myScoreTitle".tr();

  String get organizer => "$ns.organizer".tr();

  String get principal => "$ns.principal".tr();

  String get signInTime => "$ns.signInTime".tr();

  String get signOutTime => "$ns.signOutTime".tr();

  String get startTime => "$ns.startTime".tr();

  String get tags => "$ns.tags".tr();

  String get undertaker => "$ns.undertaker".tr();
}

class _Activity {
  const _Activity();

  static const ns = "${_I18n.ns}.activity";

  String get title => "$ns.title".tr();
}

class _Apply {
  const _Apply();

  static const ns = "${_I18n.ns}.apply";

  String get btn => "$ns.btn".tr();

  String get replyTip => "$ns.replyTip".tr();

  String get applyRequest => "$ns.applyRequest".tr();

  String get applyRequestDesc => "$ns.applyRequestDesc".tr();
}

class _Application {
  const _Application();

  static const ns = "${_I18n.ns}.application";

  String get id => "$ns.id".tr();

  String get time => "$ns.time".tr();
}
