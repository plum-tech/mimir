import 'package:easy_localization/easy_localization.dart';
import 'package:mimir/l10n/common.dart';

const i18n = _I18n();

class _I18n with CommonI18nMixin {
  const _I18n();

  static const ns = "ywb";

  final mailbox = const _Mailbox();

  String get title => "$ns.title".tr();

  String get desc => "$ns.desc".tr();

  String get noApplicationsTip => "$ns.noApplicationsTip".tr();

  String get filerInfrequentlyUsed => "$ns.filerInfrequentlyUsed".tr();
}

class _Mailbox {
  const _Mailbox();

  static const ns = "${_I18n.ns}.mailbox";

  String get title => "$ns.title".tr();

  String get noMailsTip => "$ns.noMailsTip".tr();

  String get recent => "$ns.recent".tr();
}
