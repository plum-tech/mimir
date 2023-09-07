import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mimir/utils/guard_launch.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/contact.dart';

class ContactTile extends StatelessWidget {
  final SchoolContact contact;
  final Color? bgColor;

  const ContactTile(this.contact, {super.key, this.bgColor});

  @override
  Widget build(BuildContext context) {
    final avatarStyle = context.textTheme.bodyMedium?.copyWith(color: Colors.grey[50]);
    final name = contact.name;
    final full = name == null ? contact.phone : "$name ${contact.phone}";
    final phoneNumber = contact.phone.length == 8 ? "021${contact.phone}" : contact.phone;
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor,
        radius: 20,
        child: Container(
            child: name == null
                ? Center(child: Icon(Icons.account_circle, size: 40, color: Colors.grey[50]))
                : name[0].text(
                    style: avatarStyle,
                    overflow: TextOverflow.ellipsis,
                  )),
      ),
      title: contact.description.toString().text(
            overflow: TextOverflow.ellipsis,
          ),
      subtitle: full.text(overflow: TextOverflow.ellipsis),
      tileColor: bgColor,
      trailing: phoneNumber.isEmpty
          ? null
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.phone),
                  onPressed: () {
                    guardLaunchUrlString(context, "tel:$phoneNumber");
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.content_copy),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: contact.phone));
                    // TODO: SnackBar
                    // context.showSnackBar(i18n.studentId.studentIdCopy2ClipboardTip.text());
                  },
                ),
              ],
            ),
    );
  }
}
