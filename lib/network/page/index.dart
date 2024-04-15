import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sit/init.dart';
import 'package:rettulf/rettulf.dart';
import '../utils.dart';
import 'connected.dart';
import 'disconnected.dart';

import '../i18n.dart';

class NetworkToolPage extends StatefulWidget {
  const NetworkToolPage({super.key});

  @override
  State<NetworkToolPage> createState() => _NetworkToolPageState();
}

class _NetworkToolPageState extends State<NetworkToolPage> {
  bool? isConnected;
  late StreamSubscription<bool> connectivityChecker;

  @override
  void initState() {
    super.initState();
    connectivityChecker = checkPeriodic(
      period: const Duration(milliseconds: 3000),
      check: () async {
        try {
          return await Init.jwxtSession.checkConnectivity();
        } catch (err) {
          return false;
        }
      },
    ).listen((connected) {
      if (isConnected != connected) {
        setState(() {
          isConnected = connected;
        });
      }
    });
  }

  @override
  void dispose() {
    connectivityChecker.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: i18n.title.text(),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: switch (isConnected) {
          true => const ConnectedInfo(key: ValueKey("Connected")),
          false => const DisconnectedInfo(key: ValueKey("Disconnected")),
          null => const SizedBox(key: ValueKey("null")),
        },
      ),
      bottomNavigationBar: const PreferredSize(
        preferredSize: Size.fromHeight(4),
        child: LinearProgressIndicator(),
      ),
    );
  }
}
