import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/contact.dart';
import '../using.dart';

class ContactTile extends StatelessWidget {
  final ContactData contact;
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
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.content_copy),
            onPressed: () => Clipboard.setData(ClipboardData(text: contact.phone)),
          ),
          IconButton(
            icon: const Icon(Icons.phone),
            onPressed: () {
              launchUri("tel:$phoneNumber");
            },
          )
        ],
      ),
    );
  }
}
