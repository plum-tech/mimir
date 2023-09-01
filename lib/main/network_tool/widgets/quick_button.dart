import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

import '../using.dart';

class QuickButtons extends StatefulWidget {
  const QuickButtons({super.key});

  @override
  State<StatefulWidget> createState() => _QuickButtonsState();
}

class _QuickButtonsState extends State<QuickButtons> {
  @override
  Widget build(BuildContext context) {
    return [
      ElevatedButton(
        onPressed: () {
          AppSettings.openAppSettings(type: AppSettingsType.wifi);
        },
        child: i18n.openWlanSettingsBtn.text(),
      ),
      ElevatedButton(
          child: i18n.easyconnect.launchBtn.text(),
          onPressed: () async {
            final launched = await guardLaunchUrlString('sangfor://easyconnect');
            if (!launched) {
              if (!mounted) return;
              final confirm = await context.showRequest(
                  title: i18n.easyconnect.launchFailed,
                  desc: i18n.easyconnect.launchFailedDesc,
                  yes: i18n.download,
                  no: i18n.notNow,
                  highlight: true);
              if (confirm == true) {
                await guardLaunchUrlString(R.easyConnectDownloadUrl);
              }
            }
          }),
    ].row(
      maa: MainAxisAlignment.spaceEvenly,
    );
  }
}
