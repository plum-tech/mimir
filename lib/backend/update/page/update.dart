import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rettulf/rettulf.dart';
import 'package:simple_icons/simple_icons.dart';
import 'package:mimir/r.dart';
import 'package:mimir/settings/settings.dart';
import 'package:mimir/widget/markdown.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../i18n.dart';
import '../entity/version.dart';

class ArtifactUpdatePage extends StatefulWidget {
  final VersionInfo info;

  const ArtifactUpdatePage({
    super.key,
    required this.info,
  });

  @override
  State<ArtifactUpdatePage> createState() => _ArtifactUpdatePageState();
}

class _ArtifactUpdatePageState extends State<ArtifactUpdatePage> {
  bool ignore = false;

  @override
  Widget build(BuildContext context) {
    final info = widget.info;
    return Scaffold(
      body: [
        [
          const Spacer(),
          i18n.up.newVersionAvailable
              .text(
                textAlign: TextAlign.center,
                style: context.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1,
                ),
              )
              .expanded(flex: 5),
          const Spacer(),
        ].row().padV(32),
        [
          ListTile(
            leading: const Icon(Icons.featured_play_list),
            title: info.version.toString().text(),
          ),
          FeaturedMarkdownWidget(data: info.releaseNote.resolve(context.locale)).expanded(),
        ].column().padH(8).expanded(),
        buildSkipTile().padH(32),
        [
          buildSkipButton().padOnly(r: 8).expanded(),
          (buildDownloadButton() ?? buildDownloadUnavailableButton()).padOnly(l: 8).expanded(),
        ].row(maa: MainAxisAlignment.spaceEvenly).padAll(8),
      ].column().safeArea(),
    );
  }

  Widget buildSkipButton() {
    final info = widget.info;
    return OutlinedButton(
      onPressed: () {
        if (ignore) {
          Settings.skippedVersion = info.version.toString();
          Settings.lastSkipUpdateTime = DateTime.now();
        }
        context.pop();
      },
      child: i18n.up.notNow.text(),
    );
  }

  Widget? buildDownloadButton() {
    final info = widget.info;
    if (R.debugCupertino || UniversalPlatform.isApple) {
      final downloadUrl = info.assets.iOS.resolveDownloadUrl();
      if (downloadUrl == null) return null;
      return FilledButton.icon(
        icon: const Icon(SimpleIcons.appstore),
        onPressed: () async {
          context.pop();
          await launchUrlString(downloadUrl, mode: LaunchMode.externalApplication);
        },
        label: i18n.up.openAppStore.text(),
      );
    } else if (UniversalPlatform.isAndroid) {
      final downloadUrl = info.assets.android.resolveDownloadUrl();
      if (downloadUrl == null) return null;
      return FilledButton.icon(
        onPressed: () async {
          context.pop();
          await launchUrlString(downloadUrl, mode: LaunchMode.externalApplication);
        },
        icon: Icon(UniversalPlatform.isDesktop ? Icons.install_desktop : Icons.install_mobile),
        label: i18n.download.text(),
      );
    }
    return null;
  }

  Widget buildDownloadUnavailableButton() {
    return FilledButton(
      onPressed: null,
      child: "Unavailable".text(),
    );
  }

  Widget buildSkipTile() {
    return CheckboxListTile(
      value: ignore,
      onChanged: (value) {
        setState(() {
          ignore = value == true;
        });
      },
      title: i18n.up.skipThisVersionForWhile.text(),
    );
  }
}
