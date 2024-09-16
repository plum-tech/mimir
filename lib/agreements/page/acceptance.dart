import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mimir/design/adaptive/foundation.dart';
import 'package:mimir/widgets/markdown.dart';
import 'package:rettulf/rettulf.dart';
import '../i18n.dart';

class AgreementsAcceptanceSheet extends ConsumerStatefulWidget {
  const AgreementsAcceptanceSheet({super.key});

  @override
  ConsumerState createState() => _AgreementsAcceptanceSheetState();

  static Future<void> show(BuildContext context) async {
    context.showSheet(
      (_) => const AgreementsAcceptanceSheet(),
      dismissible: false,
    );
  }
}

class _AgreementsAcceptanceSheetState extends ConsumerState<AgreementsAcceptanceSheet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [
        FeaturedMarkdownWidget(data: i18n.privacyPolicy),
      ].column(),
    );
  }
}
