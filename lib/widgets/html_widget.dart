import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:mimir/launcher.dart';
import 'package:mimir/util/logger.dart';

import 'image_viewer.dart';

class MyHtmlWidget extends StatelessWidget {
  final String html;
  final bool isSelectable;
  final RenderMode renderMode;
  final TextStyle? textStyle;

  const MyHtmlWidget(
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
      renderMode: renderMode,
      textStyle: textStyle ?? Theme.of(context).textTheme.bodyMedium,
      onTapUrl: (url) async {
        await GlobalLauncher.launch(url);
        return true;
      },
      onTapImage: (ImageMetadata image) {
        final url = image.sources.toList()[0].url;
        Log.info('图片被点击: $url');
        MyImageViewer.showNetworkImagePage(context, url);
      },
    );
    if (isSelectable) {
      widget = SelectionArea(child: widget);
    }
    widget = SingleChildScrollView(child: widget);
    return widget;
  }
}
