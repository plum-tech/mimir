import 'package:easy_localization/easy_localization.dart';
import 'package:mimir/credential/i18n.dart';
import 'package:mimir/l10n/common.dart';

const i18n = _I18n();

class _I18n with CommonI18nMixin {
  const _I18n();

  static const ns = "networkTool";
  final easyconnect = const _Easyconnect();
  final network = const NetworkI18n();
  final credential = const CredentialI18n();

  String get title => "$ns.title".tr();

  String get openWlanSettingsBtn => "$ns.openWlanSettingsBtn".tr();

  String get noAccessTip => "$ns.noAccessTip".tr();

  String get connectionFailedError => "$ns.connectionFailedError".tr();

  String get connectionFailedButCampusNetworkConnected => "$ns.connectionFailedButCampusNetworkConnected".tr();

  String get connectedByProxy => "$ns.connectedByProxy".tr();

  String get connectedByVpn => "$ns.connectedByVpn".tr();

  String get connectedByWlan => "$ns.connectedByWlan".tr();

  String get connectedByEthernet => "$ns.connectedByEthernet".tr();
}

class _Easyconnect {
  const _Easyconnect();

  static const ns = "easyconnect";

  String get launchBtn => "$ns.launchBtn".tr();

  String get launchFailed => "$ns.launchFailed".tr();

  String get launchFailedDesc => "$ns.launchFailedDesc".tr();
}
