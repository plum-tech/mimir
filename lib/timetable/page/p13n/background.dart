import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/adaptive/dialog.dart';
import 'package:sit/design/adaptive/editor.dart';
import 'package:sit/design/adaptive/multiplatform.dart';
import 'package:sit/design/widgets/common.dart';
import 'package:sit/files.dart';
import 'package:sit/settings/dev.dart';
import 'package:sit/settings/settings.dart';
import 'package:sit/timetable/entity/background.dart';
import 'package:sit/utils/images.dart';
import 'package:sit/utils/save.dart';
import 'package:sit/widgets/modal_image_view.dart';
import 'package:universal_platform/universal_platform.dart';
import "../../i18n.dart";

/// It persists changes to storage before route popping
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
    if (!kIsWeb) {
      renderImageFile = bk?.path == null ? null : Files.timetable.backgroundFile;
    }
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
    final canSave = buildBackgroundImage() != Settings.timetable.backgroundImage;
    return PromptSaveBeforeQuitScope(
      canSave: canSave,
      onSave: onSave,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar.medium(
              title: i18n.p13n.background.title.text(),
              actions: [
                PlatformTextButton(
                  onPressed: !canSave ? null : onSave,
                  child: i18n.save.text(),
                ),
              ],
            ),
            SliverList.list(children: [
              buildImage().padH(10),
              buildToolBar().padV(4),
              if (rawPath != null && (Dev.on || (UniversalPlatform.isDesktop || kIsWeb)))
                ListTile(
                  title: i18n.p13n.background.selectedImage.text(),
                  subtitle: rawPath.text(),
                ),
              buildOpacity(),
              buildRepeat(),
              buildAntialias(),
            ]),
          ],
        ),
      ),
    );
  }

  Future<void> onSave() async {
    if (kIsWeb) {
      await onSaveWeb();
    } else {
      await onSaveIo();
    }
  }

  Future<void> onSaveWeb() async {
    final background = buildBackgroundImage();
    if (background == null) {
      Settings.timetable.backgroundImage = background;
      context.pop(null);
      return;
    }
    final img = NetworkImage(background.path);
    Settings.timetable.backgroundImage = background;
    await precacheImage(img, context);
    if (!mounted) return;
    context.pop(background);
  }

  Future<void> onSaveIo() async {
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
      return;
    }
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

  Future<void> chooseImage() async {
    if (kIsWeb) {
      await inputImageUrl();
    } else {
      await pickImage();
    }
  }

  Future<void> inputImageUrl() async {
    final url = await Editor.showStringEditor(
      context,
      desc: i18n.p13n.background.imageURL,
      initial: rawPath ?? "",
    );
    if (url == null) return;
    final uri = Uri.tryParse(url);
    if (!mounted) return;
    if (uri == null || !uri.isScheme("http") && !uri.isScheme("https")) {
      await context.showTip(
        title: i18n.p13n.background.invalidURL,
        desc: i18n.p13n.background.invalidURLDesc,
        primary: i18n.ok,
      );
      return;
    }
    setState(() {
      rawPath = uri.toString();
    });
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
        onPressed: chooseImage,
        icon: Icon(context.icons.create),
        label: i18n.choose.text(),
      ),
      OutlinedButton.icon(
        onPressed: (kIsWeb ? rawPath == null : renderImageFile == null)
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
    final rawPath = this.rawPath;
    final filterQuality = antialias ? FilterQuality.low : FilterQuality.none;
    if (renderImageFile != null) {
      return ModalImageViewer(
        child: Image.file(
          renderImageFile,
          opacity: $opacity,
          height: height,
          filterQuality: filterQuality,
        ),
      );
    } else if (kIsWeb && rawPath != null) {
      return ModalImageViewer(
        child: Image.network(
          rawPath,
          opacity: $opacity,
          height: height,
          filterQuality: filterQuality,
        ),
      );
    } else {
      return LeavingBlank(
        icon: Icons.add_photo_alternate_outlined,
        desc: i18n.p13n.background.pickTip,
        onIconTap: renderImageFile == null ? chooseImage : null,
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
