import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sit/design/adaptive/dialog.dart';
import 'package:sit/school/yellow_pages/init.dart';
import 'package:sit/school/yellow_pages/storage/contact.dart';
import 'package:sit/utils/guard_launch.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/contact.dart';

class ContactTile extends StatelessWidget {
  final SchoolContact contact;
  final bool? inHistory;

  const ContactTile(
    this.contact, {
    super.key,
    this.inHistory,
  });

  @override
  Widget build(BuildContext context) {
    final name = contact.name;
    final full = name == null ? contact.phone : "$name, ${contact.phone}";
    final phoneNumber = contact.phone.length == 8 ? "021${contact.phone}" : contact.phone;
    return ListTile(
      selected: inHistory ?? false,
      leading: CircleAvatar(
        backgroundColor: context.colorScheme.primary,
        radius: 20,
        child: name == null || name.isEmpty || _isDigit(name[0])
            ? Center(child: Icon(Icons.account_circle, size: 40, color: context.colorScheme.onPrimary))
            : name[0]
                .text(
                  style: context.textTheme.titleLarge?.copyWith(color: context.colorScheme.onPrimary),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                )
                .center(),
      ),
      title: contact.description.toString().text(
            overflow: TextOverflow.ellipsis,
          ),
      subtitle: full.text(overflow: TextOverflow.ellipsis),
      trailing: phoneNumber.isEmpty
          ? null
          : [
              IconButton(
                icon: const Icon(Icons.phone),
                onPressed: () async {
                  YellowPagesInit.storage.addInteractHistory(contact);
                  await guardLaunchUrlString(context, "tel:$phoneNumber");
                },
              ),
              IconButton(
                icon: const Icon(Icons.content_copy),
                onPressed: () async {
                  YellowPagesInit.storage.addInteractHistory(contact);
                  await Clipboard.setData(ClipboardData(text: contact.phone));
                  if (!context.mounted) return;
                  context.showSnackBar("Phone number is copied".text());
                },
              ),
            ].row(mas: MainAxisSize.min),
    );
  }
}

bool _isDigit(String char) {
  return (char.codeUnitAt(0) ^ 0x30) <= 9;
}
