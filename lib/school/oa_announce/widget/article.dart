import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:mimir/utils/tel.dart';
import 'package:mimir/widgets/html.dart';

import '../entity/announce.dart';

class AnnounceArticle extends StatelessWidget {
  final OaAnnounceDetails details;

  const AnnounceArticle(
    this.details, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final htmlContent = linkifyPhoneNumbers(details.content);
    return RestyledHtmlWidget(
      htmlContent,
      renderMode: RenderMode.sliverList,
    );
  }
}
