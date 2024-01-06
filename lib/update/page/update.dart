import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/r.dart';
import 'package:sit/settings/settings.dart';
import 'package:sit/update/entity/artifact.dart';
import 'package:sit/widgets/markdown.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../i18n.dart';

class ArtifactUpdatePage extends StatefulWidget {
  final ArtifactVersionInfo info;

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
          Expanded(
            flex: 5,
            child: i18n.newVersionAvailable.text(
              textAlign: TextAlign.center,
              style: context.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -1,
              ),
            ),
          ),
          const Spacer(),
        ].row().padV(32),
        [
          ListTile(
            leading: const Icon(Icons.featured_play_list),
            title: info.version.toString().text(),
          ),
          MarkdownWidget(data: info.releaseNote).expanded(),
        ].column().padH(8).expanded(),
        buildSkipTile().padH(32),
        [
          OutlinedButton(
            onPressed: () {
              if (ignore) {
                Settings.skippedVersion = info.version.toString();
              }
              context.pop();
            },
            child: i18n.notNow.text(style: context.textTheme.titleMedium).padAll(16),
          ).padOnly(r: 8).expanded(),
          FilledButton(
            onPressed: ignore
                ? null
                : () async {
                    final download = info.downloadOf(R.currentVersion.platform);
                    if (download == null) return;
                    final url = download.defaultUrl;
                    if (url == null) return;
                    context.pop();
                    await launchUrlString(url, mode: LaunchMode.externalApplication);
                  },
            child: i18n.download.text(style: context.textTheme.titleMedium).padAll(16),
          ).padOnly(l: 8).expanded(),
        ].row(maa: MainAxisAlignment.spaceEvenly).padAll(8),
      ].column().safeArea(),
    );
  }

  Widget buildSkipTile(){
    return CheckboxListTile(
      value: ignore,
      onChanged: (value) {
        setState(() {
          ignore = value == true;
        });
      },
      title: i18n.skipThisVersion.text(),
    );
  }
}