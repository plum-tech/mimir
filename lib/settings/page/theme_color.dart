import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:sit/design/widgets/card.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/settings/settings.dart';
import 'package:sit/utils/color.dart';
import 'package:system_theme/system_theme.dart';
import '../i18n.dart';

class ThemeColorPage extends StatefulWidget {
  const ThemeColorPage({
    super.key,
  });

  @override
  State<ThemeColorPage> createState() => _ThemeColorPageState();
}

class _ThemeColorPageState extends State<ThemeColorPage> {
  late var themeColor = Settings.theme.themeColor ?? getDefaultThemeColor();
  var fromSystem = Settings.theme.themeColorFromSystem;

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
            title: i18n.themeColor.text(),
            actions: [
              PlatformTextButton(
                onPressed: canSave() ? onSave : null,
                child: i18n.save.text(),
              )
            ],
          ),
          SliverList.list(
            children: [
              buildFromSystemToggle(),
              buildThemeColorTile(),
            ],
          ),
        ],
      ),
    );
  }

  Color getDefaultThemeColor() {
    return SystemTheme.accentColor.maybeAccent ?? context.colorScheme.primary;
  }

  bool canSave() {
    return fromSystem != Settings.theme.themeColorFromSystem ||
        themeColor != (Settings.theme.themeColor ?? getDefaultThemeColor());
  }

  Future<void> selectNewThemeColor() async {
    final newColor = await showColorPickerDialog(
      context,
      themeColor,
      enableOpacity: true,
      enableShadesSelection: true,
      enableTonalPalette: true,
      showColorCode: true,
      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.both: true,
        ColorPickerType.primary: false,
        ColorPickerType.accent: false,
        ColorPickerType.custom: true,
        ColorPickerType.wheel: true,
      },
    );
    setState(() {
      themeColor = newColor;
    });
  }

  Widget buildThemeColorTile() {
    return ListTile(
      leading: const Icon(Icons.color_lens_outlined),
      enabled: !fromSystem,
      title: i18n.themeColor.text(),
      subtitle: "#${themeColor.hexAlpha}".text(),
      onTap: selectNewThemeColor,
      trailing: FilledCard(
        color: themeColor,
        clip: Clip.hardEdge,
        child: const SizedBox(
          width: 32,
          height: 32,
        ),
      ),
    );
  }

  Widget buildFromSystemToggle() {
    return ListTile(
      title: i18n.fromSystem.text(),
      trailing: Switch.adaptive(
        value: fromSystem,
        onChanged: (value) {
          setState(() {
            fromSystem = value;
          });
        },
      ),
    );
  }

  Future<void> onSave() async {
    Settings.theme.themeColor = themeColor;
    Settings.theme.themeColorFromSystem = fromSystem;
    final engine = WidgetsFlutterBinding.ensureInitialized();
    engine.performReassemble();
    if (!mounted) return;
    context.pop();
  }
}
