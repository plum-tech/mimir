import 'dart:async';

import 'package:check_vpn_connection/check_vpn_connection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:mimir/design/widgets/connectivity_checker.dart';
import 'package:mimir/main/network_tool/widgets/status.dart';
import 'package:rettulf/rettulf.dart';

import '../service/network.dart';
import '../using.dart';

class ConnectedInfoPage extends StatefulWidget {
  const ConnectedInfoPage({super.key});

  @override
  State<ConnectedInfoPage> createState() => _ConnectedInfoPageState();
}

class _ConnectedInfoPageState extends State<ConnectedInfoPage> {
  ConnectivityResult? connectionType;
  late Timer connectionTypeChecker;
  late Timer statusChecker;
  CampusNetworkStatus? status;

  @override
  void initState() {
    super.initState();
    connectionTypeChecker = Timer.periodic(const Duration(milliseconds: 500), (Timer t) async {
      var type = await Connectivity().checkConnectivity();
      if (type == ConnectivityResult.wifi || type == ConnectivityResult.ethernet) {
        if (await CheckVpnConnection.isVpnActive()) {
          type = ConnectivityResult.vpn;
        }
      }
      if (connectionType != type) {
        if (!mounted) return;
        setState(() {
          connectionType = type;
        });
      }
    });
    statusChecker = Timer.periodic(const Duration(milliseconds: 1000), (Timer t) async {
      final status = await Network.checkCampusNetworkStatus();
      if (this.status != status) {
        if (!mounted) return;
        setState(() {
          this.status = status;
        });
      }
    });
  }

  @override
  void dispose() {
    connectionTypeChecker.cancel();
    statusChecker.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final useProxy = Settings.useProxy;
    final icon = useProxy ? Icons.vpn_key : getConnectionTypeIcon(connectionType);
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: [
        Icon(icon, size: 120).expanded(flex: 5),
        buildTip(useProxy).expanded(flex: 3),
      ].column(caa: CAAlign.stretch, key: ValueKey(connectionType)),
    ).padAll(10);
  }

  Widget buildTip(bool useProxy) {
    final style = context.textTheme.bodyLarge;
    if (useProxy) {
      return Text(
        '${i18n.connectedByVpn}\n'
        '${i18n.network.ipAddress}：${Settings.proxy}',
        textAlign: TextAlign.center,
        style: style,
      );
    }
    final tip = _getTipByConnectionType(connectionType);
    if (tip == null) return const SizedBox(height: 10);
    return [
      tip.text(textAlign: TextAlign.center, style: style),
      CampusNetworkStatusInfo(status: status),
    ].column().padH(20);
  }
}

String? _getTipByConnectionType(ConnectivityResult? result) {
  switch (result) {
    case ConnectivityResult.wifi:
      return i18n.connectedByWlan;
    case ConnectivityResult.ethernet:
      return i18n.connectedByEthernet;
    case ConnectivityResult.vpn:
      return i18n.connectedByVpn;
    default:
      return null;
  }
}
