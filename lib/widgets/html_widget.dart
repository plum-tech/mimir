import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:mimir/utils/guard_launch.dart';
import 'package:rettulf/rettulf.dart';

import 'image_viewer.dart';

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
    Widget widget = HtmlWidget(
      html,
      buildAsync: true,
      renderMode: renderMode,
      factoryBuilder: () => StyledWidgetFactory(textStyle: context.textTheme.bodyMedium),
      textStyle: textStyle ?? context.textTheme.bodyMedium,
      onTapUrl: (url) async {
        return await guardLaunchUrlString(context, url);
      },
      onTapImage: (ImageMetadata image) {
        final url = image.sources.toList()[0].url;
        MyImageViewer.showNetworkImagePage(context, url);
      },
    );
    if (isSelectable) {
      widget = SelectionArea(child: widget);
    }
    widget = SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: widget,
    );
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
