import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/adaptive/multiplatform.dart';
import 'package:sit/design/widgets/common.dart';
import 'package:sit/files.dart';
import 'package:sit/settings/dev.dart';
import 'package:sit/settings/settings.dart';
import 'package:sit/timetable/entity/background.dart';
import 'package:sit/widgets/modal_image_view.dart';
import 'package:universal_platform/universal_platform.dart';
import "../../i18n.dart";

class TimetableBackgroundEditor extends StatefulWidget {
  const TimetableBackgroundEditor({super.key});

  @override
  State<TimetableBackgroundEditor> createState() => _TimetableBackgroundEditorState();
}

class _TimetableBackgroundEditorState extends State<TimetableBackgroundEditor> with SingleTickerProviderStateMixin {
  String? rawPath;
  File? renderImageFile;
  double opacity = 1.0;
  bool repeat = true;
  bool antialias = true;
  late final AnimationController $opacity;

  _TimetableBackgroundEditorState() {
    final bk = Settings.timetable.backgroundImage;
    rawPath = bk?.path;
    renderImageFile = bk?.path == null ? null : Files.timetable.backgroundFile;
    opacity = bk?.opacity ?? 1.0;
    repeat = bk?.repeat ?? true;
    antialias = bk?.antialias ?? true;
  }

  @override
  void initState() {
    super.initState();
    $opacity = AnimationController(vsync: this, value: opacity);
  }

  @override
  void dispose() {
    $opacity.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rawPath = this.rawPath;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            title: i18n.p13n.background.title.text(),
            actions: [
              PlatformTextButton(
                onPressed: buildBackgroundImage() == Settings.timetable.backgroundImage ? null : onSave,
                child: i18n.save.text(),
              ),
            ],
          ),
          SliverList.list(children: [
            buildImage().padH(10),
            buildToolBar().padV(4),
            if (Dev.on && rawPath != null)
              ListTile(
                title: "Selected image".text(),
                subtitle: rawPath.text(),
              ),
            buildOpacity(),
            buildRepeat(),
            buildAntialias(),
          ]),
        ],
      ),
    );
  }

  Future<void> onSave() async {
    final background = buildBackgroundImage();
    final img = FileImage(Files.timetable.backgroundFile);
    if (background == null) {
      if (await Files.timetable.backgroundFile.exists()) {
        await Files.timetable.backgroundFile.delete();
      }
      await img.evict();
      Settings.timetable.backgroundImage = null;
      if (!mounted) return;
      context.pop(null);
    } else {
      final renderImageFile = this.renderImageFile;
      if (renderImageFile == null) return;
      Settings.timetable.backgroundImage = background;
      if (renderImageFile.path != Files.timetable.backgroundFile.path) {
        await copyCompressedImageToTarget(source: renderImageFile, target: Files.timetable.backgroundFile.path);
        await img.evict();
        if (!mounted) return;
        await precacheImage(img, context);
      }
      if (!mounted) return;
      context.pop(background);
    }
  }

  Future<void> copyCompressedImageToTarget({
    required File source,
    required String target,
  }) async {
    if (source.path == target) return;
    if (UniversalPlatform.isAndroid || UniversalPlatform.isIOS || UniversalPlatform.isMacOS) {
      FlutterImageCompress.validator.ignoreCheckExtName = true;
      await FlutterImageCompress.compressAndGetFile(
        source.path,
        target,
      );
    } else {
      source.copy(target);
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
    setState(() {
      rawPath = fi.path;
      renderImageFile = File(fi.path);
    });
    setOpacity(opacity);
  }

  BackgroundImage? buildBackgroundImage() {
    final path = rawPath;
    if (path == null) return null;
    return BackgroundImage(
      path: path,
      opacity: opacity,
      repeat: repeat,
      antialias: antialias,
    );
  }

  Widget buildToolBar() {
    return [
      FilledButton.icon(
        onPressed: pickImage,
        icon: Icon(context.icons.create),
        label: i18n.choose.text(),
      ),
      OutlinedButton.icon(
        onPressed: renderImageFile == null
            ? null
            : () {
                setState(() {
                  rawPath = null;
                  renderImageFile = null;
                });
              },
        icon: Icon(context.icons.delete),
        label: i18n.delete.text(),
      ),
    ].row(maa: MainAxisAlignment.spaceEvenly);
  }

  Widget buildImage() {
    return Card.outlined(
      clipBehavior: Clip.hardEdge,
      child: buildPreviewBoxContent(),
    );
  }

  Widget buildPreviewBoxContent() {
    final renderImageFile = this.renderImageFile;
    final height = context.mediaQuery.size.height / 3;
    if (renderImageFile != null) {
      return ModalImageViewer(
        child: Image.file(
          renderImageFile,
          opacity: $opacity,
          height: height,
          filterQuality: antialias ? FilterQuality.low : FilterQuality.none,
        ),
      );
    } else {
      return LeavingBlank(
        icon: Icons.add_photo_alternate_outlined,
        desc: i18n.p13n.background.pickTip,
        onIconTap: renderImageFile == null ? pickImage : null,
      ).sized(h: height);
    }
  }

  void setOpacity(double newValue) {
    setState(() {
      opacity = newValue;
    });
    $opacity.animateTo(
      newValue,
      duration: Durations.short3,
    );
  }

  Widget buildOpacity() {
    final value = opacity;
    return ListTile(
      isThreeLine: true,
      leading: const Icon(Icons.invert_colors),
      title: i18n.p13n.background.opacity.text(),
      trailing: "${(value * 100).toInt()}%".toString().text(),
      subtitle: Slider(
        min: 0.0,
        max: 1.0,
        divisions: 255,
        label: "${(value * 100).toInt()}%",
        value: value,
        onChanged: (double value) {
          setOpacity(value);
        },
      ),
    );
  }

  Widget buildRepeat() {
    return ListTile(
      leading: const Icon(Icons.repeat),
      title: i18n.p13n.background.repeat.text(),
      subtitle: i18n.p13n.background.repeatDesc.text(),
      trailing: Switch.adaptive(
        value: repeat,
        onChanged: (newV) {
          setState(() {
            repeat = newV;
          });
        },
      ),
    );
  }

  Widget buildAntialias() {
    return ListTile(
      leading: const Icon(Icons.landscape),
      title: i18n.p13n.background.antialias.text(),
      subtitle: i18n.p13n.background.antialiasDesc.text(),
      trailing: Switch.adaptive(
        value: antialias,
        onChanged: (newV) {
          setState(() {
            antialias = newV;
          });
        },
      ),
    );
  }
}
