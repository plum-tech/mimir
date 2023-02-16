import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

import '../../module/timetable/init.dart';
import '../../module/timetable/using.dart';

enum ConnectivityStatus {
  none,
  connecting,
  connected,
  disconnected;
}

class ConnectivityChecker extends StatefulWidget {
  final double iconSize;
  final String? initialDesc;
  final VoidCallback onConnected;
  final Future<bool> Function() check;

  const ConnectivityChecker({
    super.key,
    this.iconSize = 120,
    this.initialDesc,
    required this.onConnected,
    required this.check,
  });

  @override
  State<ConnectivityChecker> createState() => _ConnectivityCheckerState();
}

const _type2Icon = {
  ConnectivityResult.bluetooth: Icons.bluetooth,
  ConnectivityResult.wifi: Icons.wifi,
  ConnectivityResult.ethernet: Icons.lan,
  ConnectivityResult.mobile: Icons.signal_cellular_alt,
  ConnectivityResult.none: Icons.signal_wifi_statusbar_null_outlined,
  ConnectivityResult.vpn: Icons.vpn_key,
};

class _ConnectivityCheckerState extends State<ConnectivityChecker> {
  final service = TimetableInit.network;

  ConnectivityStatus status = ConnectivityStatus.none;
  ConnectivityResult? connectionType;
  late Timer networkChecker;

  @override
  void initState() {
    super.initState();
    Future(() => Connectivity().checkConnectivity()).then((type) {
      if (connectionType != type) {
        if (!mounted) return;
        setState(() {
          connectionType = type;
        });
      }
    });
    networkChecker = Timer.periodic(const Duration(milliseconds: 500), (Timer t) async {
      final type = await Connectivity().checkConnectivity();
      if (connectionType != type) {
        if (!mounted) return;
        setState(() {
          connectionType = type;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return [
      buildIndicatorArea(context).animatedSwitched(),
      AnimatedSize(
        duration: const Duration(milliseconds: 500),
        child: buildStatus(context).animatedSwitched(),
      ),
      buildButton(context),
    ].column(maa: MainAxisAlignment.spaceAround, caa: CrossAxisAlignment.center).center().padAll(20);
  }

  void startCheck() {
    setState(() {
      networkChecker.cancel();
      status = ConnectivityStatus.connecting;
    });
    Future.wait([
      widget.check(),
      Future.delayed(const Duration(milliseconds: 800)),
    ]).then((value) {
      if (!mounted) return;
      final bool connected = value[0];
      setState(() {
        if (connected) {
          status = ConnectivityStatus.connected;
        } else {
          status = ConnectivityStatus.disconnected;
        }
      });
    }).onError((error, stackTrace) {
      setState(() {
        status = ConnectivityStatus.disconnected;
      });
    });
  }

  Widget buildStatus(BuildContext ctx) {
    final s = ctx.textTheme.titleLarge;
    final String tip;
    switch (status) {
      case ConnectivityStatus.none:
        tip = widget.initialDesc ?? i18n.status.none;
        break;
      case ConnectivityStatus.connecting:
        tip = i18n.status.connecting;
        break;
      case ConnectivityStatus.connected:
        tip = i18n.status.connected;
        break;
      case ConnectivityStatus.disconnected:
        tip = i18n.status.disconnected;
        break;
    }
    return tip.text(key: ValueKey(tip), style: s);
  }

  Widget buildButton(BuildContext ctx) {
    final String tip;
    VoidCallback? onTap;
    switch (status) {
      case ConnectivityStatus.none:
        tip = i18n.button.none;
        onTap = startCheck;
        break;
      case ConnectivityStatus.connecting:
        tip = i18n.button.connecting;
        break;
      case ConnectivityStatus.connected:
        tip = i18n.button.connected;
        onTap = widget.onConnected;
        break;
      case ConnectivityStatus.disconnected:
        tip = i18n.button.disconnected;
        onTap = startCheck;
        break;
    }
    return tip.text(key: ValueKey(tip)).cupertinoBtn(onPressed: onTap);
  }

  Widget buildIndicatorArea(BuildContext ctx) {
    switch (status) {
      case ConnectivityStatus.none:
        return buildCurrentConnectionType(ctx);
      case ConnectivityStatus.connecting:
        return Placeholders.loading(
            size: widget.iconSize / 2,
            fix: (w) => w.padAll(30).sized(w: widget.iconSize, h: widget.iconSize, key: const ValueKey("Waiting")));
      case ConnectivityStatus.connected:
        return buildIcon(ctx, Icons.check_rounded);
      case ConnectivityStatus.disconnected:
        return buildIcon(ctx, Icons.public_off_rounded);
    }
  }

  Widget buildIcon(BuildContext ctx, IconData icon, [Key? key]) {
    key ??= ValueKey(icon);
    return Icon(icon, size: widget.iconSize, color: ctx.darkSafeThemeColor)
        .sized(w: widget.iconSize, h: widget.iconSize, key: key);
  }

  Widget buildCurrentConnectionType(BuildContext ctx) {
    final type = connectionType;
    return buildIcon(ctx, _type2Icon[type] ?? Icons.signal_wifi_statusbar_null_outlined);
  }

  @override
  void dispose() {
    super.dispose();
    networkChecker.cancel();
  }
}

const i18n = _NetworkCheckerI18n();

class _NetworkCheckerI18n {
  const _NetworkCheckerI18n();

  static const _ns = "networkChecker";

  final button = const _NetworkCheckerI18nEntry("button");
  final status = const _NetworkCheckerI18nEntry("status");
}

class _NetworkCheckerI18nEntry {
  final String scheme;

  String get _ns => "${_NetworkCheckerI18n._ns}.$scheme";

  const _NetworkCheckerI18nEntry(this.scheme);

  String get connected => "$_ns.connected".tr();

  String get connecting => "$_ns.connecting".tr();

  String get disconnected => "$_ns.disconnected".tr();

  String get none => "$_ns.none".tr();
}
