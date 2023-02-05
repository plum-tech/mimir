import 'package:flutter/material.dart';

import '../using.dart';
import 'report.dart';

class DailyReportIndexPage extends StatefulWidget {
  const DailyReportIndexPage({super.key});

  @override
  State<DailyReportIndexPage> createState() => _DailyReportIndexPageState();
}

class _DailyReportIndexPageState extends State<DailyReportIndexPage> {
  @override
  Widget build(BuildContext context) {
    final oaCredential = Auth.oaCredential;
    if (oaCredential == null) {
      return const UnauthorizedTipPage();
    } else {
      return DailyReportPage(oaCredential: oaCredential);
    }
  }
}
