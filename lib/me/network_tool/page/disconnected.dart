import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mimir/utils/timer.dart';
import 'package:rettulf/rettulf.dart';

import '../service/network.dart';
import '../widgets/quick_button.dart';
import '../widgets/status.dart';
import '../i18n.dart';

class DisconnectedInfo extends StatefulWidget {
  const DisconnectedInfo({super.key});

  @override
  State<DisconnectedInfo> createState() => _DisconnectedInfoState();
}

class _DisconnectedInfoState extends State<DisconnectedInfo> {
  CampusNetworkStatus? status;
  late Timer statusChecker;

  @override
  void initState() {
    super.initState();
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
    statusChecker.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return context.isPortrait ? buildPortrait() : buildLandscape();
  }

  Widget buildPortrait() {
    return [
      const Icon(Icons.public_off_outlined, size: 120).expanded(),
      [
        buildTip(context),
        if (status != null) CampusNetworkStatusInfo(status: status),
      ].column().expanded(),
      const QuickButtons(),
    ].column(caa: CAAlign.stretch).padAll(10);
  }

  Widget buildLandscape() {
    return [
      [
        const Icon(Icons.public_off_outlined, size: 120),
        const QuickButtons(),
      ].column(maa: MainAxisAlignment.spaceEvenly).expanded(),
      [
        buildTip(context),
        if (status != null) CampusNetworkStatusInfo(status: status),
      ].column().padAll(10).scrolled().expanded(),
    ].row();
  }

  Widget buildTip(BuildContext context) {
    return Text(
      status != null ? i18n.connectionFailedButCampusNetworkConnected : i18n.connectionFailedError,
      textAlign: TextAlign.start,
      style: context.textTheme.bodyLarge,
    ).padH(20);
  }
}
