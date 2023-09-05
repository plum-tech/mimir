import 'dart:async';

import 'package:check_vpn_connection/check_vpn_connection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

import '../../mini_apps/timetable/init.dart';
import '../../mini_apps/timetable/using.dart';

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

IconData getConnectionTypeIcon(ConnectivityResult? type, {IconData? fallback}) {
  return _type2Icon[type] ?? fallback ?? Icons.wifi_find_outlined;
}

class _ConnectivityCheckerState extends State<ConnectivityChecker> {
  final service = TimetableInit.network;

  ConnectivityStatus status = ConnectivityStatus.none;
  ConnectivityResult? connectionType;
  late Timer networkChecker;

  @override
  void initState() {
    super.initState();
    networkChecker = runPeriodically(const Duration(milliseconds: 1000), (Timer t) async {
      var type = await Connectivity().checkConnectivity();
      if (type == ConnectivityResult.wifi || type == ConnectivityResult.ethernet) {
        if (await CheckVpnConnection.isVpnActive()) {
          type = ConnectivityResult.vpn;
        }
      }
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
      AnimatedSize(
        duration: const Duration(milliseconds: 300),
        child: buildIndicatorArea(context).animatedSwitched(),
      ),
      AnimatedSize(
        duration: const Duration(milliseconds: 300),
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
        tip = widget.initialDesc ?? _i18n.status.none;
        break;
      case ConnectivityStatus.connecting:
        tip = _i18n.status.connecting;
        break;
      case ConnectivityStatus.connected:
        tip = _i18n.status.connected;
        break;
      case ConnectivityStatus.disconnected:
        tip = _i18n.status.disconnected;
        break;
    }
    return tip.text(key: ValueKey(tip), style: s);
  }

  Widget buildButton(BuildContext ctx) {
    final String tip;
    VoidCallback? onTap;
    switch (status) {
      case ConnectivityStatus.none:
        tip = _i18n.button.none;
        onTap = startCheck;
        break;
      case ConnectivityStatus.connecting:
        tip = _i18n.button.connecting;
        break;
      case ConnectivityStatus.connected:
        tip = _i18n.button.connected;
        onTap = widget.onConnected;
        break;
      case ConnectivityStatus.disconnected:
        tip = _i18n.button.disconnected;
        onTap = startCheck;
        break;
    }
    return tip.text(key: ValueKey(tip)).cupertinoBtn(onPressed: onTap);
  }

  Widget buildIndicatorArea(BuildContext ctx) {
    switch (status) {
      case ConnectivityStatus.none:
        return buildIcon(ctx, getConnectionTypeIcon(connectionType));
      case ConnectivityStatus.connecting:
        return LoadingPlaceholder.drop(key: const ValueKey("Waiting"), size: widget.iconSize);
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

  @override
  void dispose() {
    networkChecker.cancel();
    super.dispose();
  }
}

const _i18n = _NetworkCheckerI18n();

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
