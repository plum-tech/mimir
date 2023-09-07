import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mimir/design/widgets/dialog.dart';
import 'package:mimir/school/yellow_pages/init.dart';
import 'package:mimir/school/yellow_pages/storage/contact.dart';
import 'package:mimir/utils/guard_launch.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/contact.dart';

class ContactTile extends StatelessWidget {
  final SchoolContact contact;
  final Color? bgColor;

  const ContactTile(this.contact, {super.key, this.bgColor});

  @override
  Widget build(BuildContext context) {
    final name = contact.name;
    final full = name == null ? contact.phone : "$name ${contact.phone}";
    final phoneNumber = contact.phone.length == 8 ? "021${contact.phone}" : contact.phone;
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: context.colorScheme.primary,
        radius: 20,
        child: name == null
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
                  YellowPagesInit.storage.addHistory(contact);
                  await guardLaunchUrlString(context, "tel:$phoneNumber");
                },
              ),
              IconButton(
                icon: const Icon(Icons.content_copy),
                onPressed: () async {
                  YellowPagesInit.storage.addHistory(contact);
                  await Clipboard.setData(ClipboardData(text:  contact.phone));
                  if (!context.mounted) return;
                  context.showSnackBar("Phone number is copied".text());
                },
              ),
            ].row(mas: MainAxisSize.min),
    );
  }
}
