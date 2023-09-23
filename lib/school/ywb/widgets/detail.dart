import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mimir/widgets/html.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/application.dart';

class YwbApplicationDetailSectionBlock extends StatelessWidget {
  final YwbApplicationMetaDetailSection section;

  const YwbApplicationDetailSectionBlock(this.section, {super.key});

  @override
  Widget build(BuildContext context) {
    final bodyWidget = switch (section.type) {
      'html' => buildHtmlSection(section.content),
      'json' => buildJsonSection(section.content),
      _ => const SizedBox(),
    };

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(section.section, style: context.textTheme.headlineSmall),
          bodyWidget,
        ],
      ),
    );
  }

  Widget buildJsonSection(String content) {
    final Map kvPairs = jsonDecode(content);
    List<Widget> items = [];
    kvPairs.forEach((key, value) => items.add(Text('$key: $value')));
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: items);
  }

  Widget buildHtmlSection(String content) {
    // TODO: cannot download pdf files
    final html = content.replaceAll('../app/files/', 'https://xgfy.sit.edu.cn/app/files/');
    return StyledHtmlWidget(html);
  }
}
