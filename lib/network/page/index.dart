import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sit/credentials/entity/user_type.dart';
import 'package:sit/credentials/init.dart';
import 'package:sit/init.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/network/service/network.dart';
import '../utils.dart';

import '../i18n.dart';

class NetworkToolPage extends StatefulWidget {
  const NetworkToolPage({super.key});

  @override
  State<NetworkToolPage> createState() => _NetworkToolPageState();
}

class _NetworkToolPageState extends State<NetworkToolPage> {
  bool? studentRegAvailable;
  CampusNetworkStatus? campusNetworkStatus;
  ConnectivityStatus? connectivityStatus;
  late StreamSubscription<bool> studentRegChecker;
  late StreamSubscription<ConnectivityStatus> connectivityChecker;
  late StreamSubscription<CampusNetworkStatus?> campusNetworkChecker;

  @override
  void initState() {
    super.initState();
    connectivityChecker = checkConnectivityPeriodic(
      period: const Duration(milliseconds: 100000),
    ).listen((status) {
      if (connectivityStatus != status) {
        if (!mounted) return;
        setState(() {
          connectivityStatus = status;
        });
      }
    });
    studentRegChecker = checkPeriodic(
      period: const Duration(milliseconds: 500000),
      check: () async {
        try {
          return await Init.ugRegSession.checkConnectivity();
        } catch (err) {
          return false;
        }
      },
    ).listen((connected) {
      if (studentRegAvailable != connected) {
        setState(() {
          studentRegAvailable = connected;
        });
      }
    });
    campusNetworkChecker = checkPeriodic(
      period: const Duration(milliseconds: 300000),
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
    studentRegChecker.cancel();
    campusNetworkChecker.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            title: i18n.title.text(),
            // bottom: const PreferredSize(
            //   preferredSize: Size.fromHeight(4),
            //   child: LinearProgressIndicator(),
            // ),
            actions: [],
          ),
          SliverList.list(
            children: [
              ConnectivityInfo(
                status: connectivityStatus,
              ),
              CampusNetworkConnectivityInfo(
                status: campusNetworkStatus,
                useVpn: connectivityStatus?.vpnEnabled == true,
              ),
              StudentRegConnectivityInfo(
                connected: studentRegAvailable,
              ),
            ],
          )
        ],
      ),
    );
  }
}

class ConnectivityInfo extends StatelessWidget {
  final ConnectivityStatus? status;

  const ConnectivityInfo({
    required this.status,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      child: [
        Icon(
          status?.vpnEnabled == true ? Icons.vpn_key : getConnectionTypeIcon(status),
          size: 120,
        ),
      ].column(caa: CrossAxisAlignment.center),
    );
  }
}

class StudentRegConnectivityInfo extends ConsumerWidget {
  final bool? connected;

  const StudentRegConnectivityInfo({
    super.key,
    required this.connected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userType = ref.watch(CredentialsInit.storage.$oaUserType);
    final widgets = <Widget>[];
    final connected = this.connected == true;
    widgets.add((connected ? i18n.studentRegAvailable : i18n.studentRegUnavailable).text());
    if (connected) {
      if (userType == OaUserType.undergraduate) {
        widgets.add(i18n.ugRegAvailableTip.text());
      } else if (userType == OaUserType.postgraduate) {
        widgets.add(i18n.pgRegAvailableTip.text());
      }
    } else {
      if (userType == OaUserType.undergraduate) {
        widgets.add(i18n.ugRegUnavailableTip.text());
      } else if (userType == OaUserType.postgraduate) {
        widgets.add(i18n.pgRegUnavailableTip.text());
      }
    }
    return Card.outlined(
      child: widgets.column(caa: CrossAxisAlignment.center),
    );
  }
}

class CampusNetworkConnectivityInfo extends StatelessWidget {
  final CampusNetworkStatus? status;
  final bool useVpn;

  const CampusNetworkConnectivityInfo({
    super.key,
    this.status,
    required this.useVpn,
  });

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      child: buildTip(context),
    );
  }

  Widget buildTip(BuildContext context) {
    final style = context.textTheme.bodyLarge;
    final status = this.status;
    var ip = i18n.unknown;
    var studentId = i18n.unknown;
    if (status != null) {
      ip = status.ip;
      studentId = status.studentId ?? i18n.unknown;
    }
    return [
      i18n.campusNetworkConnected.text(style: style),
      if (useVpn) i18n.campusNetworkConnectedByVpn.text(),
      "${i18n.credentials.studentId}: $studentId".text(style: style),
      "${i18n.network.ipAddress}: $ip".text(style: style),
    ].column(caa: CrossAxisAlignment.center);
  }
}
