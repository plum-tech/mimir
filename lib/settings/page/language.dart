import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:locale_names/locale_names.dart';
import 'package:mimir/design/adaptive/multiplatform.dart';
import 'package:mimir/r.dart';
import 'package:rettulf/rettulf.dart';
import 'package:mimir/utils/save.dart';
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
    final canSave = selected != context.locale;
    return PromptSaveBeforeQuitScope(
      changed: canSave,
      onSave: onSave,
      child: Scaffold(
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
                  onPressed: canSave ? onSave : null,
                  child: i18n.save.text(),
                )
              ],
            ),
            SliverList.builder(
              itemCount: R.supportedLocales.length,
              itemBuilder: (ctx, i) {
                final locale = R.supportedLocales[i];
                final isSelected = selected == locale;
                return ListTile(
                  selected: isSelected,
                  title: locale.nativeDisplayLanguageScript.text(),
                  trailing: isSelected ? Icon(ctx.icons.checkMark) : null,
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
