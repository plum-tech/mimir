import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rettulf/rettulf.dart';

import '../init.dart';
import '../user_widget/connected.dart';
import '../user_widget/disconnected.dart';
import '../user_widget/quick_button.dart';
import '../using.dart';

class NetworkToolPage extends StatefulWidget {
  const NetworkToolPage({super.key});

  @override
  State<NetworkToolPage> createState() => _NetworkToolPageState();
}

const iconDir = "assets/connectivity";
const unavailableIconPath = "$iconDir/unavailable.svg";
const availableIconPath = "$iconDir/available.svg";

class _NetworkToolPageState extends State<NetworkToolPage> {
  bool isConnected = false;

  @override
  void initState() {
    super.initState();
    checkConnectivity();
  }

  /// Check the connectivity until succeed.
  void checkConnectivity() {
    ConnectivityInit.ssoSession.checkConnectivity().then((newStatus) {
      if (!mounted) return;
      if (isConnected != newStatus) {
        setState(() => isConnected = newStatus);
      }
      if (!newStatus) {
        checkConnectivity();
      }
    });
  }

  final _connectedKey = const ValueKey("Connected");
  final _disconnectedKey = const ValueKey("Disconnected");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: [
            i18n.networkTool.text(),
            if (!isConnected)
              Placeholders.loading(
                size: 14,
              ).padOnly(l: 40.w)
          ].row(),
        ),
        body: context.isPortrait ? buildPortraitBody(context) : buildLandscapeBody(context));
  }

  Widget buildPortraitBody(BuildContext context) {
    return [
      buildFigure(context).expanded(),
      AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: isConnected
                  ? ConnectedBlock(
                      key: _connectedKey,
                    )
                  : [const DisconnectedBlock(), const QuickButtons()]
                      .column(key: _disconnectedKey, maa: MainAxisAlignment.spaceEvenly))
          .expanded(),
    ].column(caa: CrossAxisAlignment.center, maa: MainAxisAlignment.center).center();
  }

  Widget buildLandscapeBody(BuildContext context) {
    final figure = isConnected
        ? buildFigure(context).center()
        : [buildFigure(context), const QuickButtons().expanded()]
            .column(caa: CrossAxisAlignment.center, maa: MainAxisAlignment.spaceEvenly);
    return [
      figure.expanded(),
      AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: isConnected
                  ? ConnectedBlock(
                      key: _connectedKey,
                    )
                  : DisconnectedBlock(
                      key: _disconnectedKey,
                    ))
          .center()
          .expanded(),
    ].row(caa: CrossAxisAlignment.center, maa: MainAxisAlignment.center).center();
  }

  Widget buildFigure(BuildContext context) {
    final iconPath = isConnected ? availableIconPath : unavailableIconPath;
    return SvgPicture.asset(iconPath, width: 300, height: 300, color: context.darkSafeThemeColor)
        .constrained(minW: 120, minH: 120, maxW: 240, maxH: 240);
  }
}
