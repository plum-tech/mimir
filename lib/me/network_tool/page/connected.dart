import 'dart:async';

import 'package:check_vpn_connection/check_vpn_connection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:mimir/design/widgets/connectivity_checker.dart';
import 'package:mimir/settings/settings.dart';
import 'package:mimir/utils/timer.dart';
import 'package:rettulf/rettulf.dart';

import '../service/network.dart';
import '../widgets/status.dart';
import '../i18n.dart';

class ConnectedInfo extends StatefulWidget {
  const ConnectedInfo({super.key});

  @override
  State<ConnectedInfo> createState() => _ConnectedInfoState();
}

class _ConnectedInfoState extends State<ConnectedInfo> {
  ConnectivityResult? connectionType;
  late Timer connectionTypeChecker;
  late Timer statusChecker;
  CampusNetworkStatus? status;

  @override
  void initState() {
    super.initState();
    connectionTypeChecker = runPeriodically(const Duration(milliseconds: 500), (Timer t) async {
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
    statusChecker = runPeriodically(const Duration(milliseconds: 1000), (Timer t) async {
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
    final tip = switch (connectionType) {
      ConnectivityResult.wifi => i18n.connectedByWlan,
      ConnectivityResult.ethernet => i18n.connectedByEthernet,
      ConnectivityResult.vpn => i18n.connectedByVpn,
      _ => null,
    };
    if (tip == null) return const SizedBox(height: 10);
    return [
      tip.text(textAlign: TextAlign.center, style: style),
      CampusNetworkStatusInfo(status: status),
    ].column().padH(20);
  }
}
