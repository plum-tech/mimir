import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sit/credentials/entity/user_type.dart';
import 'package:sit/credentials/init.dart';
import 'package:sit/design/animation/animated.dart';
import 'package:sit/design/widgets/card.dart';
import 'package:sit/init.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/network/service/network.dart';
import 'package:sit/network/widgets/buttons.dart';
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
      period: const Duration(milliseconds: 1000),
    ).listen((status) {
      if (connectivityStatus != status) {
        if (!mounted) return;
        setState(() {
          connectivityStatus = status;
        });
      }
    });
    studentRegChecker = checkPeriodic(
      period: const Duration(milliseconds: 5000),
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
      period: const Duration(milliseconds: 3000),
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
            title: [
              i18n.title.text(),
              const CircularProgressIndicator.adaptive().sizedAll(16),
            ].wrap(caa: WrapCrossAlignment.center, spacing: 16),
          ),
          SliverList.list(
            children: [
              ConnectivityInfo(
                status: connectivityStatus,
              ).padSymmetric(v: 16, h: 8).inOutlinedCard().animatedSized(),
              CampusNetworkConnectivityInfo(
                status: campusNetworkStatus,
                useVpn: connectivityStatus?.vpnEnabled == true,
              ).padSymmetric(v: 16, h: 8).inOutlinedCard().animatedSized(),
              StudentRegConnectivityInfo(
                connected: studentRegAvailable,
              ).padSymmetric(v: 16, h: 8).inOutlinedCard().animatedSized(),
              if (studentRegAvailable == false && campusNetworkStatus != null)
                i18n.studentRegUnavailableButCampusNetworkConnected
                    .text(
                      style: context.textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    )
                    .padSymmetric(v: 16, h: 8)
                    .inOutlinedCard(),
              if (studentRegAvailable == false)
                [
                  i18n.troubleshooting.text(style: context.textTheme.titleMedium),
                  i18n.studentRegTroubleshooting.text(
                    style: context.textTheme.bodyMedium,
                  )
                ].column().padSymmetric(v: 16, h: 8).inOutlinedCard(),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
          children: const [
            LaunchEasyConnectButton(),
            SizedBox(width: 8),
            OpenWifiSettingsButton(),
          ],
        ),
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
    final status = this.status;
    return [
      Icon(
        status == null
            ? Icons.public_off
            : status.vpnEnabled
                ? Icons.vpn_key
                : getConnectionTypeIcon(status),
        size: 120,
      ),
    ].column(caa: CrossAxisAlignment.center);
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
    final connected = this.connected != false;
    final textTheme = context.textTheme;
    widgets.add((connected ? i18n.studentRegAvailable : i18n.studentRegUnavailable).text(
      style: textTheme.titleMedium,
    ));
    Widget buildTip(String tip) {
      return tip.text(
        textAlign: TextAlign.center,
        style: textTheme.bodyMedium,
      );
    }

    if (connected) {
      if (userType == OaUserType.undergraduate) {
        widgets.add(buildTip(i18n.ugRegAvailableTip));
      } else if (userType == OaUserType.postgraduate) {
        widgets.add(buildTip(i18n.pgRegAvailableTip));
      }
    } else {
      if (userType == OaUserType.undergraduate) {
        widgets.add(buildTip(i18n.ugRegUnavailableTip));
      } else if (userType == OaUserType.postgraduate) {
        widgets.add(buildTip(i18n.pgRegUnavailableTip));
      }
    }
    return widgets.column(caa: CrossAxisAlignment.center);
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
    final style = context.textTheme.bodyMedium;
    final status = this.status;
    String? ip;
    String? studentId;
    if (status != null) {
      ip = status.ip;
      studentId = status.studentId ?? i18n.unknown;
    }
    return [
      (status == null
              ? i18n.campusNetworkNotConnected
              : useVpn
                  ? i18n.campusNetworkConnectedByVpn
                  : i18n.campusNetworkConnected)
          .text(
        style: context.textTheme.titleMedium,
      ),
      if (studentId != null) "${i18n.credentials.studentId}: $studentId".text(style: style),
      if (ip != null) "${i18n.network.ipAddress}: $ip".text(style: style),
    ].column(caa: CrossAxisAlignment.center);
  }
}
