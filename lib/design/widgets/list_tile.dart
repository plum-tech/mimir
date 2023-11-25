import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/adaptive/dialog.dart';

class DetailListTile extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final bool copyable;

  const DetailListTile({
    super.key,
    this.title,
    this.subtitle,
    this.copyable = true,
  });

  @override
  Widget build(BuildContext context) {
    final subtitle = this.subtitle;
    return ListTile(
      title: title?.text(),
      subtitle: subtitle?.text(),
      visualDensity: VisualDensity.compact,
      onTap: copyable && subtitle != null
          ? () async {
              context.showSnackBar(content: "$title was copied".text());
              await Clipboard.setData(ClipboardData(text: subtitle));
            }
          : null,
    );
  }
}
