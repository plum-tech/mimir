import 'package:easy_localization/easy_localization.dart';
import 'package:sit/credentials/i18n.dart';
import 'package:sit/l10n/common.dart';

const i18n = _I18n();

class _I18n with CommonI18nMixin {
  const _I18n();

  static const ns = "eduEmail";
  final action = const _Action();
  final login = const _Login();
  final inbox = const _Inbox();
  final outbox = const _Outbox();

  String get title => "$ns.title".tr();

  String get noContent => "$ns.noContent".tr();

  String get noSubject => "$ns.noSubject".tr();

  String get pluralSenderTailing => "$ns.pluralSenderTailing".tr();

  String get text => "$ns.text".tr();
}

class _Action {
  const _Action();

  static const ns = "${_I18n.ns}.action";

  String get login => "$ns.login".tr();

  String get inbox => "$ns.inbox".tr();

  String get outbox => "$ns.outbox".tr();
}

class _Login {
  const _Login();

  final credentials = const CredentialsI18n();

  static const ns = "${_I18n.ns}.login";

  String get title => "$ns.title".tr();

  String get addressHint => "$ns.addressHint".tr();

  String get failedWarn => "$ns.failedWarn.title".tr();

  String get failedWarnDesc => "$ns.failedWarn.desc".tr();
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
