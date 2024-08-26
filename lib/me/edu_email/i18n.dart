import 'package:easy_localization/easy_localization.dart';
import 'package:mimir/l10n/common.dart';
import 'package:mimir/login/i18n.dart';

const i18n = _I18n();

class _I18n with CommonI18nMixin {
  const _I18n();

  static const ns = "eduEmail";
  final action = const _Action();
  final login = const _Login();
  final inbox = const _Inbox();
  final outbox = const _Outbox();
  final info = const _Info();

  String get title => "$ns.title".tr();

  String get noContent => "$ns.noContent".tr();

  String get noSubject => "$ns.noSubject".tr();

  String get pluralSenderTailing => "$ns.pluralSenderTailing".tr();

  String get text => "$ns.text".tr();
}

class _Action {
  const _Action();

  static const ns = "${_I18n.ns}.action";

  String get open => "$ns.open".tr();

  String get login => "$ns.login".tr();

  String get inbox => "$ns.inbox".tr();

  String get outbox => "$ns.outbox".tr();
}

class _Login extends CommonLoginI18n {
  const _Login();

  static const ns = "${_I18n.ns}.login";

  String get title => "$ns.title".tr();

  String get addressHint => "$ns.addressHint".tr();

  String get passwordHint => "$ns.passwordHint".tr();

  String get invalidEmailAddressFormatTip => "$ns.invalidEmailAddressFormatTip".tr();
}

class _Info {
  const _Info();

  static const ns = "${_I18n.ns}.info";

  String get emailAddress => "$ns.emailAddress".tr();
}

class _Outbox {
  const _Outbox();

  static const ns = "${_I18n.ns}.outbox";

  String get title => "$ns.title".tr();
}

class _Inbox {
  const _Inbox();

  static const ns = "${_I18n.ns}.inbox";

  String get title => "$ns.title".tr();
}
