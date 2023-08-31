import 'package:easy_localization/easy_localization.dart';

import '../l10n/common.dart';

const i18n = MainI18n();

class MainI18n with CommonI18nMixin {
  const MainI18n();

  static const ns = "main";

  String get home => "$ns.home".tr();

  String get networkTool => "$ns.networkTool".tr();

  String get settings => "$ns.settings".tr();
}
