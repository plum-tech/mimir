import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sit/settings/settings.dart';
import 'package:rettulf/rettulf.dart';

import '../service/network.dart';
import '../utils.dart';
import '../widgets/status.dart';
import '../i18n.dart';

class ConnectedInfo extends StatefulWidget {
  const ConnectedInfo({super.key});

  @override
  State<ConnectedInfo> createState() => _ConnectedInfoState();
}

class _ConnectedInfoState extends State<ConnectedInfo> {
  ConnectivityStatus? connectivityStatus;
  CampusNetworkStatus? campusNetworkStatus;
  late StreamSubscription<ConnectivityStatus> connectivityChecker;
  late StreamSubscription<CampusNetworkStatus?> campusNetworkChecker;

  @override
  void initState() {
    super.initState();
    connectivityChecker = checkConnectivityPeriodic(period: const Duration(milliseconds: 500)).listen((status) {
      if (connectivityStatus != status) {
        if (!mounted) return;
        setState(() {
          connectivityStatus = status;
        });
      }
    });
    campusNetworkChecker = checkPeriodic(
      period: const Duration(milliseconds: 2000),
      check: () async {
        return await Network.checkCampusNetworkStatus();
      },
    ).listen((status) {
      if (campusNetworkStatus != status) {
        if (!mounted) return;
        setState(() {
          campusNetworkStatus = status;
        });
      }
    });
  }

  @override
  void dispose() {
    connectivityChecker.cancel();
    campusNetworkChecker.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final useProxy = Settings.proxy.anyEnabled;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: [
        Icon(
          useProxy ? Icons.vpn_key : getConnectionTypeIcon(connectivityStatus),
          size: 120,
        ).expanded(flex: 5),
        buildTip().expanded(flex: 3),
      ].column(caa: CrossAxisAlignment.stretch, key: ValueKey(connectivityStatus)),
    ).padAll(10);
  }

  Widget buildTip() {
    final style = context.textTheme.bodyLarge;
    final tip = connectivityStatus?.vpnEnabled == true
        ? i18n.connectedByVpn
        : switch (connectivityStatus?.type) {
            ConnectivityType.wifi => i18n.connectedByWlan,
            ConnectivityType.ethernet => i18n.connectedByEthernet,
            _ => null,
          };
    if (tip == null) return const SizedBox(height: 10);
    return [
      tip.text(textAlign: TextAlign.center, style: style),
      CampusNetworkStatusInfo(status: campusNetworkStatus),
    ].column().padH(20);
  }
}
