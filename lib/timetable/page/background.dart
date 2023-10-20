import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/widgets/common.dart';
import 'package:sit/settings/settings.dart';
import 'package:sit/timetable/entity/background.dart';
import "../i18n.dart";

class TimetableBackgroundEditor extends StatefulWidget {
  const TimetableBackgroundEditor({super.key});

  @override
  State<TimetableBackgroundEditor> createState() => _TimetableBackgroundEditorState();
}

class _TimetableBackgroundEditorState extends State<TimetableBackgroundEditor> {
  BackgroundImage? background = Settings.timetable.backgroundImage;

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
                desc: "Let's upload a background image!",
                subtitle: PlatformTextButton(
                  child: "Upload".text(style: TextStyle(fontSize: context.textTheme.titleMedium?.fontSize)),
                  onPressed: () async {
                    await uploadImage();
                  },
                ),
              ),
            )
          else
            SliverList.list(children: [
              Image.file(File(background.path)),
            ]),
        ],
      ),
    );
  }

  Widget buildImage() {
    return const Placeholder();
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
