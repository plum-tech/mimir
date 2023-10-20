import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rettulf/rettulf.dart';
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
            title: "Background image".text(),
            actions: [
              PlatformTextButton(
                child: i18n.save.text(),
                onPressed: () async {
                  Settings.timetable.backgroundImage = background;
                  context.pop(background);
                },
              ),
            ],
          ),
          if (background == null)
            SliverFillRemaining(
              child: LeavingBlank(
                icon: Icons.imagesearch_roller,
                desc: "Upload your favorite image here",
                onIconTap: uploadImage,
                subtitle: PlatformTextButton(
                  onPressed: uploadImage,
                  child: "Upload".text(style: TextStyle(fontSize: context.textTheme.titleMedium?.fontSize)),
                ),
              ),
            )
          else
            SliverList.list(children: [
              buildImage(background),
              buildOpacity(background),
            ]),
        ],
      ),
    );
  }

  Widget buildImage(BackgroundImage bk) {
    return OutlinedCard(
      child: Image.file(
        File(bk.path),
        opacity: $opacity,
      ).inkWell(
        onTap: uploadImage,
      ),
    );
  }

  Widget buildOpacity(BackgroundImage bk) {
    final value = bk.opacity;
    return ListTile(
      isThreeLine: true,
      leading: const Icon(Icons.invert_colors),
      title: i18n.p13n.background.opacity.text(),
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
          if ((bk.opacity - value).abs() > 0.1) {
            $opacity.animateTo(
              value,
              duration: const Duration(milliseconds: 300),
            );
          } else {
            $opacity.value = value;
          }
        },
      ),
    );
  }

  Future<void> uploadImage() async {
    final picker = ImagePicker();
    final XFile? fi = await picker.pickImage(
      source: ImageSource.gallery,
      requestFullMetadata: false,
    );
    if (fi == null) return;
    if (!mounted) return;
    setState(() {
      background = BackgroundImage(path: fi.path);
    });
  }
}
