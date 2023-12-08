import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/adaptive/dialog.dart';
import 'package:sit/l10n/common.dart';

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
    return Tooltip(
      triggerMode: TooltipTriggerMode.tap,
      verticalOffset: 0,
      richMessage: TextSpan(
          text: const CommonI18n().copy,
          recognizer: copyable && subtitle != null
              ? (TapGestureRecognizer()
                ..onTap = () async {
                  final title = this.title;
                  if (title != null) {
                    context.showSnackBar(content: const CommonI18n().copyTipOf(title).text());
                  }
                  await Clipboard.setData(ClipboardData(text: subtitle));
                })
              : null),
      child: ListTile(
        leading: leading,
        trailing: trailing,
        title: title?.text(),
        subtitle: subtitle?.text(),
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}
