import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

import '../../init.dart';
import '../../using.dart';
import 'import.dart';

class ImportTimetableIndexPage extends StatefulWidget {
  const ImportTimetableIndexPage({super.key});

  @override
  State<ImportTimetableIndexPage> createState() => _ImportTimetableIndexPageState();
}

class _ImportTimetableIndexPageState extends State<ImportTimetableIndexPage> {
  bool canImport = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: i18n.import.title.text(),
      ),
      body: buildBody(context).animatedSwitched(),
    );
  }

  Widget buildBody(BuildContext ctx) {
    if (Auth.oaCredential != null) {
      if (canImport) {
        return const ImportTimetablePage(
          key: ValueKey("Import Timetable"),
        );
      } else {
        return buildConnectivityChecker(context, const ValueKey("Connectivity Checker"));
      }
    } else {
      return UnauthorizedTip(
        key: const ValueKey("Unauthorized"),
        onLogin: () {
          setState(() {});
        },
      );
    }
  }

  Widget buildConnectivityChecker(BuildContext ctx, Key? key) {
    return ConnectivityChecker(
      key: key,
      iconSize: ctx.isPortrait ? 180 : 120,
      initialDesc: i18n.import.connectivityCheckerDesc,
      check: TimetableInit.network.checkConnectivity,
      onConnected: () {
        if (!mounted) return;
        setState(() {
          canImport = true;
        });
      },
    );
  }
}
