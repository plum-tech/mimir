import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:locale_names/locale_names.dart';
import 'package:sit/r.dart';
import 'package:rettulf/rettulf.dart';
import '../i18n.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({
    super.key,
  });

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  late var selected = context.locale;

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
            title: i18n.language.text(),
            actions: [
              PlatformTextButton(
                onPressed: selected != context.locale ? onSave : null,
                child: i18n.save.text(),
              )
            ],
          ),
          SliverList.builder(
            itemCount: R.supportedLocales.length,
            itemBuilder: (ctx, i) {
              final locale = R.supportedLocales[i];
              return ListTile(
                selected: selected == locale,
                title: locale.nativeDisplayLanguageScript.text(),
                onTap: () {
                  setState(() {
                    selected = locale;
                  });
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> onSave() async {
    await context.setLocale(selected);
    final engine = WidgetsFlutterBinding.ensureInitialized();
    engine.performReassemble();
    if (!mounted) return;
    context.pop();
  }
}
