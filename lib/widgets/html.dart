import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:go_router/go_router.dart';
import 'package:sit/utils/guard_launch.dart';
import 'package:rettulf/rettulf.dart';

class StyledHtmlWidget extends StatelessWidget {
  final String html;
  final RenderMode renderMode;
  final TextStyle? textStyle;

  const StyledHtmlWidget(
    this.html, {
    super.key,
    this.renderMode = RenderMode.column,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = this.textStyle ?? context.textTheme.bodyMedium;
    return HtmlWidget(
      html,
      buildAsync: true,
      renderMode: renderMode,
      factoryBuilder: () => StyledWidgetFactory(textStyle: textStyle),
      textStyle: textStyle,
      onTapUrl: (url) async {
        return await guardLaunchUrlString(context, url);
      },
      onTapImage: (ImageMetadata image) {
        final url = image.sources.toList().firstOrNull?.url;
        final title = image.title ?? image.alt;
        context.push(title != null ? "/image?title=$title" : "/image", extra: url);
      },
    );
  }
}

class StyledWidgetFactory extends WidgetFactory {
  final TextStyle? textStyle;
  StyledWidgetFactory({
    required this.textStyle,
  });

  @override
  InlineSpan? buildTextSpan({
    List<InlineSpan>? children,
    GestureRecognizer? recognizer,
    TextStyle? style,
    String? text,
  }) {
    return super.buildTextSpan(
      children: children,
      recognizer: recognizer,
      style: style?.copyWith(
        fontSize: textStyle?.fontSize,
        textBaseline: textStyle?.textBaseline,
        fontWeight: textStyle?.fontWeight,
        backgroundColor: textStyle?.backgroundColor,
        background: textStyle?.background,
        leadingDistribution: textStyle?.leadingDistribution,
        locale: textStyle?.locale,
        height: textStyle?.height,
        shadows: textStyle?.shadows,
        fontFeatures: textStyle?.fontFeatures,
        decorationColor: textStyle?.decorationColor,
        decorationStyle: textStyle?.decorationStyle,
        decorationThickness: textStyle?.decorationThickness,
        wordSpacing: textStyle?.wordSpacing,
        letterSpacing: textStyle?.letterSpacing,
      ),
      text: text,
    );
  }

  @override
  Widget? buildDecoration(
    BuildMetadata meta,
    Widget child, {
    BoxBorder? border,
    BorderRadius? borderRadius,
    Color? color,
    bool isBorderBox = true,
  }) {
    return super.buildDecoration(
      meta,
      child,
      border: border,
      borderRadius: borderRadius,
      color: Colors.transparent,
      isBorderBox: isBorderBox,
    );
  }
}
