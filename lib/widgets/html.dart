import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:go_router/go_router.dart';
import 'package:sit/utils/guard_launch.dart';
import 'package:rettulf/rettulf.dart';

class RestyledHtmlWidget extends StatelessWidget {
  final String html;
  final RenderMode renderMode;
  final TextStyle? textStyle;

  const RestyledHtmlWidget(
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
      factoryBuilder: () => RestyledWidgetFactory(
        textStyle: textStyle,
        borderColor: context.colorScheme.surfaceVariant,
      ),
      textStyle: textStyle,
      onTapUrl: (url) async {
        return await guardLaunchUrlString(context, url);
      },
      onTapImage: (ImageMetadata image) {
        final url = image.sources.toList().firstOrNull?.url;
        final title = image.title ?? image.alt;
        context.push(
          Uri(path: "/image", queryParameters: {
            if (title != null && title.isNotEmpty) "title": title,
            if (url?.startsWith("http") == true) "origin": url,
          }).toString(),
          extra: url,
        );
      },
    );
  }
}

class RestyledWidgetFactory extends WidgetFactory {
  final TextStyle? textStyle;
  final Color? borderColor;

  RestyledWidgetFactory({
    this.textStyle,
    this.borderColor,
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
      style: textStyle?.copyWith(
        color: style?.color,
        decoration: style?.decoration,
        decorationColor: style?.decorationColor,
        decorationStyle: style?.decorationStyle,
        decorationThickness: style?.decorationThickness,
        fontStyle: style?.fontStyle,
      ),
      text: text,
    );
  }

  @override
  Widget? buildDecoration(
    BuildTree tree,
    Widget child, {
    BoxBorder? border,
    BorderRadius? borderRadius,
    Color? color,
    DecorationImage? image,
  }) {
    return super.buildDecoration(
      tree,
      child,
      border: _restyleBorder(border, borderColor),
      borderRadius: borderRadius,
      color: Colors.transparent,
      image: image,
    );
  }
}

BoxBorder? _restyleBorder(BoxBorder? border, Color? color) {
  if (border is Border) {
    return Border(
      top: _restyleBorderSide(border.top, color),
      right: _restyleBorderSide(border.right, color),
      bottom: _restyleBorderSide(border.top, color),
      left: _restyleBorderSide(border.left, color),
    );
  } else {
    return border;
  }
}

BorderSide _restyleBorderSide(BorderSide side, Color? color) {
  return side.copyWith(color: color);
}
