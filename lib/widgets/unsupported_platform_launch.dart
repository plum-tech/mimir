import 'package:flutter/material.dart';
import 'package:mimir/launcher.dart';

// TODO: Why not launch the default browser instead?
class UnsupportedPlatformUrlLauncher extends StatelessWidget {
  final String url;
  final String? tip;
  final bool showLaunchButton;

  const UnsupportedPlatformUrlLauncher(
    this.url, {
    Key? key,
    this.tip,
    this.showLaunchButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          tip != null
              ? Text(tip!)
              : Text(showLaunchButton ? '桌面端暂不支持直接查看该页面，请点击下方按钮打开系统默认浏览器查看该页面' : '桌面端暂不支持查看该页面，请在手机端打开'),
          if (showLaunchButton)
            TextButton(
              child: const Text('点击在默认浏览器中打开'),
              onPressed: () {
                launchUri(url);
              },
            )
        ],
      ),
    ));
  }
}
