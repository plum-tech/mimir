import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mimir/timetable/p13n/page/palette.dart';
import 'package:mimir/utils/permission.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rettulf/rettulf.dart';
import 'package:mimir/design/adaptive/dialog.dart';
import 'package:mimir/design/adaptive/editor.dart';
import 'package:mimir/design/adaptive/multiplatform.dart';
import 'package:mimir/design/widget/common.dart';
import 'package:mimir/files.dart';
import 'package:mimir/settings/dev.dart';
import 'package:mimir/settings/settings.dart';
import 'package:mimir/utils/images.dart';
import 'package:mimir/utils/save.dart';
import 'package:mimir/widget/modal_image_view.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:palette_generator/palette_generator.dart';

import "../../i18n.dart";
import '../entity/background.dart';
import '../utils/generate.dart';

/// It persists changes to storage before route popping
class TimetableBackgroundEditor extends ConsumerStatefulWidget {
  const TimetableBackgroundEditor({super.key});

  @override
  ConsumerState<TimetableBackgroundEditor> createState() => _TimetableBackgroundEditorState();
}

class _TimetableBackgroundEditorState extends ConsumerState<TimetableBackgroundEditor>
    with SingleTickerProviderStateMixin {
  PaletteGenerator? paletteGen;
  String? rawPath;
  File? renderImageFile;
  double opacity = 1.0;
  bool repeat = true;
  bool antialias = true;
  bool hidden = false;
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
    hidden = bk?.hidden ?? false;
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
    final renderImageFile = this.renderImageFile;
    return PromptSaveBeforeQuitScope(
      changed: shouldSave(),
      onSave: onSave,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar.medium(
              title: i18n.p13n.background.title.text(),
              actions: [
                PlatformTextButton(
                  onPressed: onSave,
                  child: i18n.save.text(),
                ),
              ],
            ),
            SliverList.list(children: [
              onHidden(
                child: buildImage(),
              ).padH(10),
              onHidden(
                child: buildToolBar(),
              ).padV(4),
              if (rawPath != null && (Dev.on || (UniversalPlatform.isDesktop || kIsWeb)))
                ListTile(
                  title: i18n.p13n.background.selectedImage.text(),
                  subtitle: rawPath.text(),
                ),
              buildOpacity(),
              buildImmersive(),
              buildRepeat(),
              buildAntialias(),
              if (Dev.on && renderImageFile != null)
                [
                  FilledButton.icon(
                    label: "Extract colors".text(),
                    onPressed: () async {
                      final generator = await PaletteGenerator.fromImageProvider(
                        FileImage(renderImageFile),
                        maximumColorCount: 12,
                        targets: PaletteTarget.baseTargets,
                      );
                      setState(() {
                        paletteGen = generator;
                      });
                    },
                  ).center(),
                  if (paletteGen != null)
                    paletteGen!.paletteColors
                        .map((color) => ColorSquareCard(
                              color: color.color,
                              textColor: color.titleTextColor,
                            ))
                        .toList()
                        .wrap(spacing: 4, runSpacing: 4),
                ].column(),
            ]),
          ],
        ),
        persistentFooterButtons: [
          if (renderImageFile != null)
            FilledButton.tonalIcon(
              icon: const Icon(Icons.generating_tokens_outlined),
              label: i18n.p13n.background.generatePalette.text(),
              onPressed: () async {
                final added = await addPaletteFromImageByGenerator(
                  context,
                  FileImage(renderImageFile),
                );
                if (added) {
                if (!context.mounted) return;
                  context.push("/timetable/palettes/custom");
                }
              },
            ),
        ],
        persistentFooterAlignment: AlignmentDirectional.center,
      ),
    );
  }

  Widget onHidden({required Widget child}) {
    return AnimatedOpacity(
      opacity: hidden ? 0.3 : 1.0,
      duration: Durations.short4,
      child: child,
    );
  }

  bool shouldSave() {
    return buildBackgroundImage() != Settings.timetable.backgroundImage;
  }

  Future<void> onSave() async {
    if (!shouldSave()) {
      context.pop(null);
      return;
    }
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
      await copyCompressedImageToTarget(
        source: renderImageFile,
        target: Files.timetable.backgroundFile.path,
      );
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
    await requestPermission(context, Permission.photos);
    final picker = ImagePicker();
    final XFile? fi = await picker.pickImage(
      source: ImageSource.gallery,
      requestFullMetadata: false,
    );
    if (fi == null) return;
    if (!mounted) return;
    final file = File(fi.path);
    setState(() {
      rawPath = fi.path;
      renderImageFile = file;
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
      hidden: hidden,
    );
  }

  Widget buildToolBar() {
    final hasImage = kIsWeb ? rawPath != null : renderImageFile != null;
    return [
      FilledButton.icon(
        onPressed: chooseImage,
        icon: Icon(context.icons.create),
        label: i18n.choose.text(),
      ).center().expanded(flex: 3),
      IconButton.filledTonal(
        onPressed: hasImage
            ? () {
                setState(() {
                  hidden = !hidden;
                });
              }
            : null,
        icon: Icon(hidden ? Icons.hide_image_outlined : Icons.image_outlined),
      ).center().expanded(flex: 1),
      OutlinedButton.icon(
        onPressed: hasImage
            ? () {
                setState(() {
                  rawPath = null;
                  renderImageFile = null;
                });
              }
            : null,
        icon: Icon(context.icons.delete),
        label: i18n.delete.text(),
      ).center().expanded(flex: 3),
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
        hereTag: rawPath,
        child: Image.file(
          renderImageFile,
          opacity: $opacity,
          height: height,
          filterQuality: filterQuality,
        ),
      );
    } else if (kIsWeb && rawPath != null) {
      return ModalImageViewer(
        hereTag: rawPath,
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

  Widget buildImmersive() {
    final immersiveWallpaper = ref.watch(Settings.timetable.$immersiveWallpaper);
    return SwitchListTile.adaptive(
      secondary: const Icon(Icons.vrpano_outlined),
      title: i18n.p13n.background.immersive.text(),
      subtitle: i18n.p13n.background.immersiveDesc.text(),
      value: immersiveWallpaper,
      onChanged: (v) {
        ref.read(Settings.timetable.$immersiveWallpaper.notifier).set(v);
      },
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
    return SwitchListTile.adaptive(
      secondary: const Icon(Icons.repeat),
      title: i18n.p13n.background.repeat.text(),
      subtitle: i18n.p13n.background.repeatDesc.text(),
      value: repeat,
      onChanged: (newV) {
        setState(() {
          repeat = newV;
        });
      },
    );
  }

  Widget buildAntialias() {
    return SwitchListTile.adaptive(
      secondary: const Icon(Icons.landscape),
      title: i18n.p13n.background.antialias.text(),
      subtitle: i18n.p13n.background.antialiasDesc.text(),
      value: antialias,
      onChanged: (newV) {
        setState(() {
          antialias = newV;
        });
      },
    );
  }
}
