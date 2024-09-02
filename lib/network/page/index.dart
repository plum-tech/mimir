import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mimir/design/animation/animated.dart';
import 'package:mimir/design/widgets/icon.dart';
import 'package:mimir/init.dart';
import 'package:mimir/widgets/markdown.dart';
import 'package:rettulf/rettulf.dart';
import 'package:mimir/network/service/network.dart';
import 'package:mimir/network/widgets/buttons.dart';

import '../connectivity.dart';

import '../i18n.dart';
import '../utils.dart';

class NetworkToolPage extends StatefulWidget {
  const NetworkToolPage({super.key});

  @override
  State<NetworkToolPage> createState() => _NetworkToolPageState();
}

class _NetworkToolPageState extends State<NetworkToolPage> {
  bool? studentRegAvailable;
  bool? schoolServerAvailable;
  bool? ywbAvailable;
  CampusNetworkStatus? campusNetworkStatus;
  ConnectivityStatus? connectivityStatus;
  late StreamSubscription<bool> studentRegChecker;
  late StreamSubscription<bool> schoolServerChecker;
  late StreamSubscription<bool> ywbChecker;
  late StreamSubscription<ConnectivityStatus> connectivityChecker;
  late StreamSubscription<CampusNetworkStatus?> campusNetworkChecker;

  @override
  void initState() {
    super.initState();
    connectivityChecker = checkPeriodic(
      period: const Duration(milliseconds: 1000),
      check: () => checkConnectivityWithProxySettings(schoolNetwork: true),
    ).listen((status) {
      if (connectivityStatus != status) {
        if (!mounted) return;
        setState(() {
          connectivityStatus = status;
        });
      }
    });
    studentRegChecker = checkPeriodic(
      period: const Duration(milliseconds: 8000),
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
    schoolServerChecker = checkPeriodic(
      period: const Duration(milliseconds: 4000),
      check: () async {
        try {
          return await Init.ssoSession.checkConnectivity();
        } catch (err) {
          return false;
        }
      },
    ).listen((connected) {
      if (schoolServerAvailable != connected) {
        setState(() {
          schoolServerAvailable = connected;
        });
      }
    });
    ywbChecker = checkPeriodic(
      period: const Duration(milliseconds: 4000),
      check: () async {
        try {
          return await Init.ywbSession.checkConnectivity();
        } catch (err) {
          return false;
        }
      },
    ).listen((connected) {
      if (ywbAvailable != connected) {
        setState(() {
          ywbAvailable = connected;
        });
      }
    });
  }

  @override
  void dispose() {
    connectivityChecker.cancel();
    studentRegChecker.cancel();
    campusNetworkChecker.cancel();
    schoolServerChecker.cancel();
    ywbChecker.cancel();
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
              ),
              CampusNetworkConnectivityInfo(
                status: campusNetworkStatus,
              ),
              SchoolServerConnectivityInfo(
                connected: schoolServerAvailable,
              ),
              StudentRegConnectivityInfo(
                connected: studentRegAvailable,
              ),
              if (studentRegAvailable == false && campusNetworkStatus != null)
                FeaturedMarkdownWidget(data: i18n.studentRegUnavailableButCampusNetworkConnected),
              if (studentRegAvailable == false) FeaturedMarkdownWidget(data: i18n.studentRegTroubleshoot),
              YwbServerConnectivityInfo(
                connected: ywbAvailable,
              ),
            ].map((widget) {
              return widget.padSymmetric(v: 16, h: 8).inOutlinedCard().animatedSized();
            }).toList(),
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
            OpenInAppProxyButton(),
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
      DualIcon(
        primary: status == null ? Icons.public_off : getConnectionTypeIcon(status, ignoreVpn: true),
        secondary: status?.vpnEnabled == true ? Icons.vpn_key : null,
        size: 120,
      ),
    ].column(caa: CrossAxisAlignment.center);
  }
}

class SchoolServerConnectivityInfo extends ConsumerWidget {
  final bool? connected;

  const SchoolServerConnectivityInfo({
    super.key,
    required this.connected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connected = this.connected;
    return switch (connected) {
      null => i18n.connecting.text(textAlign: TextAlign.center),
      true => FeaturedMarkdownWidget(data: i18n.schoolServerAvailable),
      false => FeaturedMarkdownWidget(data: i18n.schoolServerUnavailable),
    };
  }
}

class YwbServerConnectivityInfo extends ConsumerWidget {
  final bool? connected;

  const YwbServerConnectivityInfo({
    super.key,
    required this.connected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connected = this.connected;
    return switch (connected) {
      null => i18n.connecting.text(textAlign: TextAlign.center),
      true => FeaturedMarkdownWidget(data: i18n.ywbAvailable),
      false => FeaturedMarkdownWidget(data: i18n.ywbUnavailable),
    };
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
    final connected = this.connected;
    return switch (connected) {
      null => i18n.connecting.text(textAlign: TextAlign.center),
      true => FeaturedMarkdownWidget(data: i18n.studentRegAvailable),
      false => FeaturedMarkdownWidget(data: i18n.studentRegUnavailable),
    };
  }
}

class CampusNetworkConnectivityInfo extends StatelessWidget {
  final CampusNetworkStatus? status;

  const CampusNetworkConnectivityInfo({
    super.key,
    this.status,
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
      (status == null ? i18n.campusNetworkNotConnected : i18n.campusNetworkConnected).text(
        style: context.textTheme.titleLarge,
      ),
      if (studentId != null) "${i18n.credentials.studentId}: $studentId".text(style: style),
      if (ip != null) "${i18n.network.ipAddress}: $ip".text(style: style),
    ].column(caa: CrossAxisAlignment.center);
  }
}
