import 'package:cupertino_onboarding/cupertino_onboarding.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/r.dart';
import 'package:sit/update/entity/artifact.dart';
import 'package:sit/utils/guard_launch.dart';
import 'package:sit/widgets/markdown_widget.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:sit/settings/i18n.dart' as settings;
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
  @override
  Widget build(BuildContext context) {
    final info = widget.info;
    return CupertinoOnboarding(
      bottomButtonChild: i18n.download.text(),
      widgetAboveBottomButton: CupertinoButton(
        child: settings.i18n.about.privacyPolicy.text(),
        onPressed: () async {
          await guardLaunchUrlString(context, "https://github.com/liplum-dev/mimir/blob/master/Privacy%20Policy.md");
        },
      ),
      onPressedOnLastPage: () async {
        final download = info.downloadOf(R.currentVersion.platform);
        if (download == null) return;
        final url = download.defaultUrl;
        if (url == null) return;
        context.pop();
        await launchUrlString(url, mode: LaunchMode.externalApplication);
      },
      pages: [
        WhatsNewPage(
          title: "What's New in ${info.version}".text(),
          features: [
            FeaturedMarkdownWidget(info.releaseNote),
          ],
        ),
      ],
    );
  }
}
