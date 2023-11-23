import 'package:easy_localization/easy_localization.dart';
import 'package:sit/credentials/i18n.dart';
import 'package:sit/l10n/common.dart';

const i18n = _I18n();

class _I18n with CommonI18nMixin {
  const _I18n();

  static const ns = "library";
  final login = const _Login();

  String get title => "$ns.title".tr();

  String get hotPost => "$ns.hotPost".tr();

  String get readerId => "$ns.readerId".tr();
}

class _Login {
  const _Login();

  final credentials = const CredentialsI18n();

  static const ns = "${_I18n.ns}.login";

  String get title => "$ns.title".tr();

  String get readerIdHint => "$ns.readerIdHint".tr();

  String get passwordHint => "$ns.passwordHint".tr();

  String get failedWarn => "$ns.failedWarn".tr();
}
