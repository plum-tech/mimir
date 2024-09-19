import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mimir/design/adaptive/dialog.dart';
import 'package:mimir/design/adaptive/multiplatform.dart';
import 'package:mimir/school/yellow_pages/init.dart';
import 'package:mimir/school/yellow_pages/storage/contact.dart';
import 'package:rettulf/rettulf.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../entity/contact.dart';
import '../i18n.dart';

class ContactAvatar extends StatelessWidget {
  final String? name;

  const ContactAvatar({
    super.key,
    this.name,
  });

  @override
  Widget build(BuildContext context) {
    final name = this.name;
    return CircleAvatar(
      backgroundColor: context.colorScheme.primary,
      radius: 20,
      child: name == null || name.isEmpty || _isDigit(name[0])
          ? Icon(
              context.icons.accountCircle,
              size: 40,
              color: context.colorScheme.onPrimary,
            ).center()
          : name[0]
              .text(
                style: context.textTheme.titleLarge?.copyWith(color: context.colorScheme.onPrimary),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              )
              .center(),
    );
  }
}

class ContactTile extends StatelessWidget {
  final String? name;
  final String phone;
  final String title;
  final bool selected;
  final VoidCallback? onCopied;
  final VoidCallback? onCalled;

  const ContactTile({
    this.name,
    required this.phone,
    super.key,
    this.selected = false,
    required this.title,
    this.onCopied,
    this.onCalled,
  });

  @override
  Widget build(BuildContext context) {
    final name = this.name;
    final full = name == null ? phone : "$name, $phone";
    final phoneNumber = phone.length == 8 ? "021$phone" : phone;
    return ListTile(
      selected: selected,
      leading: ContactAvatar(name: name),
      title: title.text(overflow: TextOverflow.ellipsis),
      subtitle: full.text(overflow: TextOverflow.ellipsis),
      onLongPress: phoneNumber.isEmpty
          ? null
          : () async {
              context.showSnackBar(content: i18n.copyTipOf(phoneNumber).text());
              await Clipboard.setData(ClipboardData(text: phoneNumber));
            },
      trailing: phoneNumber.isEmpty
          ? null
          : IconButton.filledTonal(
              icon: const Icon(Icons.phone),
              onPressed: () async {
                await launchUrlString("tel:$phoneNumber", mode: LaunchMode.externalApplication);
              },
            ),
    );
  }
}

bool _isDigit(String char) {
  return (char.codeUnitAt(0) ^ 0x30) <= 9;
}

class SchoolContactTile extends StatelessWidget {
  final SchoolContact contact;
  final bool? inHistory;

  const SchoolContactTile(
    this.contact, {
    super.key,
    this.inHistory,
  });

  @override
  Widget build(BuildContext context) {
    return ContactTile(
      name: contact.name,
      title: contact.description ?? contact.name ?? contact.phone,
      phone: contact.phone,
      selected: inHistory ?? false,
      onCalled: () {
        YellowPagesInit.storage.addInteractHistory(contact);
      },
      onCopied: () {
        YellowPagesInit.storage.addInteractHistory(contact);
      },
    );
  }
}
