import 'package:easy_localization/easy_localization.dart';
import 'package:sit/credentials/i18n.dart';
import 'package:sit/l10n/common.dart';

const i18n = _I18n();

class _I18n with CommonI18nMixin {
  const _I18n();

  static const ns = "library";
  final login = const _Login();
  final info = const _Info();

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

class _Info {
  const _Info();

  static const ns = "${_I18n.ns}.info";

  String get title => "$ns.title".tr();

  String get author => "$ns.author".tr();

  String get isbn => "$ns.isbn".tr();

  String get publisher => "$ns.publisher".tr();

  String get publishDate => "$ns.publishDate".tr();

  String get callNumber => "$ns.callNumber".tr();

  String get bookId => "$ns.bookId".tr();

  String get barcode => "$ns.barcode".tr();
}
