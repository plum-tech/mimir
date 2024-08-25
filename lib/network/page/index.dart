import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sit/credentials/entity/user_type.dart';
import 'package:sit/credentials/init.dart';
import 'package:sit/design/animation/animated.dart';
import 'package:sit/design/widgets/icon.dart';
import 'package:sit/init.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/network/service/network.dart';
import 'package:sit/network/widgets/buttons.dart';
import 'package:sit/settings/dev.dart';
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
    if (Dev.on) {
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
  }

  @override
  void dispose() {
    connectivityChecker.cancel();
    studentRegChecker.cancel();
    campusNetworkChecker.cancel();
    schoolServerChecker.cancel();
    if (Dev.on) ywbChecker.cancel();
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
                i18n.studentRegUnavailableButCampusNetworkConnected.text(
                  style: context.textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              if (studentRegAvailable == false)
                [
                  i18n.troubleshoot.text(style: context.textTheme.titleMedium),
                  i18n.studentRegTroubleshoot.text(
                    style: context.textTheme.bodyMedium,
                  )
                ].column(),
              if (Dev.on)
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
    final widgets = <Widget>[];
    final connected = this.connected;
    final textTheme = context.textTheme;
    widgets.add((switch (connected) {
      null => i18n.connecting,
      true => i18n.schoolServerAvailable,
      false => i18n.schoolServerUnavailable,
    })
        .text(
      style: textTheme.titleMedium,
    ));
    Widget buildTip(String tip) {
      return tip.text(
        textAlign: TextAlign.center,
        style: textTheme.bodyMedium,
      );
    }

    switch (connected) {
      case true:
        widgets.add(buildTip(i18n.schoolServerAvailableTip));
      case false:
        widgets.add(buildTip(i18n.schoolServerUnavailableTip));
      case null:
    }
    return widgets.column(caa: CrossAxisAlignment.center);
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
    final widgets = <Widget>[];
    final connected = this.connected;
    final textTheme = context.textTheme;
    widgets.add((switch (connected) {
      null => i18n.connecting,
      true => i18n.ywbAvailable,
      false => i18n.ywbUnavailable,
    })
        .text(
      style: textTheme.titleMedium,
    ));
    Widget buildTip(String tip) {
      return tip.text(
        textAlign: TextAlign.center,
        style: textTheme.bodyMedium,
      );
    }

    switch (connected) {
      case true:
        widgets.add(buildTip(i18n.ywbAvailableTip));
      case false:
        widgets.add(buildTip(i18n.ywbUnavailableTip));
      case null:
    }
    return widgets.column(caa: CrossAxisAlignment.center);
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
    final connected = this.connected;
    final textTheme = context.textTheme;
    widgets.add((switch (connected) {
      null => i18n.connecting,
      true => i18n.studentRegAvailable,
      false => i18n.studentRegUnavailable,
    })
        .text(
      style: textTheme.titleMedium,
    ));
    Widget buildTip(String tip) {
      return tip.text(
        textAlign: TextAlign.center,
        style: textTheme.bodyMedium,
      );
    }

    switch (connected) {
      case true:
        if (userType == OaUserType.undergraduate) {
          widgets.add(buildTip(i18n.ugRegAvailableTip));
        } else if (userType == OaUserType.postgraduate) {
          widgets.add(buildTip(i18n.pgRegAvailableTip));
        }
      case false:
        if (userType == OaUserType.undergraduate) {
          widgets.add(buildTip(i18n.ugRegUnavailableTip));
        } else if (userType == OaUserType.postgraduate) {
          widgets.add(buildTip(i18n.pgRegUnavailableTip));
        }
      case null:
    }
    return widgets.column(caa: CrossAxisAlignment.center);
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
        style: context.textTheme.titleMedium,
      ),
      if (studentId != null) "${i18n.credentials.studentId}: $studentId".text(style: style),
      if (ip != null) "${i18n.network.ipAddress}: $ip".text(style: style),
    ].column(caa: CrossAxisAlignment.center);
  }
}
