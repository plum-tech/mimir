import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:sit/widgets/html.dart';

import '../entity/announce.dart';

class AnnounceArticle extends StatelessWidget {
  final OaAnnounceDetails details;

  const AnnounceArticle(this.details, {super.key});

  @override
  Widget build(BuildContext context) {
    final htmlContent = _linkTel(details.content);
    return StyledHtmlWidget(
      htmlContent,
      renderMode: RenderMode.sliverList,
    );
  }
}

final RegExp _phoneRegex = RegExp(r"(6087\d{4})");
final RegExp _mobileRegex = RegExp(r"(\d{12})");

String _linkTel(String content) {
  String t = content;
  for (var phone in _phoneRegex.allMatches(t)) {
    final num = phone.group(0).toString();
    t = t.replaceAll(num, '<a href="tel:021$num">$num</a>');
  }
  for (var mobile in _mobileRegex.allMatches(content)) {
    final num = mobile.group(0).toString();
    t = t.replaceAll(num, '<a href="tel:$num">$num</a>');
  }
  return t;
}
