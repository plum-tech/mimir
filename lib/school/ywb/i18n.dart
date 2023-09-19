import 'package:easy_localization/easy_localization.dart';
import 'package:mimir/l10n/common.dart';

const i18n = _I18n();

class _I18n with CommonI18nMixin {
  const _I18n();

  static const ns = "ywb";

  final mailbox = const _Mailbox();
  final navigation = const _Navigation();

  String get title => "$ns.title".tr();

  String get desc => "$ns.desc".tr();

  String get filerInfrequentlyUsed => "$ns.filerInfrequentlyUsed".tr();
}

class _Mailbox {
  const _Mailbox();

  static const ns = "${_I18n.ns}.application";

  String get mailbox => "$ns.title".tr();

  String get emptyTip => "$ns.emptyTip".tr();

  String get recent => "$ns.recent".tr();
}

class _Navigation {
  const _Navigation();

  static const ns = "${_I18n.ns}.navigation";

  String get all => "$ns.all".tr();

  String get mailbox => "$ns.mailbox".tr();
}
