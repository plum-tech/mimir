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
    final avatarStyle = context.textTheme.bodyText2?.copyWith(color: Colors.grey[50]);
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor,
        radius: 20,
        child: Container(
            child: (contact.name ?? '').isEmpty
                ? Center(child: Icon(Icons.account_circle, size: 40, color: Colors.grey[50]))
                : Text(
                    contact.name![0],
                    style: avatarStyle,
                    overflow: TextOverflow.ellipsis,
                  )),
      ),
      title: contact.description.text(
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        ('${contact.name ?? ' '} ${contact.phone}').trim(),
        overflow: TextOverflow.ellipsis,
      ),
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
              final phone = contact.phone;
              GlobalLauncher.launch('tel:${(phone.length == 8 ? '021' : '') + phone}');
            },
          )
        ],
      ),
    );
  }
}
