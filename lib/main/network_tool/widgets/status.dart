import 'package:flutter/widgets.dart';
import 'package:rettulf/rettulf.dart';
import "../i18n.dart";
import '../service/network.dart';

class CampusNetworkStatusInfo extends StatelessWidget {
  final CampusNetworkStatus? status;

  const CampusNetworkStatusInfo({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final style = context.textTheme.bodyLarge;
    final status = this.status;
    var ip = i18n.unknown;
    var studentId = i18n.unknown;
    if (status != null) {
      ip = status.ip;
      studentId = status.studentId ?? i18n.unknown;
    }
    return [
      "${i18n.credential.studentId}: $studentId".text(textAlign: TextAlign.center, style: style),
      "${i18n.network.ipAddress}: $ip".text(textAlign: TextAlign.center, style: style),
    ].column();
  }
}
