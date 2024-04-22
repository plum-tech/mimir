import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:sit/design/adaptive/dialog.dart';
import 'package:sit/utils/guard_launch.dart';
import 'package:rettulf/rettulf.dart';

import '../i18n.dart';

const easyConnectDownloadUrl = "https://vpn1.sit.edu.cn/com/installClient.html";

class LaunchEasyConnectButton extends StatelessWidget {
  const LaunchEasyConnectButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      child: i18n.easyconnect.launchBtn.text(),
      onPressed: () async {
        final launched = await guardLaunchUrlString(context, 'sangfor://easyconnect');
        if (!launched) {
          if (!context.mounted) return;
          final confirm = await context.showDialogRequest(
            title: i18n.easyconnect.launchFailed,
            desc: i18n.easyconnect.launchFailedDesc,
            yes: i18n.download,
            no: i18n.cancel,
            yesDestructive: true,
          );
          if (confirm == true) {
            if (!context.mounted) return;
            await guardLaunchUrlString(context, easyConnectDownloadUrl);
          }
        }
      },
    );
  }
}

class OpenWifiSettingsButton extends StatelessWidget {
  const OpenWifiSettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        AppSettings.openAppSettings(type: AppSettingsType.wifi);
      },
      child: i18n.openWifiSettingsBtn.text(),
    );
  }
}
