import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/utils/guard_launch.dart';
import 'package:rettulf/rettulf.dart';

class StyledHtmlWidget extends StatelessWidget {
  final String html;
  final bool isSelectable;
  final RenderMode renderMode;
  final TextStyle? textStyle;

  const StyledHtmlWidget(
    this.html, {
    Key? key,
    this.isSelectable = true,
    this.renderMode = RenderMode.column,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = this.textStyle ?? context.textTheme.bodyMedium;
    Widget widget = HtmlWidget(
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
        context.push(title != null ? "/image/$title" : "/image", extra: url);
      },
    );
    if (isSelectable) {
      widget = SelectionArea(child: widget);
    }
    return widget;
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
      style: textStyle ?? style,
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
