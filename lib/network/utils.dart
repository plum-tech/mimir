import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter/material.dart';

enum ConnectivityType {
  bluetooth,
  wifi,
  ethernet,
  cellular,
  other;
}

@CopyWith(skipFields: true)
class ConnectivityStatus {
  final ConnectivityType? type;
  final bool vpnEnabled;

  const ConnectivityStatus({
    required this.type,
    required this.vpnEnabled,
  });

  const ConnectivityStatus.disconnected({
    required this.vpnEnabled,
  }) : type = null;

  const ConnectivityStatus.otherType({
    required this.vpnEnabled,
  }) : type = ConnectivityType.other;

  @override
  String toString() {
    return "$type, vpn:$vpnEnabled";
  }
}

ConnectivityType? _parseResult(ConnectivityResult? r) {
  assert(r != ConnectivityResult.none);
  assert(r != ConnectivityResult.vpn);
  return switch (r) {
    ConnectivityResult.bluetooth => ConnectivityType.bluetooth,
    ConnectivityResult.wifi => ConnectivityType.wifi,
    ConnectivityResult.ethernet => ConnectivityType.ethernet,
    ConnectivityResult.mobile => ConnectivityType.cellular,
    ConnectivityResult.none => null,
    ConnectivityResult.vpn => null,
    ConnectivityResult.other => ConnectivityType.other,
    null => null,
  };
}

Future<ConnectivityStatus> checkConnectivity() async {
  var types = await Connectivity().checkConnectivity();
  if (types.isEmpty || types.first == ConnectivityResult.none) {
    return const ConnectivityStatus.disconnected(vpnEnabled: false);
  }
  var vpnEnabled = types.contains(ConnectivityResult.vpn);
  if (types.contains(ConnectivityResult.other)) {
    return ConnectivityStatus.otherType(vpnEnabled: vpnEnabled);
  }
  final type = types.where((t) => t != ConnectivityResult.vpn && t != ConnectivityResult.other).firstOrNull;
  return ConnectivityStatus(type: _parseResult(type), vpnEnabled: vpnEnabled);
}

Stream<ConnectivityStatus> checkConnectivityPeriodic({
  required Duration period,
}) {
  return checkPeriodic(period: period, check: checkConnectivity);
}

Stream<T> checkPeriodic<T>({
  required Duration period,
  required FutureOr<T> Function() check,
}) async* {
  while (true) {
    final result = await check();
    debugPrint(result.toString());
    yield result;
    await Future.delayed(period);
  }
}

const _type2Icon = {
  ConnectivityType.bluetooth: Icons.bluetooth,
  ConnectivityType.wifi: Icons.wifi,
  ConnectivityType.ethernet: Icons.lan,
  ConnectivityType.cellular: Icons.signal_cellular_alt,
};

IconData getConnectionTypeIcon(ConnectivityStatus? status, {IconData? fallback}) {
  if (status == null) return Icons.wifi_find_outlined;
  if (status.vpnEnabled) return Icons.vpn_key;
  if (status.type == null) return Icons.public_off;
  return _type2Icon[status.type] ?? fallback ?? Icons.signal_wifi_statusbar_null_outlined;
}
