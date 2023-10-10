import 'dart:async';

import 'package:check_vpn_connection/check_vpn_connection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sit/design/animation/animated.dart';
import 'package:sit/global/global.dart';
import 'package:sit/settings/settings.dart';
import 'package:sit/utils/timer.dart';
import 'package:rettulf/rettulf.dart';

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

  /// Whether it's connected will be turned.
  /// Throw any error if connection fails.
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
  final service = Global.ssoSession;

  ConnectivityStatus status = ConnectivityStatus.none;
  ConnectivityResult? connectionType;
  late Timer networkChecker;

  @override
  void initState() {
    super.initState();
    networkChecker = runPeriodically(const Duration(milliseconds: 1000), (Timer t) async {
      var type = await Connectivity().checkConnectivity();
      if (type == ConnectivityResult.wifi || type == ConnectivityResult.ethernet) {
        if (Settings.httpProxy.enableHttpProxy || await CheckVpnConnection.isVpnActive()) {
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

  Future<void> startCheck() async {
    if (!mounted) return;
    setState(() {
      networkChecker.cancel();
      status = ConnectivityStatus.connecting;
    });
    try {
      final connected = await widget.check();
      if (!mounted) return;
      setState(() {
        if (connected) {
          status = ConnectivityStatus.connected;
        } else {
          status = ConnectivityStatus.disconnected;
        }
      });
    } catch (error, stackTrace) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: stackTrace);
      if (!mounted) return;
      setState(() {
        status = ConnectivityStatus.disconnected;
      });
    }
  }

  Widget buildStatus(BuildContext ctx) {
    final tip = switch (status) {
      ConnectivityStatus.none => widget.initialDesc ?? _i18n.status.none,
      ConnectivityStatus.connecting => _i18n.status.connecting,
      ConnectivityStatus.connected => _i18n.status.connected,
      ConnectivityStatus.disconnected => _i18n.status.disconnected,
    };
    return tip.text(key: ValueKey(status), style: ctx.textTheme.titleLarge, textAlign: TextAlign.center);
  }

  Widget buildButton(BuildContext ctx) {
    final (tip, onTap) = switch (status) {
      ConnectivityStatus.none => (_i18n.button.none, startCheck),
      ConnectivityStatus.connecting => (_i18n.button.connecting, null),
      ConnectivityStatus.connected => (_i18n.button.connected, widget.onConnected),
      ConnectivityStatus.disconnected => (_i18n.button.disconnected, startCheck),
    };
    return CupertinoButton(
      onPressed: onTap,
      child: tip.text(key: ValueKey(status)),
    );
  }

  Widget buildIndicatorArea(BuildContext ctx) {
    switch (status) {
      case ConnectivityStatus.none:
        return buildIcon(ctx, getConnectionTypeIcon(connectionType));
      case ConnectivityStatus.connecting:
        return const CircularProgressIndicator(
          key: ValueKey("Waiting"),
          strokeWidth: 14,
        ).sizedAll(widget.iconSize);
      case ConnectivityStatus.connected:
        return buildIcon(ctx, Icons.check_rounded);
      case ConnectivityStatus.disconnected:
        return buildIcon(ctx, Icons.public_off_rounded);
    }
  }

  Widget buildIcon(BuildContext ctx, IconData icon, [Key? key]) {
    key ??= ValueKey(icon);
    return Icon(
      icon,
      size: widget.iconSize,
      color: ctx.colorScheme.primary,
    ).sizedAll(
      key: key,
      widget.iconSize,
    );
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
