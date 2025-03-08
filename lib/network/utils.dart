import 'connectivity.dart';

Future<ConnectivityStatus> checkConnectivityWithProxySettings({
  required bool schoolNetwork,
}) async {
  final status = await checkConnectivity();
  var vpnEnabled = status.vpnEnabled;
  return status.copyWith(
    vpnEnabled: vpnEnabled,
  );
}
