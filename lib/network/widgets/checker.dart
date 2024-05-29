import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sit/design/adaptive/foundation.dart';
import 'package:sit/design/adaptive/multiplatform.dart';
import 'package:sit/design/animation/animated.dart';
import 'package:sit/network/connectivity.dart';
import 'package:sit/utils/error.dart';
import 'package:rettulf/rettulf.dart';

import '../utils.dart';
import '../i18n.dart';

enum _Status {
  none,
  connecting,
  connected,
  disconnected;
}

enum WhereToCheck {
  schoolServer,
  studentReg;
}

class ConnectivityChecker extends StatefulWidget {
  final double iconSize;
  final String? initialDesc;
  final VoidCallback onConnected;
  final Duration? autoStartDelay;
  final WhereToCheck where;

  /// {@template mimir.network.widgets.checker}
  /// Whether it's connected will be turned.
  /// Throw any error if connection fails.
  /// {@endtemplate}
  final Future<bool> Function() check;

  const ConnectivityChecker({
    super.key,
    this.iconSize = 120,
    this.initialDesc,
    required this.onConnected,
    required this.check,
    this.autoStartDelay,
    required this.where,
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
    final autoStartDelay = widget.autoStartDelay;
    if (autoStartDelay != null) {
      Future.delayed(autoStartDelay).then((value) {
        if (status == _Status.none) {
          startCheck();
        }
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
        duration: Durations.medium2,
        child: buildIndicatorArea(context).animatedSwitched(),
      ),
      AnimatedSize(
        duration: Durations.medium2,
        child: buildStatus(context).animatedSwitched(),
      ),
      buildButton(context),
      if (status == _Status.disconnected) buildTroubleshooting(),
    ].column(maa: MainAxisAlignment.spaceAround, caa: CrossAxisAlignment.center).center().padAll(20);
  }

  Widget buildTroubleshooting() {
    return OutlinedButton.icon(
      icon: Icon(context.icons.troubleshoot),
      label: i18n.troubleshoot.text(),
      onPressed: () {
        context.push("/tools/network-tool");
      },
    );
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
    // TODO: it's student registration system
    final tip = switch (status) {
      _Status.none => widget.initialDesc ?? i18n.checker.status.none(widget.where),
      _Status.connecting => i18n.checker.status.connecting(widget.where),
      _Status.connected => i18n.checker.status.connected(widget.where),
      _Status.disconnected => i18n.checker.status.disconnected(widget.where),
    };
    return tip.text(key: ValueKey(status), style: ctx.textTheme.titleLarge, textAlign: TextAlign.center);
  }

  Widget buildButton(BuildContext ctx) {
    final style = TextStyle(fontSize: context.textTheme.titleMedium?.fontSize);
    return switch (status) {
      _Status.none => FilledButton(
          onPressed: startCheck,
          child: i18n.checker.button.none.text(style: style),
        ),
      _Status.connecting => FilledButton(
          onPressed: null,
          child: i18n.checker.button.connecting.text(style: style),
        ),
      _Status.connected => FilledButton(
          onPressed: widget.onConnected,
          child: i18n.checker.button.connected.text(style: style),
        ),
      _Status.disconnected => FilledButton.icon(
          icon: Icon(ctx.icons.refresh),
          onPressed: startCheck,
          label: i18n.checker.button.disconnected.text(style: style),
        ),
    };
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

class TestConnectionTile extends StatefulWidget {
  final WhereToCheck where;

  /// Whether it's connected will be turned.
  /// Throw any error if connection fails.
  final Future<bool> Function() check;

  const TestConnectionTile({
    super.key,
    required this.where,
    required this.check,
  });

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
      title: i18n.checker.testConnection.text(),
      subtitle: i18n.checker.testConnectionDesc(widget.where).text(),
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
          connected = await widget.check();
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

class ConnectivityCheckerSheet extends StatelessWidget {
  final String desc;

  /// {@macro mimir.network.widgets.checker}
  final Future<bool> Function() check;
  final WhereToCheck where;

  const ConnectivityCheckerSheet({
    super.key,
    required this.desc,
    required this.check,
    required this.where,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: i18n.title.text(),
      ),
      body: ConnectivityChecker(
        key: key,
        iconSize: context.isPortrait ? 180 : 120,
        autoStartDelay: const Duration(milliseconds: 2500),
        initialDesc: desc,
        check: check,
        where: where,
        onConnected: () {
          context.pop(true);
        },
      ),
    );
  }
}
