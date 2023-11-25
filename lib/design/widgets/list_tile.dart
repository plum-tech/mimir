import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/adaptive/dialog.dart';

class DetailListTile extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final bool copyable;

  const DetailListTile({
    super.key,
    this.title,
    this.subtitle,
    this.copyable = true,
    this.leading,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final subtitle = this.subtitle;
    return ListTile(
      leading: leading,
      trailing: trailing,
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
