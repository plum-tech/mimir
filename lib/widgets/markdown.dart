import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart';

import 'html.dart';

class FeaturedMarkdownWidget extends StatelessWidget {
  final String data;

  const FeaturedMarkdownWidget({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final html = markdownToHtml(
      data,
      inlineSyntaxes: [
        InlineHtmlSyntax(),
        StrikethroughSyntax(),
        AutolinkExtensionSyntax(),
        EmojiSyntax(),
      ],
      blockSyntaxes: const [
        FencedCodeBlockSyntax(),
        TableSyntax(),
      ],
    );
    return RestyledHtmlWidget(html);
  }
}
