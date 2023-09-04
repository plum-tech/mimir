import 'package:flutter/material.dart';
import 'package:mimir/mini_apps/timetable/using.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:rettulf/rettulf.dart';

enum PlaceholderType {
  drop,
  beat,
}

class LoadingPlaceholder extends StatelessWidget {
  final double size;
  final PlaceholderType type;

  const LoadingPlaceholder({super.key, this.size = 24.0, required this.type});

  const LoadingPlaceholder.drop({Key? key, double size = 24.0})
      : this(key: key, size: size, type: PlaceholderType.drop);

  const LoadingPlaceholder.beat({Key? key, double size = 24.0})
      : this(key: key, size: size, type: PlaceholderType.beat);

  @override
  Widget build(BuildContext context) {
    final trackColor = ProgressIndicatorTheme.of(context).circularTrackColor ?? context.darkSafeThemeColor;
    final iconSize = size * 0.7;
    final indicator= switch (type) {
      PlaceholderType.drop => LoadingAnimationWidget.inkDrop(color: trackColor, size: iconSize),
      PlaceholderType.beat => LoadingAnimationWidget.beat(color: trackColor, size: iconSize),
    };
    return indicator.sizedAll(size);
  }
}

extension LazyLoadingEffectEx<T> on Future<T> {
  Future<T> withDelay(Duration duration) async {
    final res = await this;
    await Future.delayed(duration);
    return res;
  }
}
