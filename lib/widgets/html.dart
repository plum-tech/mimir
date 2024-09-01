import 'package:flame/palette.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/intent/deep_link/handle.dart';
import 'package:mimir/r.dart';
import 'package:mimir/utils/color.dart';
import 'package:mimir/utils/guard_launch.dart';
import 'package:mimir/utils/tel.dart';
import 'package:rettulf/rettulf.dart';

class RestyledHtmlWidget extends StatefulWidget {
  final String content;
  final RenderMode renderMode;
  final TextStyle? textStyle;
  final bool async;
  final bool keepOriginalFontSize;
  final bool linkifyPhoneNumbers;

  const RestyledHtmlWidget(
    this.content, {
    super.key,
    this.renderMode = RenderMode.column,
    this.textStyle,
    this.async = true,
    this.keepOriginalFontSize = false,
    this.linkifyPhoneNumbers = false,
  });

  @override
  State<RestyledHtmlWidget> createState() => _RestyledHtmlWidgetState();
}

class _RestyledHtmlWidgetState extends State<RestyledHtmlWidget> {
  late String html;

  @override
  void initState() {
    super.initState();
    html = buildHtml();
  }

  @override
  void didUpdateWidget(RestyledHtmlWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.content != widget.content || oldWidget.linkifyPhoneNumbers != widget.linkifyPhoneNumbers) {
      setState(() {
        html = buildHtml();
      });
    }
  }

  String buildHtml() {
    var html = widget.content;
    if (widget.linkifyPhoneNumbers) {
      html = linkifyPhoneNumbers(widget.content);
    }
    return html;
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = widget.textStyle ?? context.textTheme.bodyMedium;
    return HtmlWidget(
      html,
      buildAsync: widget.async,
      renderMode: widget.renderMode,
      factoryBuilder: () => RestyledWidgetFactory(
        textStyle: textStyle,
        borderColor: context.colorScheme.surfaceContainerHighest,
        darkMode: context.isDarkMode,
        keepOriginFontSize: widget.keepOriginalFontSize,
      ),
      textStyle: textStyle,
      onTapUrl: (url) async {
        final uri = Uri.tryParse(url);
        if (uri == null) return false;
        if (uri.scheme == R.scheme) {
          final result = await onHandleDeepLink(context: context, deepLink: uri);
          if (result == DeepLinkHandleResult.success) {
            return true;
          }
        }
        if (!context.mounted) return true;
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
  final bool darkMode;
  final bool keepOriginFontSize;

  RestyledWidgetFactory({
    this.textStyle,
    this.borderColor,
    required this.darkMode,
    required this.keepOriginFontSize,
  });

  @override
  InlineSpan? buildTextSpan({
    List<InlineSpan>? children,
    GestureRecognizer? recognizer,
    TextStyle? style,
    String? text,
  }) {
    var color = style?.color;
    if (darkMode && color != null && color.luminance < 0.5) {
      color = color.brighten(1 - color.luminance);
    }
    return super.buildTextSpan(
      children: children,
      recognizer: recognizer,
      style: textStyle?.copyWith(
        color: color,
        decoration: style?.decoration,
        decorationColor: style?.decorationColor,
        decorationStyle: style?.decorationStyle,
        decorationThickness: style?.decorationThickness,
        fontStyle: style?.fontStyle,
        fontSize: keepOriginFontSize ? style?.fontSize : null,
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
