import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/adaptive/foundation.dart';
import 'package:sit/design/widgets/card.dart';
import 'package:sit/design/widgets/common.dart';
import 'package:sit/settings/settings.dart';
import 'package:sit/timetable/entity/background.dart';
import "../i18n.dart";

class TimetableBackgroundEditor extends StatefulWidget {
  const TimetableBackgroundEditor({super.key});

  @override
  State<TimetableBackgroundEditor> createState() => _TimetableBackgroundEditorState();
}

class _TimetableBackgroundEditorState extends State<TimetableBackgroundEditor> with SingleTickerProviderStateMixin {
  BackgroundImage? background = Settings.timetable.backgroundImage;
  late final AnimationController $opacity;

  @override
  void initState() {
    super.initState();
    $opacity = AnimationController(vsync: this, value: background?.opacity ?? 1.0);
  }

  @override
  void dispose() {
    $opacity.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final background = this.background;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            title: i18n.p13n.background.title.text(),
            actions: [
              if (background != null)
                PlatformTextButton(
                  child: i18n.delete.text(style: TextStyle(color: context.$red$)),
                  onPressed: () async {
                    setState(() {
                      this.background = null;
                    });
                  },
                ),
              if (background != Settings.timetable.backgroundImage)
                PlatformTextButton(
                  child: i18n.save.text(),
                  onPressed: () async {
                    Settings.timetable.backgroundImage = background;
                    context.pop(background);
                  },
                )
              else
                PlatformTextButton(
                  onPressed: pickImage,
                  child: i18n.pick.text(),
                ),
            ],
          ),
          if (background == null)
            SliverFillRemaining(
              child: LeavingBlank(
                icon: Icons.imagesearch_roller,
                desc: i18n.p13n.background.pickTip,
                onIconTap: pickImage,
              ),
            )
          else
            SliverList.list(children: [
              buildImage(background),
              buildOpacity(background),
              buildRepeat(background),
              buildAntialias(background),
            ]),
        ],
      ),
    );
  }

  Widget buildImage(BackgroundImage bk) {
    return OutlinedCard(
      clip: Clip.hardEdge,
      child: Image.file(
        File(bk.path),
        opacity: $opacity,
        height: context.mediaQuery.size.height / 3,
        filterQuality: bk.antialias ? FilterQuality.high : FilterQuality.none,
      ).inkWell(
        onTap: pickImage,
      ),
    );
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final XFile? fi = await picker.pickImage(
      source: ImageSource.gallery,
      requestFullMetadata: false,
    );
    if (fi == null) return;
    if (!mounted) return;
    final newBk = background?.copyWith(path: fi.path) ?? BackgroundImage(path: fi.path);
    setState(() {
      background = newBk;
    });
    setOpacity(newBk.opacity);
  }

  void setOpacity(double newValue) {
    final background = this.background;
    if (background != null && (background.opacity - newValue).abs() > 0.1) {
      $opacity.animateTo(
        newValue,
        duration: const Duration(milliseconds: 300),
      );
    } else {
      $opacity.value = newValue;
    }
  }

  Widget buildOpacity(BackgroundImage bk) {
    final value = bk.opacity;
    return ListTile(
      isThreeLine: true,
      leading: const Icon(Icons.invert_colors),
      title: i18n.p13n.background.opacity.text(),
      trailing: "${(value * 100).toInt()}%".toString().text(),
      subtitle: Slider(
        min: 0.0,
        max: 1.0,
        divisions: 255,
        label: (value * 255).toInt().toString(),
        value: value,
        onChanged: (double value) {
          setState(() {
            background = bk.copyWith(opacity: value);
          });
          setOpacity(value);
        },
      ),
    );
  }

  Widget buildRepeat(BackgroundImage bk) {
    return ListTile(
      leading: const Icon(Icons.repeat),
      title: i18n.p13n.background.repeat.text(),
      subtitle: i18n.p13n.background.repeatDesc.text(),
      trailing: Switch.adaptive(
        value: bk.repeat,
        onChanged: (newV) {
          setState(() {
            background = bk.copyWith(repeat: newV);
          });
        },
      ),
    );
  }

  Widget buildAntialias(BackgroundImage bk) {
    return ListTile(
      leading: const Icon(Icons.landscape),
      title: i18n.p13n.background.antialias.text(),
      subtitle: i18n.p13n.background.antialiasDesc.text(),
      trailing: Switch.adaptive(
        value: bk.antialias,
        onChanged: (newV) {
          setState(() {
            background = bk.copyWith(antialias: newV);
          });
        },
      ),
    );
  }
}
