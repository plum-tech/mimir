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
        onPressed: AppSettings.openWIFISettings,
        child: i18n.openWlanSettingsBtn.text(),
      ),
      ElevatedButton(
          child: i18n.launchEasyConnectBtn.text(),
          onPressed: () async {
            final launched = await GlobalLauncher.launch('sangfor://easyconnect');
            if (!launched) {
              if (!mounted) return;
              final confirm = await context.showRequest(
                  title: i18n.easyconnectLaunchFailed,
                  desc: i18n.easyconnectLaunchFailedDesc,
                  yes: i18n.download,
                  no: i18n.notNow,
                  highlight: true);
              if (confirm == true) {
                await GlobalLauncher.launch(R.easyConnectDownloadUrl);
              }
            }
          }),
    ].row(
      maa: MainAxisAlignment.spaceEvenly,
    );
  }
}
