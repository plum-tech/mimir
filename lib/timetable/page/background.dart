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
  var background = Settings.timetable.backgroundImage ?? const BackgroundImage.disabled();
  late final AnimationController $opacity;

  @override
  void initState() {
    super.initState();
    $opacity = AnimationController(vsync: this, value: background.opacity);
  }

  @override
  void dispose() {
    $opacity.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final old = Settings.timetable.backgroundImage ?? const BackgroundImage.disabled();
    final background = this.background;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            title: i18n.p13n.background.title.text(),
            actions: [
              if (background.enabled)
                PlatformTextButton(
                  onPressed: () async {
                    setState(() {
                      this.background = const BackgroundImage.disabled();
                    });
                  },
                  child: i18n.delete.text(style: TextStyle(color: context.$red$)),
                ),
              if (background != old)
                PlatformTextButton(
                  child: i18n.save.text(),
                  onPressed: () async {
                    Settings.timetable.backgroundImage = background;
                    context.pop(background);
                  },
                ),
            ],
          ),
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
      child: buildPreviewBoxContent(bk).inkWell(
        onTap: pickImage,
      ),
    ).padH(10);
  }

  Widget buildPreviewBoxContent(BackgroundImage bk) {
    if (background.enabled) {
      return InteractiveViewer(
        child: Image.file(
          File(bk.path),
          opacity: $opacity,
          height: context.mediaQuery.size.height / 3,
          filterQuality: bk.antialias ? FilterQuality.low : FilterQuality.none,
        ),
      );
    } else {
      return LeavingBlank(
        icon: Icons.add_photo_alternate_outlined,
        desc: i18n.p13n.background.pickTip,
      );
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final XFile? fi = await picker.pickImage(
      source: ImageSource.gallery,
      requestFullMetadata: false,
    );
    if (fi == null) return;
    if (!mounted) return;
    final newBk = background.copyWith(path: fi.path);
    setState(() {
      background = newBk;
    });
    setOpacity(newBk.opacity);
  }

  void setOpacity(double newValue) {
    final background = this.background;
    if ((background.opacity - newValue).abs() > 0.1) {
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
