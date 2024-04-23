import 'package:easy_localization/easy_localization.dart';
import 'package:sit/credentials/i18n.dart';
import 'package:sit/l10n/common.dart';

const i18n = _I18n();

class _I18n with CommonI18nMixin {
  const _I18n();

  static const ns = "networkTool";
  final easyconnect = const _Easyconnect();
  final network = const NetworkI18n();
  final credentials = const OaCredentialsI18n();

  String get title => "$ns.title".tr();

  String get subtitle => "$ns.subtitle".tr();

  String get openWifiSettingsBtn => "$ns.openWifiSettingsBtn".tr();

  String get connectionFailedError => "$ns.connectionFailedError".tr();

  String get connectionFailedButCampusNetworkConnected => "$ns.connectionFailedButCampusNetworkConnected".tr();

  String get studentRegAvailable => "$ns.studentRegAvailable".tr();

  String get studentRegUnavailable => "$ns.studentRegUnavailable".tr();

  String get ugRegAvailableTip => "$ns.ugRegAvailableTip".tr();

  String get ugRegUnavailableTip => "$ns.ugRegUnavailableTip".tr();

  String get pgRegAvailableTip => "$ns.pgRegAvailableTip".tr();

  String get pgRegUnavailableTip => "$ns.pgRegUnavailableTip".tr();

  String get campusNetworkConnected => "$ns.campusNetworkConnected".tr();

  String get campusNetworkNotConnected => "$ns.campusNetworkNotConnected".tr();

  String get troubleshooting => "$ns.troubleshooting".tr();

  String get studentRegTroubleshooting => "$ns.studentRegTroubleshooting".tr();

  String get studentRegUnavailableButCampusNetworkConnected =>
      "$ns.studentRegUnavailableButCampusNetworkConnected".tr();
}

class _Easyconnect {
  const _Easyconnect();

  static const ns = "easyconnect";

  String get launchBtn => "$ns.launchBtn".tr();

  String get launchFailed => "$ns.launchFailed".tr();

  String get launchFailedDesc => "$ns.launchFailedDesc".tr();
}
