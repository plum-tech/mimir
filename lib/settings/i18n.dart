import 'package:easy_localization/easy_localization.dart';
import 'package:sit/credentials/i18n.dart';
import 'package:sit/l10n/app.dart';
import 'package:sit/l10n/common.dart';
import 'package:sit/settings/entity/proxy.dart';

const i18n = _I18n();

class _I18n with CommonI18nMixin {
  const _I18n();

  final oaCredentials = const _OaCredentials();
  final proxy = const _Proxy();
  final dev = const _DevOptions();
  final about = const _About();
  final app = const AppI18n();

  static const ns = "settings";

  String get title => "$ns.title".tr();

  String get language => "$ns.language".tr();

  String get themeColor => "$ns.themeColor".tr();

  String get fromSystem => "$ns.fromSystem".tr();

  String get themeModeTitle => "$ns.themeMode.title".tr();

  String get clearCacheTitle => "$ns.clearCache.title".tr();

  String get clearCacheDesc => "$ns.clearCache.desc".tr();

  String get clearCacheRequest => "$ns.clearCache.request".tr();

  String get wipeDataTitle => "$ns.wipeData.title".tr();

  String get wipeDataDesc => "$ns.wipeData.desc".tr();

  String get wipeDataRequest => "$ns.wipeData.request".tr();

  String get wipeDataRequestDesc => "$ns.wipeData.requestDesc".tr();
}

class _Proxy {
  const _Proxy();

  static const ns = "${_I18n.ns}.proxy";

  String get title => "$ns.title".tr();

  String get desc => "$ns.desc".tr();

  String get enableProxy => "$ns.enableProxy.title".tr();

  String get enableProxyDesc => "$ns.enableProxy.desc".tr();

  String get proxyMode => "$ns.proxyMode.title".tr();

  String get shareQrCode => "$ns.shareQrCode.title".tr();

  String get shareQrCodeDesc => "$ns.shareQrCode.desc".tr();

  String get protocol => "$ns.protocol".tr();

  String get hostname => "$ns.hostname".tr();

  String get port => "$ns.port".tr();

  String get enableAuth => "$ns.enableAuth".tr();

  String get authentication => "$ns.authentication".tr();

  String get username => "$ns.username".tr();

  String get password => "$ns.password".tr();

  String get invalidProxyFormatTip => "$ns.invalidProxyFormatTip".tr();

  String get setFromQrCodeAction => "$ns.setFromQrCodeAction".tr();

  String get setFromQrCodeDesc => "$ns.setFromQrCodeDesc".tr();
}

class _About {
  const _About();

  static const ns = "${_I18n.ns}.about";

  String get title => "$ns.title".tr();

  String get version => "$ns.version".tr();

  String get icpLicense => "$ns.icpLicense".tr();

  String get termsOfUse => "$ns.termsOfUse".tr();

  String get privacyPolicy => "$ns.privacyPolicy".tr();

  String get checkUpdate => "$ns.checkUpdate".tr();
}

class _DevOptions {
  const _DevOptions();

  final storage = const _Storage();

  static const ns = "${_I18n.ns}.dev";

  String get title => "$ns.title".tr();

  String get devMode => "$ns.devMode.title".tr();

  String get demoMode => "$ns.demoMode.title".tr();

  String get devModeActivateTip => "$ns.activateTip".tr();

  String get reload => "$ns.reload.title".tr();

  String get reloadDesc => "$ns.reload.desc".tr();

  String get localStorage => "$ns.localStorage.title".tr();

  String get localStorageDesc => "$ns.localStorage.desc".tr();
}

class _Storage with CommonI18nMixin {
  const _Storage();

  static const ns = "${_DevOptions.ns}.localStorage";

  String get title => "$ns.title".tr();

  String get selectBoxTip => "$ns.selectBoxTip".tr();

  String get clearBoxDesc => "$ns.clearBoxDesc".tr();

  String get deleteItemDesc => "$ns.deleteItemDesc".tr();

  String get emptyValueDesc => "$ns.emptyValueDesc".tr();
}

class _OaCredentials extends OaCredentialsI18n {
  static const ns = "${_I18n.ns}.credentials";

  const _OaCredentials();

  String get testLoginOa => "$ns.testLoginOa.title".tr();

  String get testLoginOaDesc => "$ns.testLoginOa.desc".tr();
}

extension ProxyTypeI18nX on ProxyCat {
  String l10n() => "settings.proxy.proxyType.$name".tr();
}

extension ProxyModeI18nX on ProxyMode {
  String l10nName() => "settings.proxy.proxyMode.$name.name".tr();

  String l10nTip() => "settings.proxy.proxyMode.$name.tip".tr();
}
