import 'package:flutter/material.dart';
import 'package:mimir/module/timetable/using.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:rettulf/rettulf.dart';

typedef PlaceholderDecorator = Widget Function(Widget);

class Placeholders {
  static Widget loading({
    Key? key,
    double size = 40,
    PlaceholderDecorator? fix,
  }) {
    return _LoadingPlaceholder(
      size: size,
      fix: fix,
    );
  }

  static Widget progress({
    Key? key,
    double size = 40,
    PlaceholderDecorator? fix,
  }) {
    return _ProgressPlaceholder(
      size: size,
      fix: fix,
    );
  }
}

class _LoadingPlaceholder extends StatelessWidget {
  final double size;
  final PlaceholderDecorator? fix;

  const _LoadingPlaceholder({required this.size, this.fix});

  @override
  Widget build(BuildContext context) {
    final trackColor = ProgressIndicatorTheme.of(context).circularTrackColor;
    Widget indicator = LoadingAnimationWidget.inkDrop(color: trackColor ?? context.darkSafeThemeColor, size: size);
    final decorator = fix;
    if (decorator != null) {
      indicator = decorator(indicator);
    }
    return indicator.center();
  }
}

class _ProgressPlaceholder extends StatelessWidget {
  final double size;
  final PlaceholderDecorator? fix;

  const _ProgressPlaceholder({required this.size, this.fix});

  @override
  Widget build(BuildContext context) {
    final trackColor = ProgressIndicatorTheme.of(context).circularTrackColor;
    Widget indicator = LoadingAnimationWidget.beat(color: trackColor ?? context.darkSafeThemeColor, size: size);
    final decorator = fix;
    if (decorator != null) {
      indicator = decorator(indicator);
    }
    return indicator.center();
  }
}

extension LazyLoadingEffectEx<T> on Future<T> {
  Future<T> withDelay(Duration duration) async {
    final res = await this;
    await Future.delayed(duration);
    return res;
  }
}
