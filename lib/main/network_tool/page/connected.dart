import 'dart:async';

import 'package:check_vpn_connection/check_vpn_connection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:mimir/design/widgets/connectivity_checker.dart';
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
  late Timer networkChecker;
  CampusNetworkStatus? status;

  @override
  void initState() {
    super.initState();
    networkChecker =
        Timer.periodic(const Duration(milliseconds: 500), (Timer t) async {
      var type = await Connectivity().checkConnectivity();
      if (type == ConnectivityResult.wifi ||
          type == ConnectivityResult.ethernet) {
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
    Network.checkCampusNetworkStatus().then((status) {
      setState(() {
        this.status = status;
      });
    }).onError((error, stackTrace) {
      setState(() {
        status = null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final useProxy = Kv.network.useProxy;
    final icon =
        useProxy ? Icons.vpn_key : getConnectionTypeIcon(connectionType);
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
        '${i18n.network.ipAddress}：${Kv.network.proxy}',
        textAlign: TextAlign.center,
        style: style,
      );
    }
    final status = this.status;
    var ip = i18n.unknown;
    var studentId = i18n.unknown;
    if (status != null) {
      ip = status.ip;
      studentId = status.studentId ?? i18n.login.notLoggedIn;
    }
    final tip = _getTipByConnectionType(connectionType);
    if (tip == null) return Container().padH(10);
    return "$tip\n"
            "${i18n.credential.studentId}: $studentId\n"
            "${i18n.network.ipAddress}: $ip"
        .text(
          textAlign: TextAlign.center,
          style: style,
        )
        .padH(20);
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
