import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:sit/design/adaptive/foundation.dart';
import 'package:sit/design/adaptive/multiplatform.dart';
import 'package:sit/design/animation/animated.dart';
import 'package:sit/init.dart';
import 'package:sit/network/utils.dart';
import 'package:sit/utils/error.dart';
import 'package:rettulf/rettulf.dart';

enum _Status {
  none,
  connecting,
  connected,
  disconnected;
}

class ConnectivityChecker extends StatefulWidget {
  final double iconSize;
  final String? initialDesc;
  final VoidCallback onConnected;
  final Duration? autoStartDelay;

  /// Whether it's connected will be turned.
  /// Throw any error if connection fails.
  final Future<bool> Function() check;

  const ConnectivityChecker({
    super.key,
    this.iconSize = 120,
    this.initialDesc,
    required this.onConnected,
    required this.check,
    this.autoStartDelay,
  });

  @override
  State<ConnectivityChecker> createState() => _ConnectivityCheckerState();
}

class _ConnectivityCheckerState extends State<ConnectivityChecker> {
  _Status status = _Status.none;
  late StreamSubscription<ConnectivityStatus> connectivityChecker;
  ConnectivityStatus? connectivityStatus;

  @override
  void initState() {
    super.initState();
    connectivityChecker = checkConnectivityPeriodic(period: const Duration(milliseconds: 1000)).listen((status) {
      if (connectivityStatus != status) {
        if (!mounted) return;
        setState(() {
          connectivityStatus = status;
        });
      }
    });
    final autoStartDelay = widget.autoStartDelay;
    if (autoStartDelay != null) {
      Future.delayed(autoStartDelay).then((value) {
        startCheck();
      });
    }
  }

  @override
  void dispose() {
    connectivityChecker.cancel();
    super.dispose();
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
      status = _Status.connecting;
    });
    try {
      final connected = await widget.check();
      if (!mounted) return;
      setState(() {
        if (connected) {
          status = _Status.connected;
        } else {
          status = _Status.disconnected;
        }
      });
    } catch (error, stackTrace) {
      debugPrintError(error, stackTrace);
      if (!mounted) return;
      setState(() {
        status = _Status.disconnected;
      });
    }
  }

  Widget buildStatus(BuildContext ctx) {
    final tip = switch (status) {
      _Status.none => widget.initialDesc ?? _i18n.status.none,
      _Status.connecting => _i18n.status.connecting,
      _Status.connected => _i18n.status.connected,
      _Status.disconnected => _i18n.status.disconnected,
    };
    return tip.text(key: ValueKey(status), style: ctx.textTheme.titleLarge, textAlign: TextAlign.center);
  }

  Widget buildButton(BuildContext ctx) {
    final (tip, onTap) = switch (status) {
      _Status.none => (_i18n.button.none, startCheck),
      _Status.connecting => (_i18n.button.connecting, null),
      _Status.connected => (_i18n.button.connected, widget.onConnected),
      _Status.disconnected => (_i18n.button.disconnected, startCheck),
    };
    return PlatformElevatedButton(
      onPressed: onTap,
      child: tip.text(
        key: ValueKey(status),
        style: TextStyle(fontSize: context.textTheme.titleMedium?.fontSize),
      ),
    );
  }

  Widget buildIndicatorArea(BuildContext ctx) {
    switch (status) {
      case _Status.none:
        return buildIcon(ctx, getConnectionTypeIcon(connectivityStatus));
      case _Status.connecting:
        return const CircularProgressIndicator(
          key: ValueKey("Waiting"),
          strokeWidth: 14,
        ).sizedAll(widget.iconSize);
      case _Status.connected:
        return buildIcon(ctx, context.icons.checkMark);
      case _Status.disconnected:
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
}

const _i18n = _NetworkCheckerI18n();

class _NetworkCheckerI18n {
  const _NetworkCheckerI18n();

  static const ns = "networkChecker";

  final button = const _NetworkCheckerI18nEntry("button");
  final status = const _NetworkCheckerI18nEntry("status");

  String get testConnection => "$ns.testConnection.title".tr();

  String get testConnectionDesc => "$ns.testConnection.desc".tr();
}

class _NetworkCheckerI18nEntry {
  final String scheme;

  String get _ns => "${_NetworkCheckerI18n.ns}.$scheme";

  const _NetworkCheckerI18nEntry(this.scheme);

  String get connected => "$_ns.connected".tr();

  String get connecting => "$_ns.connecting".tr();

  String get disconnected => "$_ns.disconnected".tr();

  String get none => "$_ns.none".tr();
}

class TestConnectionTile extends StatefulWidget {
  const TestConnectionTile({super.key});

  @override
  State<TestConnectionTile> createState() => _TestConnectionTileState();
}

class _TestConnectionTileState extends State<TestConnectionTile> {
  var testState = _Status.none;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      enabled: testState != _Status.connecting,
      leading: const Icon(Icons.network_check),
      title: _i18n.testConnection.text(),
      subtitle: _i18n.testConnectionDesc.text(),
      trailing: switch (testState) {
        _Status.connecting => const CircularProgressIndicator.adaptive(),
        _Status.connected => Icon(context.icons.checkMark, color: Colors.green),
        _Status.disconnected => Icon(Icons.public_off_rounded, color: context.$red$),
        _ => null,
      },
      onTap: () async {
        setState(() {
          testState = _Status.connecting;
        });
        final bool connected;
        try {
          connected = await Init.ugRegSession.checkConnectivity();
          if (!mounted) return;
          setState(() {
            testState = connected ? _Status.connected : _Status.disconnected;
          });
        } catch (error) {
          if (!mounted) return;
          setState(() {
            testState = _Status.disconnected;
          });
        }
      },
    );
  }
}
