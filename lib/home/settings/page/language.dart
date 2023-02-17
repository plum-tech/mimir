import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

class LanguageSelectorPage extends StatefulWidget {
  final List<Locale> candidates;
  final Locale selected;

  const LanguageSelectorPage({
    super.key,
    required this.candidates,
    required this.selected,
  });

  @override
  State<LanguageSelectorPage> createState() => _LanguageSelectorPageState();
}

class _LanguageSelectorPageState extends State<LanguageSelectorPage> {
  late var curSelected = widget.selected;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await context.setLocale(curSelected);
        return true;
      },
      child: Scaffold(
        body: CustomScrollView(
          physics: const RangeMaintainingScrollPhysics(),
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              snap: false,
              floating: false,
              expandedHeight: 100.0,
              flexibleSpace: FlexibleSpaceBar(
                title: "language.$curSelected".tr().text(),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: widget.candidates.length,
                (ctx, index) {
                  final locale = widget.candidates[index];
                  return buildOption(locale);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOption(Locale locale) {
    return ListTile(
      title: "language.$locale".tr().text(),
      onTap: locale == curSelected
          ? null
          : () {
              setState(() {
                curSelected = locale;
              });
            },
      trailing: locale != curSelected
          ? null
          : const Icon(
              Icons.check,
              color: Colors.green,
            ),
    );
  }
}
