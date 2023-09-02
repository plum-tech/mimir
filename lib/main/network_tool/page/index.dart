import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rettulf/rettulf.dart';
import '../init.dart';
import 'connected.dart';
import 'disconnected.dart';
import '../using.dart';

class NetworkToolPage extends StatefulWidget {
  final Widget? leading;

  const NetworkToolPage({super.key, this.leading});

  @override
  State<NetworkToolPage> createState() => _NetworkToolPageState();
}

class _NetworkToolPageState extends State<NetworkToolPage> {
  bool isConnected = false;
  late Timer connectivityChecker;

  @override
  void initState() {
    super.initState();
    connectivityChecker = Timer.periodic(const Duration(milliseconds: 1000), (Timer t) async {
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
      if (connected) {
        // if connected, check the connection slowly
        await Future.delayed(const Duration(seconds: 3));
      } else {
        // if not connected, check the connection frequently
        await Future.delayed(const Duration(seconds: 1));
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
        leading: widget.leading,
        title: [
          i18n.title.text(),
          if (!isConnected)
            Placeholders.loading(
              size: 14,
            ).padOnly(l: 40.w)
        ].row(),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: isConnected
            ? const ConnectedInfoPage(key: ValueKey("Connected"))
            : const DisconnectedInfoPage(key: ValueKey("Disconnected")),
      ),
    );
  }
}
