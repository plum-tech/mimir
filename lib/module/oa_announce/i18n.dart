import 'using.dart';

const i18n = _I18n();

class _I18n with CommonI18nMixin {
  const _I18n();

  static const ns = "oaAnnounce";

  String attachmentTip(int count) => "$ns.attachmentTip".plural(count);

  String get text => "$ns.text".tr();

  String get downloadCompleted => "$ns.downloadCompleted".tr();

  String get publishTime => "$ns.publishTime".tr();

  String get publishingDepartment => "$ns.publishingDepartment".tr();
}
