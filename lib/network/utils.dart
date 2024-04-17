import 'package:sit/settings/settings.dart';

import 'connectivity.dart';

Future<ConnectivityStatus> checkConnectivityWithProxySettings({
  required bool schoolNetwork,
}) async {
  final status = await checkConnectivity();
  final proxyEnabled = Settings.proxy.anyEnabled;
  if (!proxyEnabled) return status;

  final schoolNetworkProxy = Settings.proxy.hasAnyProxyMode(ProxyMode.schoolOnly);
  final globalProxy = Settings.proxy.hasAnyProxyMode(ProxyMode.global);
  var vpnEnabled = status.vpnEnabled;
  if (!schoolNetwork && globalProxy) {
    vpnEnabled |= true;
  }
  if (schoolNetwork && (schoolNetworkProxy || globalProxy)) {
    vpnEnabled |= true;
  }
  return status.copyWith(
    vpnEnabled: vpnEnabled,
  );
}
