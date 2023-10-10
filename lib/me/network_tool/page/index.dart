import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sit/utils/timer.dart';
import 'package:rettulf/rettulf.dart';
import '../init.dart';
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
  late Timer connectivityChecker;

  @override
  void initState() {
    super.initState();
    // FIXME: Bad practice to use periodically, because the next request will not await the former one.
    connectivityChecker = runPeriodically(const Duration(milliseconds: 3000), (Timer t) async {
      bool connected;
      try {
        connected = await ConnectivityInit.ssoSession.checkConnectivity();
      } catch (err) {
        connected = false;
      }
      if (!mounted) return;
      if (isConnected != connected) {
        setState(() => isConnected = connected);
      }
      // if (connected) {
      //   // if connected, check the connection slowly
      //   await Future.delayed(const Duration(seconds: 3));
      // } else {
      //   // if not connected, check the connection frequently
      //   await Future.delayed(const Duration(seconds: 1));
      // }
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
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(4),
          child: LinearProgressIndicator(),
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: switch (isConnected) {
          true => const ConnectedInfo(key: ValueKey("Connected")),
          false => const DisconnectedInfo(key: ValueKey("Disconnected")),
          null => const SizedBox(key: ValueKey("null")),
        },
      ),
    );
  }
}
