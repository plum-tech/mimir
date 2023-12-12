import 'package:flutter/material.dart';
import 'package:sit/settings/settings.dart';
import 'package:rettulf/rettulf.dart';
import '../i18n.dart';

class AboutSettingsPage extends StatefulWidget {
  const AboutSettingsPage({
    super.key,
  });

  @override
  State<AboutSettingsPage> createState() => _AboutSettingsPageState();
}

class _AboutSettingsPageState extends State<AboutSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const RangeMaintainingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar.large(
            pinned: true,
            snap: false,
            floating: false,
            title: i18n.about.title.text(),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
            ]),
          ),
        ],
      ),
    );
  }
}
