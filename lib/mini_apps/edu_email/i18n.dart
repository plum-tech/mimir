import 'using.dart';

const i18n = _I18n();

class _I18n with CommonI18nMixin {
  const _I18n();

  static const ns = "eduEmail";

  String get title => "$ns.title".tr();

  String get noContent => "$ns.noContent".tr();

  String get noSubject => "$ns.noSubject".tr();

  String get pluralSenderTailing => "$ns.pluralSenderTailing".tr();

  String get text => "$ns.text".tr();
}
