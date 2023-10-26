import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart';

import 'html.dart';

class MyMarkdownWidget extends StatelessWidget {
  final String markdown;

  const MyMarkdownWidget(
    this.markdown, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final html = markdownToHtml(
      markdown,
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
