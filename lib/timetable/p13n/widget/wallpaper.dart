import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mimir/files.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/background.dart';

class WallpaperWidget extends StatelessWidget {
  final BackgroundImage background;
  final bool fade;
  final Duration fadeDuration;

  const WallpaperWidget({
    super.key,
    required this.background,
    this.fade = true,
    this.fadeDuration = Durations.long2,
  });

  @override
  Widget build(BuildContext context) {
    if (!background.enabled || background.hidden) {
      return const SizedBox.shrink();
    }
    if (kIsWeb) {
      return _WallpaperWebImpl(
        background: background,
      );
    } else {
      return _WallpaperImpl(
        background: background,
        fade: fade,
        fadeDuration: kDebugMode ? const Duration(milliseconds: 1000) : Durations.medium3,
      );
    }
  }
}

class WithWallpaper extends StatelessWidget {
  final BackgroundImage background;
  final Widget child;
  final bool fade;

  const WithWallpaper({
    super.key,
    required this.child,
    required this.background,
    this.fade = true,
  });

  @override
  Widget build(BuildContext context) {
    return [
      Positioned.fill(
        child: WallpaperWidget(
          background: background,
          fade: fade,
        ),
      ),
      child,
    ].stack();
  }
}

class _WallpaperImpl extends StatefulWidget {
  final BackgroundImage background;
  final bool fade;
  final Duration fadeDuration;

  const _WallpaperImpl({
    required this.background,
    this.fade = true,
    this.fadeDuration = Durations.long2,
  });

  @override
  State<_WallpaperImpl> createState() => _WallpaperImplState();
}

class _WallpaperImplState extends State<_WallpaperImpl> with SingleTickerProviderStateMixin {
  late final AnimationController $opacity;
  late final AppLifecycleListener _listener;

  DateTime? lastHiddenTime;

  @override
  void initState() {
    super.initState();
    $opacity = AnimationController(vsync: this, value: widget.fade ? 0.0 : widget.background.opacity);
    _listener = AppLifecycleListener(
      onHide: () {
        lastHiddenTime = DateTime.now();
      },
      onShow: () {
        final now = DateTime.now();
        if (widget.fade && now.difference(lastHiddenTime ?? now).inSeconds > 15) {
          final hasCache = PaintingBinding.instance.imageCache.containsKey(FileImage(File(widget.background.path)));
          if (!hasCache) {
            $opacity.value = 0;
          }
        }
      },
      onResume: () {
        if (widget.fade) {
          animateOpacity();
        }
      },
    );
    if (widget.fade) {
      animateOpacity();
    }
  }

  void animateOpacity() {
    $opacity.animateTo(
      widget.background.opacity,
      duration: widget.fadeDuration,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    $opacity.dispose();
    _listener.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _WallpaperImpl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.fade && oldWidget.fade) {
      if (oldWidget.background != widget.background) {
        if (oldWidget.background.path != widget.background.path) {
          $opacity.value = 0.0;
        }
        $opacity.animateTo(
          widget.background.opacity,
          duration: widget.fadeDuration,
          curve: Curves.easeInOut,
        );
      }
    } else {
      $opacity.value = widget.background.opacity;
    }
  }

  @override
  Widget build(BuildContext context) {
    final background = widget.background;
    return Image.file(
      Files.timetable.backgroundFile,
      opacity: $opacity,
      filterQuality: background.filterQuality,
      repeat: background.imageRepeat,
    );
  }
}

class _WallpaperWebImpl extends StatelessWidget {
  final BackgroundImage background;

  const _WallpaperWebImpl({
    required this.background,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: background.path,
      filterQuality: background.filterQuality,
      repeat: background.imageRepeat,
    );
  }
}
