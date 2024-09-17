import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/design/adaptive/multiplatform.dart';
import 'package:mimir/settings/settings.dart';
import 'package:mimir/widgets/markdown.dart';
import 'package:rettulf/rettulf.dart';
import '../entity/agreements.dart';
import '../i18n.dart';

class AgreementsAcceptanceSheet extends ConsumerStatefulWidget {
  const AgreementsAcceptanceSheet({super.key});

  @override
  ConsumerState createState() => _AgreementsAcceptanceSheetState();

  static Future<void> show(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (_) => const AgreementsAcceptanceSheet(),
      isDismissible: false,
      enableDrag: false,
    );
  }
}

class _AgreementsAcceptanceSheetState extends ConsumerState<AgreementsAcceptanceSheet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: i18n.privacyPolicy.text(),
        actions: [
          PlatformIconButton(
            onPressed: () {
              context.push("/settings");
            },
            icon: Icon(context.icons.settings),
          ),
        ],
      ),
      body: FeaturedMarkdownWidget(data: i18n.privacyPolicyContent).scrolled().padSymmetric(h: 15),
      bottomNavigationBar: BottomAppBar(
        height: 60,
        child: [
          OutlinedButton(
            child: i18n.declineAndExit.text(),
            onPressed: () {
              SystemNavigator.pop(animated: true);
            },
          ).expanded(),
          const SizedBox(width: 15),
          FilledButton(
            child: i18n.acceptAndContinue.text(),
            onPressed: () {
              Settings.agreements.setBasicAcceptanceOf(AgreementVersion.current, true);
              context.pop();
            },
          ).expanded(),
        ].row(maa: MainAxisAlignment.spaceEvenly, caa: CrossAxisAlignment.center),
      ),
    );
  }
}
