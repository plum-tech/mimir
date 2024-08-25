import 'package:easy_localization/easy_localization.dart';
import 'package:sit/credentials/i18n.dart';
import 'package:sit/l10n/common.dart';
import 'package:sit/network/widgets/checker.dart';

const i18n = _I18n();

class _I18n with CommonI18nMixin {
  const _I18n();

  static const ns = "networkTool";
  final easyconnect = const _Easyconnect();
  final network = const NetworkI18n();
  final credentials = const OaCredentialsI18n();
  final checker = const _NetworkCheckerI18n();

  String get title => "$ns.title".tr();

  String get subtitle => "$ns.subtitle".tr();

  String get openWifiSettingsBtn => "$ns.openWifiSettingsBtn".tr();

  String get openInAppProxySettingsBtn => "$ns.openInAppProxySettingsBtn".tr();

  String get connectionFailedError => "$ns.connectionFailedError".tr();

  String get connectionFailedButCampusNetworkConnected => "$ns.connectionFailedButCampusNetworkConnected".tr();

  String get connecting => "$ns.connecting".tr();

  String get schoolServerAvailable => "$ns.schoolServerAvailable".tr();

  String get schoolServerUnavailable => "$ns.schoolServerUnavailable".tr();

  String get schoolServerAvailableTip => "$ns.schoolServerAvailableTip".tr();

  String get schoolServerUnavailableTip => "$ns.schoolServerUnavailableTip".tr();

  String get ywbAvailable => "$ns.ywbAvailable".tr();

  String get ywbUnavailable => "$ns.ywbUnavailable".tr();

  String get ywbAvailableTip => "$ns.ywbAvailableTip".tr();

  String get ywbUnavailableTip => "$ns.ywbUnavailableTip".tr();

  String get studentRegAvailable => "$ns.studentRegAvailable".tr();

  String get studentRegUnavailable => "$ns.studentRegUnavailable".tr();

  String get ugRegAvailableTip => "$ns.ugRegAvailableTip".tr();

  String get ugRegUnavailableTip => "$ns.ugRegUnavailableTip".tr();

  String get pgRegAvailableTip => "$ns.pgRegAvailableTip".tr();

  String get pgRegUnavailableTip => "$ns.pgRegUnavailableTip".tr();

  String get campusNetworkConnected => "$ns.campusNetworkConnected".tr();

  String get campusNetworkNotConnected => "$ns.campusNetworkNotConnected".tr();

  String get troubleshoot => "$ns.troubleshoot".tr();

  String get studentRegTroubleshoot => "$ns.studentRegTroubleshoot".tr();

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

class _NetworkCheckerI18n {
  const _NetworkCheckerI18n();

  static const ns = "networkChecker";

  final button = const _NetworkCheckerButton();
  final status = const _NetworkCheckerStatus();

  String get testConnection => "$ns.testConnection.title".tr();

  String testConnectionDesc(WhereToCheck where) => "$ns.testConnection.desc".tr(namedArgs: {
        "where": where.l10n(),
      });
}

class _NetworkCheckerButton {
  final String ns = "${_NetworkCheckerI18n.ns}.button";

  const _NetworkCheckerButton();

  String get connected => "$ns.connected".tr();

  String get connecting => "$ns.connecting".tr();

  String get disconnected => "$ns.disconnected".tr();

  String get none => "$ns.none".tr();
}

class _NetworkCheckerStatus {
  final String ns = "${_NetworkCheckerI18n.ns}.status";

  const _NetworkCheckerStatus();

  String connected(WhereToCheck where) => "$ns.connected".tr(namedArgs: {
        "where": where.l10n(),
      });

  String connecting(WhereToCheck where) => "$ns.connecting".tr();

  String disconnected(WhereToCheck where) => "$ns.disconnected".tr(namedArgs: {
        "where": where.l10n(),
      });

  String none(WhereToCheck where) => "$ns.none".tr(namedArgs: {
        "where": where.l10n(),
      });
}

extension WhereToCheckI18nX on WhereToCheck {
  String l10n() => "${_NetworkCheckerI18n.ns}.whereToCheck.$name".tr();
}
