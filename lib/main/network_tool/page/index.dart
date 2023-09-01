import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rettulf/rettulf.dart';

import '../../index.dart';
import '../init.dart';
import 'connected.dart';
import 'disconnected.dart';
import '../using.dart';

class NetworkToolPage extends StatefulWidget {
  final DrawerDelegateProtocol drawer;

  const NetworkToolPage({super.key, required this.drawer});

  @override
  State<NetworkToolPage> createState() => _NetworkToolPageState();
}

class _NetworkToolPageState extends State<NetworkToolPage> {
  bool isConnected = false;

  @override
  void initState() {
    super.initState();
    checkConnectivity();
  }

  /// Check the connectivity until succeed.
  Future<void> checkConnectivity() async {
    while (true) {
      final connected = await ConnectivityInit.ssoSession.checkConnectivity();
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
    }
  }

  final _connectedKey = const ValueKey("Connected");
  final _disconnectedKey = const ValueKey("Disconnected");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => widget.drawer.openDrawer(),
        ),
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
        child: isConnected ? ConnectedInfoPage(key: _connectedKey) : DisconnectedInfoPage(key: _disconnectedKey),
      ),
    );
  }
}
