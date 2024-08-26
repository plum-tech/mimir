import 'package:easy_localization/easy_localization.dart';
import 'package:mimir/l10n/common.dart';

const i18n = _I18n();

class _I18n with CommonI18nMixin {
  const _I18n();

  final settings = const _Settings();

  static const ns = "forum";

  String get navigation => "$ns.navigation".tr();
}

class _Settings {
  const _Settings();

  static const ns = "${_I18n.ns}.settings";
}
